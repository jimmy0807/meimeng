//
//  BSCreateRestaurantOperateRequest.m
//  Boss
//
//  Created by jimmy on 16/6/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSCreateRestaurantOperateRequest.h"
#import "BSFetchRestaurantTableRequest.h"

@interface BSCreateRestaurantOperateRequest ()
@property(nonatomic, weak) CDRestaurantTable* table;
@property(nonatomic)BOOL isBooked;
@end

@implementation BSCreateRestaurantOperateRequest
- (id)initWithTable:(CDRestaurantTable*)table personCount:(NSInteger)personCount isBooked:(BOOL)isBooked
{
    self = [super init];
    if(self)
    {
        self.table = table;
        self.personCount = personCount;
        self.isBooked = isBooked;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"restaurant.table.line";
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString* now = [dateFormat stringFromDate:[NSDate date]];
    
    NSDictionary* params = @{@"table_id":self.table.tableID,@"people_num":@(self.personCount),@"is_reservation":[NSNumber numberWithBool:self.isBooked],@"start_time":now};
    
    [self sendShopAssistantXmlCreateCommand:@[params]];
    
    return YES;
}

-(void)didFinishOnMainThread
{
    NSNumber *retArray = (NSNumber *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict;
    
    if ( [retArray isKindOfClass:[NSNumber class]] )
    {
        self.occupyID = retArray;
        BSFetchRestaurantTableRequest* request = [[BSFetchRestaurantTableRequest alloc] initWithLastUpdate];
        [request execute];
    }
    else
    {
        dict = [self generateResponse:@"开桌失败"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCreateRestaurantOperateResponse object:self userInfo:dict];
}

@end
