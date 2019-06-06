//
//  BSFetchRestaurantTableIDRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-2-23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchRestaurantTableIDRequest.h"

@implementation BSFetchRestaurantTableIDRequest

- (BOOL)willStart
{
    self.tableName = @"restaurant.table";
    self.filter = @[@[@"shop_id", @"=", [PersonalProfile currentProfile].bshopId]];
    self.field = @[@"id"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return YES;
}

-(void)didFinishOnMainThread
{
    NSArray *resultArray = (NSArray *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
        NSArray *tables = [coreDataManager fetchAllRestaurantTable];
        NSMutableArray *oldTables = [NSMutableArray arrayWithArray:tables];
        for (NSDictionary *params in resultArray)
        {
            NSNumber *tableID = [params numberValueForKey:@"id"];
            CDRestaurantTable *table = [coreDataManager findEntity:@"CDRestaurantTable" withValue:tableID forKey:@"tableID"];
            if (table)
            {
                [oldTables removeObject:table];
            }
        }
        [coreDataManager deleteObjects:oldTables];
        [coreDataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求桌子发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchRestaurantTableIDResponse object:nil userInfo:dict];
}

@end
