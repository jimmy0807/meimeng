//
//  BSFetchCardConsumeRequest.m
//  Boss
//  消费明细
//  Created by lining on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchCardConsumeRequest.h"

@interface BSFetchCardConsumeRequest ()
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) CDMember *member;
@end

@implementation BSFetchCardConsumeRequest

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
    self.tableName = @"born.consume.line";
    if (self.memberCard) {
        self.filter = @[@[@"card_id",@"=",self.memberCard.cardID]];
    }
    else
    {
        self.filter = @[@[@"member_id",@"=",self.member.memberID]];
    }
//    self.filter = @[@[@"card_id",@"=",self.memberCard.cardID]];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldConsumes;
        if (self.memberCard) {
            oldConsumes = [NSMutableArray arrayWithArray:[dataManager fetchCardConsumesWithCardID:self.memberCard.cardID]];
        }
        else
        {
            oldConsumes = [NSMutableArray arrayWithArray:[dataManager fetchCardConsumesWithMemberID:self.member.memberID]];
        }
        for (NSDictionary *params in retArray) {
            NSNumber *consume_id = [params numberValueForKey:@"id"];
            CDMemberCardConsume *consume = [dataManager findEntity:@"CDMemberCardConsume" withValue:consume_id forKey:@"consume_id"];
            if (consume == nil) {
                consume = [dataManager insertEntity:@"CDMemberCardConsume"];
                consume.consume_id = consume_id;
            }
            else
            {
                [oldConsumes removeObject:consume];
            }
            
            consume.operate_id = [params arrayIDValueForKey:@"operate_id"];
            consume.opreate_name = [params arrayNameValueForKey:@"operate_id"];
            
            consume.product_id = [params arrayIDValueForKey:@"product_id"];
            consume.product_name = [params arrayNameValueForKey:@"product_id"];
            
            consume.member_id = [params arrayIDValueForKey:@"member_id"];
            consume.member_name = [params arrayNameValueForKey:@"member_id"];
            
            consume.consume_qty = [params numberValueForKey:@"consume_qty"];
            
            consume.pack_product_line_id = [params arrayIDValueForKey:@"pack_product_line_id"];
            consume.pack_product_line_name = [params arrayNameValueForKey:@"pack_product_line_id"];
            
            consume.qty = [params numberValueForKey:@"qty"];
            consume.pack_price = [params numberValueForKey:@"pack_price"];
            
            consume.price_unit = [params numberValueForKey:@"price_unit"];
            consume.price = [params numberValueForKey:@"price"];
            
            consume.create_date = [params stringValueForKey:@"create_date"];
            
            consume.card_id = [params arrayIDValueForKey:@"member_id"];
            consume.card_name = [params arrayNameValueForKey:@"member_id"];
            
            NSNumber *card_id = [params arrayIDValueForKey:@"card_id"];
            CDMemberCard *card = [dataManager uniqueEntityForName:@"CDMemberCard" withValue:card_id forKey:@"cardID"];
            card.cardName = [params arrayNameValueForKey:@"cardID"];
            consume.card = card;
            
            NSNumber *member_id = [params arrayIDValueForKey:@"member_id"];
            CDMember *member = [dataManager uniqueEntityForName:@"CDMember" withValue:member_id forKey:@"memberID"];
            self.member.memberName = [params arrayNameValueForKey:@"member_id"];
            consume.member = member;
        }
    
        [dataManager deleteObjects:oldConsumes];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberCardConsumeResponse object:nil userInfo:dict];
}

@end
