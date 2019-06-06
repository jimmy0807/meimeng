//
//  BSFetchPadOrderRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/18.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchPadOrderRequest.h"
#import "BSFetchPadOrderLineRequest.h"

@interface BSFetchPadOrderRequest ()

@end


@implementation BSFetchPadOrderRequest

- (BOOL)willStart
{
    self.tableName = @"pad.order";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *start = [NSString stringWithFormat:@"%@ 0:0:0", datestr];
    NSString *end = [NSString stringWithFormat:@"%@ 23:59:59", datestr];
    self.filter = @[@[@"create_date", @">=", start], @[@"create_date", @"<=", end], @[@"state", @"in", @[@"draft", @"submit"]]];
    self.field = @[];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *orderLineIds = [NSMutableArray array];
    if (resultStr.length != 0 && resultList != nil)
    {
        BSCoreDataManager *coreDateManager = [BSCoreDataManager currentManager];
        NSArray *orders = [coreDateManager fetchAllPadOrder];
        NSMutableArray *oldOrders = [NSMutableArray arrayWithArray:orders];
        for (NSDictionary *params in resultList)
        {
            NSNumber *orderID = [params numberValueForKey:@"id"];
            CDPosOperate *posOperate = [coreDateManager findEntity:@"CDPosOperate" withValue:orderID forKey:@"orderID"];
            if (posOperate == nil)
            {
                posOperate = [coreDateManager insertEntity:@"CDPosOperate"];
                posOperate.orderID = orderID;
                posOperate.isLocal = [NSNumber numberWithBool:YES];
                posOperate.operateType = [NSNumber numberWithInteger:kPadOrderFromPad];
            }
            else
            {
                [oldOrders removeObject:posOperate];
                NSString *lastUpdate = [params stringValueForKey:@"__last_update"];
                if ([lastUpdate compare:posOperate.operate_date] != NSOrderedDescending)
                {
                    continue;
                }
            }
            
            posOperate.operateType = [NSNumber numberWithInteger:kPadOrderFromPad];
            posOperate.orderNumber = [params stringValueForKey:@"no"];
            NSArray *memberInfos = [params objectForKey:@"member_id"];
            if ([memberInfos isKindOfClass:[NSArray class]] && memberInfos.count > 1)
            {
                posOperate.member_id = [memberInfos objectAtIndex:0];
                CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:posOperate.member_id forKey:@"memberID"];
                if (member == nil)
                {
                    member = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
                    member.memberID = posOperate.member_id;
                    member.memberName = [memberInfos objectAtIndex:1];
                    member.mobile = [params stringValueForKey:@"mobile"];
                }
                posOperate.member = member;
            }
            posOperate.member_name = [params stringValueForKey:@"name"];
            posOperate.member_mobile = [params stringValueForKey:@"mobile"];
            posOperate.handno = [params stringValueForKey:@"handno"];
            posOperate.amount = [NSNumber numberWithDouble:[[params objectForKey:@"price_subtotal"] doubleValue]];
            posOperate.operate_date = [params stringValueForKey:@"__last_update"];
            
            NSArray *createStaffInfos = [params objectForKey:@"create_uid"];
            if ([createStaffInfos isKindOfClass:[NSArray class]] && createStaffInfos.count > 1)
            {
                posOperate.operate_user_id = [createStaffInfos objectAtIndex:0];
                posOperate.operate_user_name = [createStaffInfos objectAtIndex:1];
                posOperate.orderCreateStaffID = [createStaffInfos objectAtIndex:0];
                posOperate.orderCreateStaffName = [createStaffInfos objectAtIndex:1];
            }
            
//            NSArray *companyInfos = [params objectForKey:@"company_id"];
//            if ([companyInfos isKindOfClass:[NSArray class]] && companyInfos.count > 1)
//            {
//                posOperate.operate_shop_id = [companyInfos objectAtIndex:0];
//                posOperate.operate_shop_name = [companyInfos objectAtIndex:1];
//            }
            
            NSArray *storeInfos = [params objectForKey:@"shop_id"];
            if ([storeInfos isKindOfClass:[NSArray class]] && storeInfos.count > 1)
            {
                posOperate.operate_shop_id = [storeInfos objectAtIndex:0];
                posOperate.operate_shop_name = [storeInfos objectAtIndex:1];
            }
            
            if ([[params stringValueForKey:@"state"] isEqualToString:@"draft"])
            {
                posOperate.orderState = [NSNumber numberWithInteger:kPadOrderDraft];
            }
            else if ([[params stringValueForKey:@"state"] isEqualToString:@"submit"])
            {
                posOperate.orderState = [NSNumber numberWithInteger:kPadOrderSubmit];
            }
            else if ([[params stringValueForKey:@"state"] isEqualToString:@"confirm"])
            {
                posOperate.orderState = [NSNumber numberWithInteger:kPadOrderConfirm];
            }
            else if ([[params stringValueForKey:@"state"] isEqualToString:@"checkout"])
            {
                posOperate.orderState = [NSNumber numberWithInteger:kPadOrderCheckout];
            }
            
            NSArray *lineIds = [params objectForKey:@"pad_order_line_ids"];
            if ([lineIds isKindOfClass:[NSArray class]] && lineIds.count > 0)
            {
                [orderLineIds addObjectsFromArray:lineIds];
            }
            
            if (posOperate.products.count != 0)
            {
                [coreDateManager deleteObjects:posOperate.products.array];
            }
            posOperate.products = [NSOrderedSet orderedSet];
        }
        [coreDateManager deleteObjects:oldOrders];
        [coreDateManager save:nil];
        
        BSFetchPadOrderLineRequest *request = [[BSFetchPadOrderLineRequest alloc] initWithPadOrderLineIds:orderLineIds];
        [request execute];
    }
    else
    {
        dict = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPadOrderResponse object:self userInfo:dict];
}

@end
