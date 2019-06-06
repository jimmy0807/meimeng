//
//  BSFetchPayModeRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-2.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchPayModeRequest.h"
#import "BSFetchPosSessionRequest.h"

@interface BSFetchPayModeRequest ()

@property (nonatomic, strong) NSArray *journalIds;

@end

@implementation BSFetchPayModeRequest

- (id)initWithJournalIds:(NSArray *)journalIds
{
    self = [super init];
    if (self)
    {
        self.journalIds = journalIds;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"account.journal";
    self.filter = @[@[@"id", @"in", self.journalIds], @[@"is_import", @"=", @(0)]];
    self.field = @[@"id", @"name", @"type", @"pay_type", @"payment_acquirer_id"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return YES;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if ([resultList isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
        PersonalProfile *profile = [PersonalProfile currentProfile];
        profile.havePos = resultList.count > 0 ? @(YES) : @(NO);
        [profile save];
        
        NSArray *paymodes = [coreDataManager fetchPOSPayMode];
        NSMutableArray *oldPayModes = [NSMutableArray arrayWithArray:paymodes];
        NSMutableArray *paymodeIds = [NSMutableArray array];
        
        for (NSDictionary *dict in resultList)
        {
            NSNumber *paymodeId = [dict numberValueForKey:@"id"];
            CDPOSPayMode *paymode = [coreDataManager findEntity:@"CDPOSPayMode" withValue:paymodeId forKey:@"payID"];
            [paymodeIds addObject:paymodeId];
            if (!paymode)
            {
                paymode = [coreDataManager insertEntity:@"CDPOSPayMode"];
                paymode.payID = paymodeId;
            }
            else
            {
                [oldPayModes removeObject:paymode];
            }
            
            paymode.payment_acquirer_id = [dict arrayNotNullIDValueForKey:@"payment_acquirer_id"];
            paymode.payName = [dict stringValueForKey:@"name"];
            // type: [sale]-销售 [purchase]-采购 [cash]-现金 [bank]-银行 [general]-其它
            // pay_type: [normal]-普通方式结算 [card]-刷会员卡结算 [coupon]-刷微卡优惠券方式结算 [weixin_coupon]-刷微信优惠券方式结算 [other_coupon]-刷第三方卡券方式结算 [alipay]-刷支付宝方式结算 [weixin]-刷微信方式结算
            paymode.type = [dict stringValueForKey:@"type"];
            paymode.payType = [dict stringValueForKey:@"pay_type"];
            
            if ([paymode.type isEqualToString:@"bank"])
            {
                paymode.mode = [NSNumber numberWithInteger:kPadPayModeTypeBankCard];
            }
            else if ([paymode.type isEqualToString:@"cash"])
            {
                if ([paymode.payType isEqualToString:@"normal"])
                {
                    paymode.mode = [NSNumber numberWithInteger:kPadPayModeTypeCash];
                }
                else if ([paymode.payType isEqualToString:@"card"])
                {
                    paymode.mode = [NSNumber numberWithInteger:kPadPayModeTypeCard];
                }
                else if ([paymode.payType isEqualToString:@"coupon"])
                {
                    paymode.mode = [NSNumber numberWithInteger:kPadPayModeTypeCoupon];
                }
                else if ([paymode.payType isEqualToString:@"point"])
                {
                    paymode.mode = [NSNumber numberWithInteger:kPadPayModeTypePoint];
                }
                else if ([paymode.payType isEqualToString:@"weixin"])
                {
                    paymode.mode = [NSNumber numberWithInteger:kPadPayModeTypeWeChat];
                }
                else if ([paymode.payType isEqualToString:@"alipay"])
                {
                    paymode.mode = [NSNumber numberWithInteger:kPadPayModeTypeAlipay];
                }
                else if ([paymode.payType isEqualToString:@"weixin_coupon"])
                {
                    paymode.mode = [NSNumber numberWithInteger:kPadPayModeTypeWeiXinCoupon];
                }
                else if ([paymode.payType isEqualToString:@"other_coupon"])
                {
                    paymode.mode = [NSNumber numberWithInteger:kPadPayModeTypeOtherCoupon];
                }
            }
        }
        
        if (paymodeIds.count > 0)
        {
            BSFetchPosSessionRequest *request = [[BSFetchPosSessionRequest alloc] init];
            [request execute];
        }
        
        [coreDataManager deleteObjects:oldPayModes];
        [coreDataManager save:nil];
    }
    else
    {
        params = [self generateResponse:@"请求支付方式发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPayModeResponse object:self userInfo:params];
}

@end
