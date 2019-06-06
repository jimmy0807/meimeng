//
//  FetchHomeAccountUsersRequest.m
//  Boss
//
//  Created by jimmy on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchHomeAccountUsersRequest.h"
#import "FetchHomeMyTodayAppointment.h"
#import "FetchHomePeriodIDRequest.h"

@implementation FetchHomeAccountUsersRequest

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"hr.employee";
    
    self.filter = @[@[@"user_id",@"=",[PersonalProfile currentProfile].userID]];
    self.field = @[@"id"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        NSMutableArray* requestArray = [NSMutableArray array];
        for (NSDictionary* params in retArray )
        {
            [requestArray addObject:[params objectForKey:@"id"]];
        }
        
        FetchHomePeriodIDRequest* periodRequest = [[FetchHomePeriodIDRequest alloc] init];
        periodRequest.userIDs = requestArray;
        
        [periodRequest execute];
        
        FetchHomeMyTodayAppointment* appointmentRequset = [[FetchHomeMyTodayAppointment alloc] init];
        appointmentRequset.userIDs = requestArray;
        [appointmentRequset execute];
    }
}

@end
