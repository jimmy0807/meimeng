//
//  FetchRepository.m
//  Boss
//
//  Created by lining on 15/5/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchWarehouse.h"
#import "BSCoreDataManager+Customized.h"
#import "BSFetchWarehousePick.h"

@implementation BSFetchWarehouse
-(BOOL)willStart
{
    [super willStart];
    self.needCompany = true;
    self.tableName = @"stock.warehouse";
    self.filter = @[];
    self.field = @[@"name"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *ids = [NSMutableArray array];
    if ([retArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *params in retArray) {
            NSNumber *repository_id = [params numberValueForKey:@"id"];
            [ids addObject:repository_id];
        }
        BSFetchWarehousePick *req = [[BSFetchWarehousePick alloc] initWithIds:ids];
        [req execute];
    
    }
    else
    {
        [dict setObject:@(-1) forKey:@"rc"];
        [dict setObject:@"请求数据失败，请稍后重试" forKey:@"rm"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchRespositoryRequest object:nil userInfo:dict];
    }
    
}
@end
