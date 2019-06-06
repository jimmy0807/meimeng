//
//  BSHandleRestaurantTableRequest.m
//  Boss
//
//  Created by lining on 16/6/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSHandleRestaurantTableRequest.h"
@interface BSHandleRestaurantTableRequest ()
@property (nonatomic, strong) CDRestaurantTable *table;
@end

@implementation BSHandleRestaurantTableRequest
- (instancetype)initWithTable:(CDRestaurantTable *)table
{
    self = [super init];
    if (self) {
        self.table = table;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    
    self.tableName = @"restaurant.table";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.type == HandleTableType_create)
    {
        if ( self.table.tableName.length == 0 )
            return FALSE;
        
        self.table.isActive = @(TRUE);
        params[@"name"] = self.table.tableName;
        params[@"sequence"] = self.table.tableSequence;
        params[@"seats"] = self.table.tableSeats;
        params[@"floor_id"] = self.table.floor.floorID;
        [self sendShopAssistantXmlCreateCommand:@[params]];
    }
    else if (self.type == HandleTableType_write)
    {
        if ( self.table.tableName.length > 0  )
        {
            params[@"name"] = self.table.tableName;
        }
        params[@"sequence"] = self.table.tableSequence;
        params[@"seats"] = self.table.tableSeats;
        [self sendShopAssistantXmlWriteCommand:@[@[self.table.tableID],params]];
        
    }
    else if (self.type == HandleTableType_delete)
    {
        params[@"active"] = [NSNumber numberWithBool:FALSE];
        [self sendShopAssistantXmlWriteCommand:@[@[self.table.tableID],params]];
    }
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    id retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    if (self.type == HandleTableType_create) {
        if ( [retArray isKindOfClass:[NSNumber class]])
        {
            [dict setValue:@0 forKey:@"rc"];
            [dict setValue:@"创建成功" forKey:@"rm"];
            self.table.tableID = retArray;
            //[[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            [[BSCoreDataManager currentManager] deleteObject:self.table];
            dict = [self generateResponse:@"创建失败，请稍后重试"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCreateRestaurantTableResponse object:self userInfo:dict];
    }
    
    else if (self.type == HandleTableType_write)
    {
        if ( [retArray isKindOfClass:[NSNumber class]])
        {
            //[[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            [[BSCoreDataManager currentManager] rollback];
            dict = [self generateResponse:@"编辑失败，请稍后重试"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kWriteRestaurantTableResponse object:self userInfo:dict];
    }
    else if (self.type == HandleTableType_delete)
    {
        if ( [retArray isKindOfClass:[NSNumber class]])
        {
            //            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            dict = [self generateResponse:@"删除失败，请稍后重试"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteRestaurantTableResponse object:self userInfo:dict];
    }
}


@end
