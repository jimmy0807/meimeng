//
//  BSFetchRestaurantFloorRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-2-22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchRestaurantFloorRequest.h"
#import "BSFetchRestaurantFloorIDRequest.h"

@interface BSFetchRestaurantFloorRequest ()

@property (nonatomic, strong) NSString *lastUpdate;

@end

@implementation BSFetchRestaurantFloorRequest

- (id)initWithLastUpdate
{
    self = [super init];
    if (self)
    {
        self.lastUpdate = [[BSCoreDataManager currentManager] fetchLastUpdateTimeWithEntityName:@"CDRestaurantFloor"];
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"restaurant.floor";
    if (self.lastUpdate.length != 0)
    {
        self.filter = @[@[@"write_date", @">", self.lastUpdate],@[@"shop_id", @"=", [PersonalProfile currentProfile].bshopId]];
    }
    self.field = @[];
    
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
        NSArray *items = [NSArray array];
        if (self.lastUpdate.length == 0)
        {
            items = [coreDataManager fetchAllRestaurantFloor];
        }
        NSMutableArray *oldItems = [NSMutableArray arrayWithArray:items];
        for (NSDictionary *dict in resultArray)
        {
            NSNumber *floorID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDRestaurantFloor *item = [coreDataManager findEntity:@"CDRestaurantFloor" withValue:floorID forKey:@"floorID"];
            if (item)
            {
                [oldItems removeObject:item];
            }
            else
            {
                item = [coreDataManager insertEntity:@"CDRestaurantFloor"];
                item.floorID = floorID;
            }
            
            item.floorName = [dict stringValueForKey:@"name"];
            item.floorSequence = [NSNumber numberWithInteger:[[dict objectForKey:@"sequence"] integerValue]];
            item.lastUpdate = [dict stringValueForKey:@"write_date"];
            item.isActive = [NSNumber numberWithBool:[[dict objectForKey:@"active"] boolValue]];
            
            NSMutableSet *mutableSet = [NSMutableSet set];
            NSArray *tableIds = [dict objectForKey:@"table_ids"];
            if ([tableIds isKindOfClass:[NSArray class]])
            {
                for (int i = 0; i < tableIds.count; i++)
                {
                    NSNumber *tableID = (NSNumber *)[tableIds objectAtIndex:i];
                    CDRestaurantTable *table = [coreDataManager findEntity:@"CDRestaurantTable" withValue:tableID forKey:@"tableID"];
                    if (!table)
                    {
                        table = [coreDataManager insertEntity:@"CDRestaurantTable"];
                        table.tableID = tableID;
                    }
                    
                    [mutableSet addObject:table];
                }
            }
            item.tables = [NSSet setWithSet:mutableSet];
            
            NSArray *posConfigs = [dict objectForKey:@"pos_config_id"];
            if ([posConfigs isKindOfClass:[NSArray class]])
            {
                NSNumber *posConfigId = (NSNumber *)[posConfigs objectAtIndex:0];
                CDPosConfig *posConfig = [coreDataManager findEntity:@"CDPosConfig" withValue:posConfigId forKey:@"posID"];
                if (!posConfig)
                {
                    posConfig = [coreDataManager insertEntity:@"CDPosConfig"];
                    posConfig.posID = posConfigId;
                }
                item.posConfig = posConfig;
            }
        }
        
        [coreDataManager deleteObjects:oldItems];
        [coreDataManager save:nil];
        
        BSFetchRestaurantFloorIDRequest *request = [[BSFetchRestaurantFloorIDRequest alloc] init];
        [request execute];
    }
    else
    {
        dict = [self generateResponse:@"请求支付方式发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchRestaurantFloorResponse object:nil userInfo:dict];
}

@end
