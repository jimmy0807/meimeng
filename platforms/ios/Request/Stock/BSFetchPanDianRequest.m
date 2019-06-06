//
//  BSFetchPanDianRequest.m
//  Boss
//
//  Created by lining on 15/7/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchPanDianRequest.h"
#import "BSFetchPanDianItemRequest.h"

#define COUNT  15

@interface BSFetchPanDianRequest ()
@property(nonatomic, assign) NSInteger startIdx;
@property(nonatomic, strong) NSString *state;
@end

@implementation BSFetchPanDianRequest


- (id)initWithStartIndex:(NSInteger)startIdx state:(NSString *)state
{
    self = [super init];
    if (self) {
        self.startIdx = startIdx;
        self.state = state;
    }
    
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"stock.inventory";
    self.field = @[];
    self.filter = @[@[@"state",@"=",self.state]];
     NSArray *params = @[[NSNumber numberWithInt:self.startIdx],[NSNumber numberWithInt:COUNT],@"id desc"];
    [self sendShopAssistantXmlSearchReadCommand:params];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict;
    BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
    if ([retArray isKindOfClass:[NSArray class]]) {
        NSArray *panDians = [dataManager fetchPanDiansWithState:self.state];
        NSMutableArray *oldPanDians;
        if (self.startIdx == 0) {
            oldPanDians = [NSMutableArray arrayWithArray:panDians];
        }
        for (NSDictionary *params in retArray) {
            NSNumber *pd_id = [params numberValueForKey:@"id"];
            CDPanDian *panDian = [dataManager findEntity:@"CDPanDian" withValue:pd_id forKey:@"pd_id"];
            if (panDian)
            {
                [oldPanDians removeObject:panDian];
            }
            else
            {
                panDian = [dataManager insertEntity:@"CDPanDian"];
                panDian.pd_id = pd_id;
            }
        
            panDian.name = [params stringValueForKey:@"name"];
            panDian.date = [params stringValueForKey:@"date"];
            panDian.state = [params stringValueForKey:@"state"];
            panDian.filter = [params stringValueForKey:@"filter"];
            panDian.total_count = [params numberValueForKey:@"total_qty"];
//            panDian.package_id = [params numberValueForKey:@"package_id"];
//            panDian.partner_id = [params numberValueForKey:@"partner_id"];
//            panDian.period_id = [params numberValueForKey:@"period_id"];
            
            NSArray *location = [params arrayValueForKey:@"location_id"];
            if (location.count > 0) {
                NSNumber *location_id = location[0];
                panDian.location_id = location_id;
                panDian.location_name = location[1];
                CDStorage *storage = [[BSCoreDataManager currentManager] findEntity:@"CDStorage" withValue:location_id forKey:@"storage_id"];
                if (!storage) {
                    storage = [[BSCoreDataManager currentManager] insertEntity:@"CDStorage"];
                    storage.storage_id = location_id;
                }
                storage.displayName = location[1];
                
                panDian.storage = storage;
            }
            
            NSArray *line_ids = [params arrayValueForKey:@"line_ids"];
            if (line_ids.count > 0) {
                panDian.line_ids = [line_ids componentsJoinedByString:@","];
            }
            
//            BSFetchPanDianItemRequest *request = [[BSFetchPanDianItemRequest alloc] initWithItemIds:line_ids];
//            [request execute];
            
            NSArray *move_ids = [params arrayValueForKey:@"move_ids"];
            if (move_ids.count > 0) {
                panDian.move_ids = [move_ids componentsJoinedByString:@","];
            }
        }
        
        [dataManager deleteObjects:oldPanDians];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPanDianResponse object:nil userInfo:dict];
}

@end
