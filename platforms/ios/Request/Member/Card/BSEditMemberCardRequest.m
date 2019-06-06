//
//  BSEditMemberCardRequest.m
//  Boss
//
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSEditMemberCardRequest.h"
#import "BSFetchMemberDetailReqeustN.h"

@interface BSEditMemberCardRequest ()
@property (nonatomic, strong) CDMemberCard *card;
@end

@implementation BSEditMemberCardRequest

- (instancetype)initWithCard:(CDMemberCard *)card
{
    self = [super init];
    if (self) {
        self.card = card;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.card";
    
    [self sendShopAssistantXmlWriteCommand:@[@[self.card.cardID],self.params]];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict;
    if ([retArray isKindOfClass:[NSNumber class]]) {
        [[BSCoreDataManager currentManager] save:nil];
        NSNumber *memberID = self.card.member.memberID;
        BSFetchMemberDetailRequestN *memberRequest = [[BSFetchMemberDetailRequestN alloc] initWithMemberID:memberID];
        [memberRequest execute];
    }
    else
    {
//        [[BSCoreDataManager currentManager] rollback];
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSEditMemberCardResponse object:nil userInfo:dict];
}

@end
