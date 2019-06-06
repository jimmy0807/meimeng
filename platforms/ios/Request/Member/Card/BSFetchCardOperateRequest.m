//
//  BSFetchCardOperateRequest.m
//  Boss
//  操作明细
//  Created by lining on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchCardOperateRequest.h"

@interface BSFetchCardOperateRequest ()
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) NSNumber *operateID;
@end

@implementation BSFetchCardOperateRequest

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
    self = [super init];
    if (self) {
        self.member = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMember" withValue:memberID forKey:@"memberID"];
    }
    return self;
}

- (instancetype)initWithOperateID:(NSNumber *)operateID
{
    self = [super init];
    if (self) {
        self.operateID = operateID;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.card.operate";
    if (self.memberCard) {
        self.filter = @[@[@"card_id",@"=",self.memberCard.cardID]];
    }
    else if (self.member)
    {
        self.filter = @[@[@"member_id",@"=",self.member.memberID]];
    }
    else
    {
        self.filter = @[@[@"id",@"=",self.operateID]];
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
        NSMutableArray *oldOperates;
        if (self.memberCard) {
            oldOperates = [NSMutableArray arrayWithArray:[dataManager fetchCardOperatesWithCardID:self.memberCard.cardID]];
        }
        else if(self.member)
        {
            oldOperates = [NSMutableArray arrayWithArray:[dataManager fetchCardOperatesWithMemberID:self.member.memberID]];
        }
        
        for (NSDictionary *params in retArray) {
            NSNumber *operate_id = [params numberValueForKey:@"id"];
            CDPosOperate *operate = [dataManager findEntity:@"CDPosOperate" withValue:operate_id forKey:@"operate_id"];
            if (operate == nil) {
                operate = [dataManager insertEntity:@"CDPosOperate"];
                operate.operate_id = operate_id;
            }
            else
            {
                [oldOperates removeObject:operate];
            }
            
            operate.name = [params stringValueForKey:@"name"];
            operate.type = [params stringValueForKey:@"type"];
            operate.amount = [params numberValueForKey:@"amount"];
            operate.nowAmount = [params numberValueForKey:@"now_amount"];
            
            operate.operate_date = [params stringValueForKey:@"create_date"];
            operate.member_id = [params arrayIDValueForKey:@"member_id"];
            operate.member_name = [params arrayNameValueForKey:@"member_id"];
            
            operate.card_id = [params arrayIDValueForKey:@"card_id"];
            operate.card_name = [params arrayNameValueForKey:@"card_id"];
            
            operate.member_mobile = [params stringValueForKey:@"member_mobile"];
            
            operate.pricelist_id = [params arrayIDValueForKey:@"pricelist_id"];
            operate.pricelist_name = [params arrayNameValueForKey:@"pricelist_id"];
            
            operate.operate_shop_id = [params arrayIDValueForKey:@"shop_id"];
            operate.operate_shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            operate.operate_user_id = [params arrayIDValueForKey:@"create_uid"];
            operate.operate_user_name = [params arrayNameValueForKey:@"create_uid"];
            
            operate.card_shop_id = [params arrayIDValueForKey:@"card_shop_id"];
            operate.card_shop_name = [params arrayNameValueForKey:@"card_shop_id"];
            operate.product_line_ids = [[params arrayValueForKey:@"product_line_ids"] componentsJoinedByString:@","];
            
            CDStore *store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:[params arrayIDValueForKey:@"card_shop_id"] forKey:@"storeID"];
            if (store == nil) {
                NSLog(@"NO SHOP_ID: %@",[params arrayIDValueForKey:@"card_id"]);
                store = [[BSCoreDataManager currentManager] insertEntity:@"CDStore"];
                store.storeID = [params arrayIDValueForKey:@"card_shop_id"];
                store.storeName = [params arrayNameValueForKey:@"card_shop_id"];
            }
            operate.shop = store;
            
            operate.session_id = [params arrayIDValueForKey:@"session_id"];
            operate.session_name = [params arrayNameValueForKey:@"session_id"];
            
            operate.now_card_amount = [params numberValueForKey:@"now_card_amount"];
            operate.now_arrears_amount = [params stringValueForKey:@"now_arrears_amount"];
            
            NSNumber *card_id = [params arrayIDValueForKey:@"card_id"];
            CDMemberCard *card = [dataManager uniqueEntityForName:@"CDMemberCard" withValue:card_id forKey:@"cardID"];
            card.cardName = [params arrayNameValueForKey:@"cardID"];
            operate.cardForOperateList = card;
            
            NSNumber *member_id = [params arrayIDValueForKey:@"member_id"];
            CDMember *member = [dataManager uniqueEntityForName:@"CDMember" withValue:member_id forKey:@"memberID"];
            self.member.memberName = [params arrayNameValueForKey:@"member_id"];
            operate.member = member;
            
        }
        
        [dataManager deleteObjects:oldOperates];
        [dataManager save:nil];
    }
    else
    {
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberCardOperateResponse object:nil userInfo:dict];
}


@end
