//
//  FetchHomePassengerFlowRequest.m
//  Boss
//
//  Created by jimmy on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchHomePassengerFlowRequest.h"
#import "HomeCountData.h"

@implementation FetchHomePassengerFlowRequest

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.card.operate";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    NSString* today = [dateFormat stringFromDate:[NSDate date]];
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    NSNumber* storeID = [profile.homeSelectedShopID integerValue] > 0 ? profile.homeSelectedShopID : profile.bshopId;
    self.filter = @[@[@"shop_id",@"=",storeID],@[@"create_date",@">=",[NSString stringWithFormat:@"%@ %@",today,@"00:00:00"]],@[@"create_date",@"<=",[NSString stringWithFormat:@"%@ %@",today,@"23:59:59"]],@[@"id",@">",@(1)]];
    [self sendShopAssistantXmlSearchCountCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    if ([retArray isKindOfClass:[NSNumber class]])
    {
        HomeCountData* homeData = [HomeCountData currentData];
        homeData.passengerFlowDate = [homeData getToday];
        homeData.totalpassengerFlow = [NSString stringWithFormat:@"%@",retArray];
        [homeData save];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHomeCountDataResponse object:nil userInfo:nil];
    }
}

@end
