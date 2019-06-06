//
//  BSFetchPosPayInfoRequest.m
//  Boss
//
//  Created by lining on 15/10/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchPosPayInfoRequest.h"

@interface BSFetchPosPayInfoRequest ()
@property(nonatomic, strong) CDPosOperate *operate;
@property(nonatomic, strong) NSArray *statement_ids;
@end

@implementation BSFetchPosPayInfoRequest

- (instancetype)initWithPosOperate:(CDPosOperate *)operate
{
    self = [super init];
    if (self) {
        self.operate = operate;
        self.statement_ids = [self.operate.statement_ids componentsSeparatedByString:@","];
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"account.bank.statement.line";
    
//    self.filter = @[@[@"id",@"in",self.statement_ids]];
    self.filter = @[@[@"operate_id",@"=",self.operate.operate_id]];
    
    self.field = @[];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        if (self.operate.payInfos.count > 0) {
            [dataManager deleteObjects:self.operate.payInfos.array];
            self.operate.payInfos = nil;
        }
        for (NSDictionary *params in retArray) {
            CDPosOperatePayInfo *payInfo = [dataManager insertEntity:@"CDPosOperatePayInfo"];
            payInfo.pay_id = [params objectForKey:@"id"];
            payInfo.statement_id = [params arrayIDValueForKey:@"statement_id"];
            payInfo.statement_name = [params arrayNameValueForKey:@"statement_id"];
            
            payInfo.type = [params stringValueForKey:@"type"];
            payInfo.state = [params stringValueForKey:@"state"];
            payInfo.create_date = [params stringValueForKey:@"create_date"];
            payInfo.pay_note = [params stringValueForKey:@"note"];
            
            payInfo.pay_amount = [params numberValueForKey:@"amount"];
            payInfo.card_amount = [params numberValueForKey:@"card_amount"];
            payInfo.cource_amount = [params numberValueForKey:@"course_amount"];
            payInfo.gift_amount = [params numberValueForKey:@"gift_amount"];
            payInfo.remain_amount = [params numberValueForKey:@"remain_amount"];
            
            payInfo.is_card = [params numberValueForKey:@"is_card"];
            
            payInfo.card_id = [params arrayIDValueForKey:@"card_id"];
            payInfo.card_name = [params arrayNameValueForKey:@"card_id"];
            
            payInfo.shop_id = [params arrayIDValueForKey:@"shop_id"];
            payInfo.shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            payInfo.operate_id = [params arrayIDValueForKey:@"operate_id"];
            payInfo.operate_name = [params arrayNameValueForKey:@"operate_id"];
            
            payInfo.journal_id = [params arrayIDValueForKey:@"journal_id"];
            payInfo.journal_name = [params arrayNameValueForKey:@"journal_id"];
            
            payInfo.payMode = [dataManager findEntity:@"CDPOSPayMode" withValue:payInfo.journal_id forKey:@"payID"];
            
            payInfo.bank_serial_number = [params arrayNameValueForKey:@"bank_serial_number"];
            payInfo.pos_type = [params arrayNameValueForKey:@"pos_type"];
            
            [orderedSet addObject:payInfo];
        }
        self.operate.payInfos = orderedSet;
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchPosPayInfoResponse object:nil userInfo:dict];
}

@end
