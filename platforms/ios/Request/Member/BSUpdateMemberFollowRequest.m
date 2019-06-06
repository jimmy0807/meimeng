//
//  BSUpdateMemberFollowRequest.m
//  Boss
//
//  Created by lining on 16/5/17.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSUpdateMemberFollowRequest.h"

@implementation BSUpdateMemberFollowRequest
- (id)initWithFollow:(CDMemberFollow *)follow params:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        self.follow = follow;
        self.params = params;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.customer.follow";
    [self sendShopAssistantXmlWriteCommand:@[@[self.follow.follow_id], self.params]];
    
    return true;
}


- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *params;
    if ([retArray isKindOfClass:[NSNumber class]])
    {
        if([(NSNumber *)retArray  isEqual: @1])
        {
            [params setValue:@0 forKey:@"rc"];
            [params setValue:@0 forKey:@"rm"];
        }
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
        //        [[BSCoreDataManager currentManager] rollback];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSUpdateMemberFollowResponse object:self userInfo:params];
    
}

@end
