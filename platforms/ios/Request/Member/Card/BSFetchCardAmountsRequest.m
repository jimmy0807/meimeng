//
//  BSFetchCardAmountsRequest.m
//  Boss
//  金额变动明细
//  Created by lining on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchCardAmountsRequest.h"

@interface BSFetchCardAmountsRequest ()
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) CDMember *member;
@end

@implementation BSFetchCardAmountsRequest

- (instancetype)initWithCardID:(NSNumber *)cardID
{
    self = [super init];
    if (self) {
        self.memberCard = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMemberCard" withValue:cardID forKey:@"cardID"];
    }
    return self;
}

- (instancetype)initWithMemberID:(NSNumber *)memberID
{
    if (self) {
        self.member = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMember" withValue:memberID forKey:@"memberID"];
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"account.bank.statement.line";
    if (self.memberCard) {
         self.filter = @[@[@"card_id",@"=",self.memberCard.cardID]];
    }
    else
    {
        self.filter = @[@[@"member_id",@"=",self.member.memberID]];
    }
   
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldAmounts;
        if (self.memberCard) {
            oldAmounts = [NSMutableArray arrayWithArray:[dataManager fetchCardAmountsWithCardID:self.memberCard.cardID]];
        }
        else
        {
            oldAmounts = [NSMutableArray arrayWithArray:[dataManager fetchCardAmountsWithMemberID:self.member.memberID]];
        }
        for (NSDictionary *params in retArray) {
            NSNumber *amount_id = [params numberValueForKey:@"id"];
            CDMemberCardAmount *amount = [dataManager findEntity:@"CDMemberCardAmount" withValue:amount_id forKey:@"amount_id"];
            if (amount == nil) {
                amount = [dataManager insertEntity:@"CDMemberCardAmount"];
                amount.amount_id = amount_id;
            }
            else
            {
                [oldAmounts removeObject:amount];
            }
            
            amount.operate_id = [params arrayIDValueForKey:@"operate_id"];
            amount.operate_name = [params arrayNameValueForKey:@"operate_id"];
            
            amount.type = [params stringValueForKey:@"type"];
            
            amount.journal_id = [params arrayIDValueForKey:@"journal_id"];
            amount.journal_name = [params arrayNameValueForKey:@"journal_id"];
            
            amount.amount = [params numberValueForKey:@"amount"];
            amount.gift_amount = [params numberValueForKey:@"gift_amount_operate"];
            amount.point = [params numberValueForKey:@"point"];
            amount.card_amount = [params numberValueForKey:@"card_amount"];
            
//            //会员卡只显示卡内余额变动不为0的数据
//            if (self.memberCard && fabs([amount.card_amount floatValue])- 0.01 < 0) {
//                [dataManager deleteObject:amount];
//                continue;
//            }
            amount.create_date = [params stringValueForKey:@"create_date"];
            amount.note = [params stringValueForKey:@"note"];
            
            
            NSNumber *card_id = [params arrayIDValueForKey:@"card_id"];
            CDMemberCard *card = [dataManager uniqueEntityForName:@"CDMemberCard" withValue:card_id forKey:@"cardID"];
            card.cardName = [params arrayNameValueForKey:@"cardID"];
            amount.card = card;
            
            NSNumber *member_id = [params arrayIDValueForKey:@"member_id"];
            CDMember *member = [dataManager uniqueEntityForName:@"CDMember" withValue:member_id forKey:@"memberID"];
            self.member.memberName = [params arrayNameValueForKey:@"member_id"];
            amount.member = member;
        }
        [dataManager deleteObjects:oldAmounts];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberCardAmountResponse object:nil userInfo:dict];
}


@end
