//
//  BSDeleteRestaurantOperateRequest.m
//  Boss
//
//  Created by jimmy on 16/6/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSDeleteRestaurantOperateRequest.h"
#import "BSFetchRestaurantTableRequest.h"

@interface BSDeleteRestaurantOperateRequest ()
@property(nonatomic, strong)NSNumber* occupyID;
@end

@implementation BSDeleteRestaurantOperateRequest

- (id)initWithOccupyID:(NSNumber*)occupyID
{
    self = [super init];
    if(self)
    {
        self.occupyID = occupyID;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"restaurant.table.line";
    
    NSDictionary* params = @{@"state":@"cancel"};
    
    [self sendShopAssistantXmlWriteCommand:@[@[self.occupyID], params]];
    
    return YES;
}

-(void)didFinishOnMainThread
{
    NSNumber *retArray = (NSNumber *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    
    if ( [retArray isKindOfClass:[NSNumber class]] )
    {
        BSFetchRestaurantTableRequest* request = [[BSFetchRestaurantTableRequest alloc] initWithLastUpdate];
        [request execute];
    }
}

@end
