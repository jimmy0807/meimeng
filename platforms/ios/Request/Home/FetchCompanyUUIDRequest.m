//
//  FetchCompanyUUIDRequest.m
//  Boss
//
//  Created by lining on 15/8/13.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "FetchCompanyUUIDRequest.h"


@implementation FetchCompanyUUIDRequest
- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"res.company";
    self.filter = @[@[@"id",@"=",[PersonalProfile currentProfile].businessId]];
    self.field = @[@"born_uuid", @"is_line_round", @"round_accuracy", @"is_multi_department", @"is_post_checkout"];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ( [retArray isKindOfClass:[NSArray class]] )
    {
        PersonalProfile *profile = [PersonalProfile currentProfile];
        for (NSDictionary *params in retArray)
        {
            NSString *companyUUID = [params stringValueForKey:@"born_uuid"];
            profile.companyUUID = companyUUID;
            profile.isLineRound = [params numberValueForKey:@"is_line_round"];
            profile.roundAccuracy = [params numberValueForKey:@"round_accuracy"];
            
            profile.isBookOperate = [params numberValueForKey:@"is_book_operate"];
            profile.bookOperateTime = [params numberValueForKey:@"book_operate_time"];//分钟
            profile.is_multi_department = [[params numberValueForKey:@"is_multi_department"] boolValue];
            profile.is_post_checkout = [[params numberValueForKey:@"is_post_checkout"] boolValue];
            
            [profile save];
        }
    }
    else
    {
        dict = [self generateResponse];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchCompanyUUIDResponse object:nil userInfo:dict];
}

@end
