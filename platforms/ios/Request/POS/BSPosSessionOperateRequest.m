//
//  BSPosSessionOperateRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSPosSessionOperateRequest.h"
#import "BSFetchPosSessionRequest.h"

@interface BSPosSessionOperateRequest ()

@property (nonatomic, assign) kBSPosSessionOperateType type;

@end

@implementation BSPosSessionOperateRequest

- (id)initWithType:(kBSPosSessionOperateType)type
{
    if (self = [super init])
    {
        self.type = type;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"pos.session";
    PersonalProfile *profile = [PersonalProfile currentProfile];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.type == kBSPosSessionOpen)
    {
        [params setObject:profile.userID forKey:@"user_id"];
        [params setObject:profile.posID forKey:@"config_id"];
        if (profile.shopIds.count > 0) {
            [params setObject:[profile.shopIds objectAtIndex:0] forKey:@"shop_id"];
        }
        [params setObject:profile.businessId forKey:@"company_id"];
        [self sendShopAssistantXmlCreateCommand:@[params]];
    }
    else if (self.type == kBSPosSessionClose || self.type == kBSPosSessionReOpen)
    {
        self.xmlStyle = @"action_pos_session_close";
        [self sendRpcXmlCommand:@"/xmlrpc/2/object" method:@"execute" params:@[profile.sessionID]];
    }
    
    return YES;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if (resultStr.length != 0 && resultList != nil)
    {
        if (self.type == kBSPosSessionOpen)
        {
            if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *sessionId = (NSNumber *)resultList;
                if (sessionId.integerValue != 0)
                {
                    BSFetchPosSessionRequest *request = [[BSFetchPosSessionRequest alloc] init];
                    [request execute];
                }
            }
        }
        else
        {
            if ([resultList isKindOfClass:[NSObject class]])
            {
                PersonalProfile *profile = [PersonalProfile currentProfile];
                profile.sessionID = [NSNumber numberWithInteger:0];
                profile.closeDate = [NSDate date];
                [profile save];
                
                if (self.type == kBSPosSessionReOpen)
                {
                    BSPosSessionOperateRequest *request = [[BSPosSessionOperateRequest alloc] initWithType:kBSPosSessionOpen];
                    [request execute];
                }
            }
            else if ([resultList isKindOfClass:[NSNumber class]])
            {
                NSNumber *isClosed = (NSNumber *)resultList;
                if (!isClosed.boolValue)
                {
                    PersonalProfile *profile = [PersonalProfile currentProfile];
                    profile.sessionID = [NSNumber numberWithInteger:0];
                    profile.closeDate = [NSDate date];
                    [profile save];
                }
            }
        }
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSPosSessionOperateResponse object:self userInfo:params];
}

@end
