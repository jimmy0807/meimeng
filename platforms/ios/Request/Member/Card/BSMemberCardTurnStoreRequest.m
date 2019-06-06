//
//  BSMemberCardTurnStoreRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-16.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSMemberCardTurnStoreRequest.h"
#import "BSFetchMemberDetailRequest.h"
#import "BSFetchMemberCardDetailRequest.h"

@interface BSMemberCardTurnStoreRequest ()

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation BSMemberCardTurnStoreRequest

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
    self.tableName = @"born.shop.record";
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
        
        NSNumber *memberID = [self.params numberValueForKey:@"member_id"];
        CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:memberID forKey:@"memberID"];
        
        BSFetchMemberDetailRequest *memberRequst = [[BSFetchMemberDetailRequest alloc] initWithMember:member];
        [memberRequst execute];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSMemberCardTurnStoreResponse object:dict userInfo:params];
}

@end
