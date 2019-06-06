//
//  BSMemberFollowCreateRequest.m
//  Boss
//
//  Created by lining on 16/5/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSMemberFollowCreateRequest.h"

@interface BSMemberFollowCreateRequest ()
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation BSMemberFollowCreateRequest

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        self.params = params;
    }
    return self;
}


- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.customer.follow";
    [self sendShopAssistantXmlCreateCommand:@[self.params]];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSNumber class]]) {
        
    }
    else
    {
        dict = [self generateResponse:@"请求失败,请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSCreateMemberFollowResponse object:nil userInfo:dict];
}

@end
