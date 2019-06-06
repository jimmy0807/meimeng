//
//  BSMemberCardRedeemRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-16.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSMemberCardRedeemRequest.h"
#import "BSFetchMemberCardDetailRequest.h"

@interface BSMemberCardRedeemRequest ()

@property (nonatomic, strong) NSDictionary *params;

@end


@implementation BSMemberCardRedeemRequest

- (id)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self != nil)
    {
        self.params = params;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.point.record";
    [self sendShopAssistantXmlCreateCommand:@[self.params]];
    
    return YES;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (resultStr.length != 0 && [resultList isKindOfClass:[NSNumber class]])
    {
        [dict setObject:resultList forKey:@"operate_id"];
        NSNumber *cardID = [self.params numberValueForKey:@"card_id"];
        BSFetchMemberCardDetailRequest *cardRequest = [[BSFetchMemberCardDetailRequest alloc] initWithMemberCardID:cardID];
        [cardRequest execute];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSMemberCardRedeemResponse object:dict userInfo:params];
}


@end
