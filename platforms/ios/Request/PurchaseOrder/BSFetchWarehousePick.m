//
//  BSFetchRespositoryPick.m
//  Boss
//
//  Created by lining on 15/6/30.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchWarehousePick.h"

@interface BSFetchWarehousePick ()
@property(nonatomic, strong) NSArray *ids;
@end

@implementation BSFetchWarehousePick

- (id)initWithIds:(NSArray *)ids
{
    self = [super init];
    if (self) {
        self.ids = ids;
    }
    return self;
}

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"stock.picking.type";
    self.filter = @[@[@"warehouse_id",@"in",self.ids],@[@"code",@"=",@"incoming"]];
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
        NSArray *warehouses = [dataManager fetchAllWarehouses];
        NSMutableArray *oldWarehouses = [NSMutableArray arrayWithArray:warehouses];
        for (NSDictionary *params in retArray) {
            NSNumber *pice_id = [params numberValueForKey:@"id"];
            CDWarehouse *warehouse = [dataManager findEntity:@"CDWarehouse" withValue:pice_id forKey:@"pick_id"];
            
            if (warehouse) {
                [oldWarehouses removeObject:warehouse];
            }
            else
            {
                warehouse = [dataManager insertEntity:@"CDWarehouse"];
                warehouse.pick_id = pice_id;
            }
            warehouse.pick_name = [params stringValueForKey:@"display_name"];
            
            NSArray *ware = [params arrayValueForKey:@"warehouse_id"]; //仓库
            if (ware.count > 0) {
                warehouse.warehouse_id = ware[0];
                warehouse.warehouse_name = ware[1];
            }
            
            NSArray *src_location = [params arrayValueForKey:@"default_location_src_id"];  //默认源库位
            if (src_location.count > 0) {
                warehouse.src_location_id = src_location[0];
                warehouse.src_location_name = src_location[1];
            }
            
            NSArray *dest_location = [params arrayValueForKey:@"default_location_dest_id"];
            if (dest_location.count > 0) {
                warehouse.dest_location_id = dest_location[0];
                warehouse.dest_location_name = dest_location[1];
            }
            
            [[BSCoreDataManager currentManager] save:nil];
        }
        [dict setObject:@0 forKey:@"rc"];
    }
    else
    {
        [dict setObject:@-1 forKey:@"rc"];
        [dict setObject:@"请求失败,请稍后重试" forKey:@"rm"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchRespositoryRequest object:nil userInfo:dict];
}
@end
