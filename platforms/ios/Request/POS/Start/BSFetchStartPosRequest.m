//
//  BSFetchStartPosRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-17.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchStartPosRequest.h"
#import "BSFetchPosSessionRequest.h"

@implementation BSFetchStartPosRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:profile.userID, @"user_id", nil];
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"start_pos" params:@[params]];
    
    return YES;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if (resultStr.length != 0 && resultList != nil && [resultList isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)resultList;
        NSDictionary *data = [dict objectForKey:@"data"];
        PersonalProfile *profile = [PersonalProfile currentProfile];
        profile.sessionID = [NSNumber numberWithInteger:[[data objectForKey:@"session_id"] integerValue]];
        [profile save];
        
        BSFetchPosSessionRequest *request = [[BSFetchPosSessionRequest alloc] init];
        [request execute];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchStartPosResponse object:self userInfo:params];
}

@end
