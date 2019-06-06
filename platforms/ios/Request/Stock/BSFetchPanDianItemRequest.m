//
//  BSFetchPanDianItemRequest.m
//  Boss
//
//  Created by lining on 15/7/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchPanDianItemRequest.h"

@interface BSFetchPanDianItemRequest ()
@property(nonatomic, strong) NSArray *itemIds;
@end

@implementation BSFetchPanDianItemRequest
- (id)initWithItemIds:(NSArray *)itemIds
{
    self = [super init];
    if (self) {
        self.itemIds = itemIds;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"stock.inventory.line";
    self.filter = @[@[@"id",@"in",self.itemIds]];
    self.field = @[];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = nil;
    BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
  
    if ([retArray isKindOfClass:[retArray class]]) {
        
        NSArray *items = [dataManager fetchPanDianItemsWithIds:self.itemIds];
        NSMutableArray *oldItems = [NSMutableArray arrayWithArray:items];
        for (NSDictionary *params in retArray) {
            NSNumber *item_id = [params numberValueForKey:@"id"];
            if (item_id.integerValue == 1083) {
                NSLog(@"");
            }
            CDPanDianItem *item = [dataManager findEntity:@"CDPanDianItem" withValue:item_id forKey:@"item_id"];
            if (item) {
                [oldItems removeObject:item];
            }
            else
            {
                item = [dataManager insertEntity:@"CDPanDianItem"];
                item.item_id = item_id;
            }
            item.fact_count = [params numberValueForKey:@"product_qty"];
            item.theory_count = [params numberValueForKey:@"theoretical_qty"];
            item.orgin_count = item.fact_count;
            NSArray *product = [params arrayValueForKey:@"product_id"];
            
            if (product.count > 0) {
                NSNumber *item_id = product[0];
                item.product_id = product[0];
                
                item.product_name = product[1];
                CDProjectItem *projectItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:item_id forKey:@"itemID"];
                NSLog(@"itemName:%@   templeteID: %@",projectItem.templateName,projectItem.templateID);
                projectItem.itemName = product[1];
                item.projectItem = projectItem;
            }
            else
            {
                NSLog(@"没有产品: %@",item_id);
            }
            
            NSArray *location = [params arrayValueForKey:@"location_id"];
            if (location.count > 0) {
                item.location_id = location[0];
                item.location_name = location[1];
            }
        }
        [dataManager deleteObjects:oldItems];
        [dataManager save:nil];
        
       
        
        [dict setObject:@0 forKey:@"rc"];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPanDianItemResponse object:nil userInfo:dict];
    
}

@end
