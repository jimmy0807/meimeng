//
//  BSFetchPosCommissionRequest.m
//  Boss
//  提成分配
//  Created by lining on 15/11/12.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchPosCommissionRequest.h"

@interface BSFetchPosCommissionRequest ()
@property (nonatomic, strong) CDPosOperate *operate;
@property (nonatomic, strong) NSArray *commission_ids;
@end

@implementation BSFetchPosCommissionRequest

- (instancetype)initWithPosOperate:(CDPosOperate *)operate
{
    self = [super init];
    if (self) {
        self.operate = operate;
        self.commission_ids = [self.operate.commission_ids componentsSeparatedByString:@","];
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    if (self.commission_ids.count == 0) {
        return FALSE;
    }
    
    self.tableName = @"commission.assign";
//    self.filter = @[@[@"id",@"in",self.commission_ids]];
    self.filter = @[@[@"operate_id",@"=",self.operate.operate_id]];
    self.field = @[];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
    NSMutableDictionary *dict = nil;
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        if (self.operate.commissions.count > 0) {
            [dataManager deleteObjects:self.operate.commissions.array];
            self.operate.commissions = nil;
        }
        for (NSDictionary *params in retArray) {
            CDPosCommission *commossion = [dataManager insertEntity:@"CDPosCommission"];
            commossion.commission_id = [params numberValueForKey:@"id"];
            
            commossion.sale_or_do = [params stringValueForKey:@"sale_or_do"];

            commossion.gift = [params numberValueForKey:@"gift"];
            commossion.gift_count = [params numberValueForKey:@"gift_qty"];
            
            commossion.point_count = [params numberValueForKey:@"point"];
            
            if ([commossion.sale_or_do isEqualToString:@"do"]) //手工业绩
            {
                commossion.do_point_count = commossion.point_count;
            }
            else if ([commossion.sale_or_do isEqualToString:@"sale"]) //销售业绩
            {
                commossion.sale_point_count = commossion.point_count;
            }
            else if ([commossion.sale_or_do isEqualToString:@"rechange"]) // 充值业绩
            {
                
            }
            
            commossion.sale_amount = [params numberValueForKey:@"sale_base_amount"];
            commossion.base_amount = [params numberValueForKey:@"base_amount"];
            
            commossion.is_dian_dan = [params numberValueForKey:@"named"]; //点单、轮单
            
            commossion.product_id = [params arrayIDValueForKey:@"product_id"];
            commossion.product_name = [params arrayNameValueForKey:@"product_id"];
            
            commossion.shop_id = [params arrayIDValueForKey:@"shop_id"];
            commossion.shop_name = [params arrayNameValueForKey:@"shop_id"];

            commossion.employee_id = [params arrayIDValueForKey:@"employee_id"];
            commossion.employee_name = [params arrayNameValueForKey:@"employee_id"];
            
            commossion.rule_id = [params arrayIDValueForKey:@"commission_rule_id"];
            commossion.rule_name = [params arrayNameValueForKey:@"commission_rule_id"];
            
            commossion.operate_id = [params arrayIDValueForKey:@"operate_id"];
            commossion.operate_name = [params arrayNameValueForKey:@"operate_id"];
            
            [orderedSet addObject:commossion];

        }
        self.operate.commissions = orderedSet;
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchPosCommissionResponse object:nil userInfo:dict];
}

@end
