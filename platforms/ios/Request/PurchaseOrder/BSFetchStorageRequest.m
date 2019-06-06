//
//  FetchStorageRequest.m
//  Boss
//
//  Created by lining on 15/5/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchStorageRequest.h"
#import "BSCoreDataManager+Customized.h"

@implementation BSFetchStorageRequest

-(BOOL)willStart
{
    [super willStart];
    self.needCompany = true;
    
    self.tableName = @"stock.location";
    self.filter = @[@[@"active",@"=",@1],@[@"usage",@"=",@"internal"]];
    if (self.storeId) {
        self.needCompany = false;
        self.filter = @[@[@"active",@"=",@1],@[@"usage",@"=",@"internal"],@[@"shop_id",@"=",self.storeId]];
    }
    self.field = @[];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray *storages = [dataManager fetchAllStoreages];
        NSMutableArray *oldStorages = [NSMutableArray arrayWithArray:storages];
        for (NSDictionary *params in retArray) {
            NSNumber *storage_id = [params numberValueForKey:@"id"];
            CDStorage *storage = [dataManager findEntity:@"CDStorage" withValue:storage_id forKey:@"storage_id"];
            if (storage) {
                [oldStorages removeObject:storage];
            }
            else
            {
                storage = [dataManager insertEntity:@"CDStorage"];
                storage.storage_id = storage_id;
            }
            
            storage.name = [params stringValueForKey:@"name"];
            storage.displayName = [params stringValueForKey:@"display_name"];
            storage.shop_id = [[params arrayValueForKey:@"shop_id"] firstObject];
            storage.shop_name = [[params arrayValueForKey:@"shop_id"] lastObject];
            storage.completeName = [params stringValueForKey:@"complete_name"];
            
            NSArray *location_id = [params arrayValueForKey:@"location_id"];
            if (location_id.count > 0) {
                storage.location_id = location_id[0];
            }
            
        }
        [dataManager deleteObjects:oldStorages];
        [dataManager save:nil];
    }
    else
    {
        [dict setObject:@(-1) forKey:@"rc"];
        [dict setObject:@"请求数据失败，请稍后重试" forKey:@"rm"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchStorageRequest object:nil userInfo:dict];
}
@end
