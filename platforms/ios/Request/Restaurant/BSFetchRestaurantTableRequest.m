//
//  BSFetchRestaurantTableRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-2-23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchRestaurantTableRequest.h"
#import "BSFetchRestaurantTableIDRequest.h"

@interface BSFetchRestaurantTableRequest ()

@property (nonatomic, strong) NSString *lastUpdate;

@end

@implementation BSFetchRestaurantTableRequest

- (id)initWithLastUpdate
{
    self = [super init];
    if (self)
    {
        self.lastUpdate = [[BSCoreDataManager currentManager] fetchLastUpdateTimeWithEntityName:@"CDRestaurantTable"];
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"restaurant.table";
    if (self.lastUpdate.length != 0)
    {
        self.filter = @[@[@"write_date", @">", self.lastUpdate],@[@"shop_id", @"=", [PersonalProfile currentProfile].bshopId]];
    }
    self.field = @[@"name",@"write_date",@"sequence",@"active",@"seats",@"shape",@"color",@"position_v",@"position_h",@"width",@"height",@"state",@"qty",@"floor_id"];
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
            items = [coreDataManager fetchAllRestaurantTable];
        }
        NSMutableArray *oldItems = [NSMutableArray arrayWithArray:items];
        for (NSDictionary *dict in resultArray)
        {
            NSNumber *tableID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDRestaurantTable *item = [coreDataManager findEntity:@"CDRestaurantTable" withValue:tableID forKey:@"tableID"];
            if (item)
            {
                [oldItems removeObject:item];
            }
            else
            {
                item = [coreDataManager insertEntity:@"CDRestaurantTable"];
                item.tableID = tableID;
            }
            
            item.tableName = [dict stringValueForKey:@"name"];
            item.lastUpdate = [dict stringValueForKey:@"write_date"];
            item.tableSequence = [NSNumber numberWithInteger:[[dict objectForKey:@"sequence"] integerValue]];
            item.isActive = [NSNumber numberWithBool:[[dict objectForKey:@"active"] boolValue]];
            item.tableSeats = [NSNumber numberWithInteger:[[dict objectForKey:@"seats"] integerValue]];
            item.tableShape = [dict stringValueForKey:@"shape"];
            item.tableColor = [dict stringValueForKey:@"color"];
            item.tableVertical = [NSNumber numberWithInteger:[[dict objectForKey:@"position_v"] integerValue]];
            item.tableHorizontal = [NSNumber numberWithInteger:[[dict objectForKey:@"position_h"] integerValue]];
            item.tableWidth = [NSNumber numberWithInteger:[[dict objectForKey:@"width"] integerValue]];
            item.tableHeight = [NSNumber numberWithInteger:[[dict objectForKey:@"height"] integerValue]];
            
            NSString *state = [dict stringValueForKey:@"state"];
            if ([state isEqualToString:@"idle"])
            {
                item.tableState = [NSNumber numberWithInteger:kPadRestaurantTableStateIdle];
            }
            else if ([state isEqualToString:@"using"])
            {
                item.tableState = [NSNumber numberWithInteger:kPadRestaurantTableStateUsing];
            }
            else if ([state isEqualToString:@"book"])
            {
                item.tableState = [NSNumber numberWithInteger:kPadRestaurantTableStateBook];;
            }
            else if ([state isEqualToString:@"disable"])
            {
                item.tableState = [NSNumber numberWithInteger:kPadRestaurantTableStateDisable];;
            }
            item.usingQty = [NSNumber numberWithInteger:[[dict objectForKey:@"qty"] integerValue]];
            
            NSNumber* floorID = [dict arrayIDValueForKey:@"floor_id"];
            CDRestaurantFloor *floor = [coreDataManager uniqueEntityForName:@"CDRestaurantFloor" withValue:floorID forKey:@"floorID"];
            item.floor = floor;
        }
        
        [coreDataManager deleteObjects:oldItems];
        [coreDataManager save:nil];
        
        BSFetchRestaurantTableIDRequest *request = [[BSFetchRestaurantTableIDRequest alloc] init];
        [request execute];
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchRestaurantTableResponse object:nil userInfo:dict];
}

@end
