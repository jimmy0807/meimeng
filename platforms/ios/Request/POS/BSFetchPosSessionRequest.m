//
//  BSFetchPosSessionRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-2.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchPosSessionRequest.h"
#import "BSFetchPayStatementRequest.h"
#import "BSPosSessionOperateRequest.h"

@interface BSFetchPosSessionRequest ()

@end

@implementation BSFetchPosSessionRequest

- (BOOL)willStart
{
    self.tableName = @"pos.session";
    
    PersonalProfile *profile = [PersonalProfile currentProfile];
    if (profile.posID.integerValue == 0 || profile.userID.integerValue == 0)
    {
        return NO;
    }
    
    self.filter = @[@[@"config_id", @"=", profile.posID], @[@"user_id", @"=", profile.userID], @[@"state", @"=", @"opened"]];
    self.field = @[@"id", @"statement_ids", @"write_date"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return YES;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if ([resultList isKindOfClass:[NSArray class]])
    {
        if (resultList.count > 0)
        {
            NSDictionary *dict = [resultList objectAtIndex:0];
            NSString *writestr = [dict objectForKey:@"write_date"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
            NSString *start = [NSString stringWithFormat:@"%@ 0:0:0", datestr];
            NSString *end = [NSString stringWithFormat:@"%@ 23:59:59", datestr];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *writedate = [dateFormatter dateFromString:writestr];
            NSTimeInterval writeInterval = [writedate timeIntervalSince1970];
            NSDate *startdate = [dateFormatter dateFromString:start];
            NSTimeInterval startInterval = [startdate timeIntervalSince1970];
            NSDate *enddate = [dateFormatter dateFromString:end];
            NSTimeInterval endInterval = [enddate timeIntervalSince1970];
            
            PersonalProfile *profile = [PersonalProfile currentProfile];
            profile.sessionID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            profile.openDate = [dateFormatter dateFromString:[dict stringValueForKey:@"write_date"]];
            [profile save];
            
            //if (writeInterval > startInterval && writeInterval < endInterval)
            {
                NSArray *statementIds = [dict arrayValueForKey:@"statement_ids"];
                if (statementIds.count > 0)
                {
                    BSFetchPayStatementRequest *request = [[BSFetchPayStatementRequest alloc] initWithStatementIds:statementIds];
                    [request execute];
                }
            }
        }
        else
        {
            //BSPosSessionOperateRequest *request = [[BSPosSessionOperateRequest alloc] initWithType:kBSPosSessionOpen];
            //[request execute];
        }
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPosSessionResponse object:self userInfo:params];
}

@end
