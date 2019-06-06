//
//  BSFetchRestaurantFloorIDRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-2-23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchRestaurantFloorIDRequest.h"

@implementation BSFetchRestaurantFloorIDRequest

- (BOOL)willStart
{
    self.tableName = @"restaurant.floor";
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
        NSArray *floors = [coreDataManager fetchAllRestaurantFloor];
        NSMutableArray *oldFloors = [NSMutableArray arrayWithArray:floors];
        
        for (NSDictionary *params in resultArray)
        {
            NSNumber *floorID = [params numberValueForKey:@"id"];
            CDRestaurantFloor *floor = [coreDataManager findEntity:@"CDRestaurantFloor" withValue:floorID forKey:@"floorID"];
            if (floor)
            {
                [oldFloors removeObject:floor];
            }
        }
        [coreDataManager deleteObjects:oldFloors];
        [coreDataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求支付方式发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchRestaurantFloorIDResponse object:nil userInfo:dict];
}

@end
