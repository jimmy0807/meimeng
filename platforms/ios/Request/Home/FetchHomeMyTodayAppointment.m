//
//  FetchHomeMyTodayAppointment.m
//  Boss
//
//  Created by jimmy on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchHomeMyTodayAppointment.h"
#import "HomeCountData.h"

@implementation FetchHomeMyTodayAppointment

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.reservation";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    NSString* today = [dateFormat stringFromDate:[NSDate date]];
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    NSNumber* storeID = [profile.homeSelectedShopID integerValue] > 0 ? profile.homeSelectedShopID : profile.bshopId;
    self.filter = @[@[@"shop_id",@"=",storeID],@[@"start_date",@">",[NSString stringWithFormat:@"%@ %@",today,@"00:00:00"]],@[@"start_date",@"<",[NSString stringWithFormat:@"%@ %@",today,@"23:59:59"]],@[@"technician_id",@"in",self.userIDs]];
    [self sendShopAssistantXmlSearchCountCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    if ([retArray isKindOfClass:[NSNumber class]])
    {
        HomeCountData* homeData = [HomeCountData currentData];
        homeData.myAppointmentDate = [homeData getToday];
        homeData.totalMyAppointment = [NSString stringWithFormat:@"%@",retArray];
        [homeData save];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHomeCountDataResponse object:nil userInfo:nil];
    }
}

@end
