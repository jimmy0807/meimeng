//
//  BSCreateMemberRequest.m
//  Boss
//
//  Created by mac on 15/7/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSCreateMemberRequest.h"

@interface BSCreateMemberRequest ()
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) CDMember *member;
@end

@implementation BSCreateMemberRequest
- (id)initWithMember:(CDMember *)member params:(NSDictionary *)params
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
    self.needCompany = YES;
    self.tableName = @"born.member";
    self.additionalParams = @[@{@"tz":@"Asia/Shanghai"}];
    [self sendShopAssistantXmlCreateCommand:@[self.params]];
    return YES;
}

-(void)didFinishOnMainThread
{
    NSNumber *retArray = (NSNumber *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray integerValue]>0)
    {
        [dict setObject:@0 forKey:@"rc"];
        self.member.memberID = retArray;
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
        [[BSCoreDataManager currentManager] rollback];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSCreateMemberResponse object:self.member userInfo:dict];
}

@end
