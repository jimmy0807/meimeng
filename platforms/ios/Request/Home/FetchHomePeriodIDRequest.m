//
//  FetchHomePeriodIDRequest.m
//  Boss
//
//  Created by jimmy on 15/7/17.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchHomePeriodIDRequest.h"
#import "FetchHomeMyTodayInComeRequset.h"

@implementation FetchHomePeriodIDRequest

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.account.period";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"MM/yyyy";
    NSString* today = [dateFormat stringFromDate:[NSDate date]];

    self.filter = @[@[@"name",@"=",today]];
    self.field = @[@"id"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        NSDictionary* params = retArray[0];
        FetchHomeMyTodayInComeRequset* inComeRequset = [[FetchHomeMyTodayInComeRequset alloc] init];
        inComeRequset.period = params[@"id"];
        inComeRequset.userIDs = self.userIDs;
        [inComeRequset execute];
    }
}

@end
