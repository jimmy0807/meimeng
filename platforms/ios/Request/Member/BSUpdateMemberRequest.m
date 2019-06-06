//
//  BSUpdateMemberRequest.m
//  Boss
//
//  Created by mac on 15/7/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSUpdateMemberRequest.h"

@implementation BSUpdateMemberRequest
-(id)initWithMember:(CDMember *)member params:(NSDictionary *)params
{
    if(self = [super init])
    {
        self.member = member;
        self.params = params;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.member";
    [self sendShopAssistantXmlWriteCommand:@[@[self.member.memberID], self.params]];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if ([resultList isKindOfClass:[NSNumber class]])
    {
        if([(NSNumber *)resultList  isEqual: @1])
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSUpdateMemberResponse object:self userInfo:params];
}

@end
