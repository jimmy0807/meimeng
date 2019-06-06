//
//  BSHandleRestaurantFloorRequest.m
//  Boss
//
//  Created by lining on 16/6/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSHandleRestaurantFloorRequest.h"
#import "BSHandleRestaurantTableRequest.h"

@interface BSHandleRestaurantFloorRequest ()
@property (nonatomic, strong) CDRestaurantFloor *floor;
@end

@implementation BSHandleRestaurantFloorRequest
- (instancetype)initWithFloor:(CDRestaurantFloor *)floor
{
    self = [super init];
    if (self) {
        self.floor = floor;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"restaurant.floor";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.type == HandleFloorType_create)
    {
        if ( self.floor.floorName.length == 0 )
            return FALSE;
        
        self.floor.isActive = @(TRUE);
        params[@"name"] = self.floor.floorName;
        params[@"sequence"] = self.floor.floorSequence;
        [self sendShopAssistantXmlCreateCommand:@[params]];
    }
    else if (self.type == HandleFloorType_write)
    {
        params[@"name"] = self.floor.floorName;
        params[@"floorSequence"] = self.floor.floorSequence;
        [self sendShopAssistantXmlWriteCommand:@[@[self.floor.floorID],params]];
        
    }
    else if (self.type == HandleFloorType_delete)
    {
        params[@"active"] = [NSNumber numberWithFloat:FALSE];
//        params[@"floorSequence"] = self.floor.floorSequence;
        [self sendShopAssistantXmlWriteCommand:@[@[self.floor.floorID],params]];
    }
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    id retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    if (self.type == HandleFloorType_create)
    {
        if ( [retArray isKindOfClass:[NSNumber class]])
        {
            [dict setValue:@0 forKey:@"rc"];
            [dict setValue:@"创建成功" forKey:@"rm"];
            self.floor.floorID = retArray;
            
            for ( CDRestaurantTable* table in self.createdTableArray )
            {
                BSHandleRestaurantTableRequest* request = [[BSHandleRestaurantTableRequest alloc] initWithTable:table];
                request.type = HandleTableType_create;
                [request execute];
            }
        }
        else
        {
            [[BSCoreDataManager currentManager] deleteObject:self.floor];
            dict = [self generateResponse:@"创建失败，请稍后重试"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCreateRestaurantFloorResponse object:self userInfo:dict];
    }
    
    else if (self.type == HandleFloorType_write)
    {
        if ( [retArray isKindOfClass:[NSNumber class]])
        {
           [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            [[BSCoreDataManager currentManager] rollback];
            dict = [self generateResponse:@"编辑失败，请稍后重试"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kWriteRestaurantFloorResponse object:self userInfo:dict];
    }
    else if (self.type == HandleFloorType_delete)
    {
        if ( [retArray isKindOfClass:[NSNumber class]])
        {
//            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            dict = [self generateResponse:@"删除失败，请稍后重试"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteRestaurantFloorResponse object:self userInfo:dict];
    }
}

@end
