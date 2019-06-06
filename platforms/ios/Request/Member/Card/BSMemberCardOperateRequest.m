//
//  BSMemberCardOperateRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/2.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSMemberCardOperateRequest.h"
#import "BSFetchMemberDetailReqeustN.h"
@interface BSMemberCardOperateRequest ()

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation BSMemberCardOperateRequest

- (id)initWithParams:(NSDictionary *)params operateType:(kPadMemberCardOperateType)operateType
{
    self = [super init];
    if (self != nil)
    {
        self.params = params;
        self.operateType = operateType;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.card.operate";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.params];
    NSString *typestr = @"";
    switch (self.operateType)
    {
        case kPadMemberCardOperateCashier:
        case kPadMemberCardOperateBuy:
            if ( params[@"is_update"] )
            {
                typestr = @"consume";
            }
            else
            {
                typestr = @"buy";
            }
            
            break;
            
        case kPadMemberCardOperateCreate:
            typestr = @"card";
            break;
            
        case kPadMemberCardOperateRecharge:
            typestr = @"recharge";
            break;
            
        case kPadMemberCardOperateRepayment:
            typestr = @"repayment";
            break;
            
        case kPadMemberCardOperateExchange:
            typestr = @"exchange";
            break;
            
        case kPadMemberCardOperateRefund:
            typestr = @"refund";
            break;
            
        case kPadMemberCardOperateReplacement:
            typestr = @"replacement";
            break;
            
        case kPadMemberCardOperateMerger:
            typestr = @"merger";
            break;
            
        case kPadMemberCardOperateActive:
            typestr = @"active";
            break;
            
        case kPadMemberCardOperateLost:
            typestr = @"lost";
            break;
            
        case kPadMemberCardOperateUpgrade:
            typestr = @"upgrade";
            break;
        case kPadMemberCardOperateGuadanPay:
            typestr = @"guadanPay";
            break;
        default:
            break;
    }
    
    if ([typestr isEqualToString:@"guadanPay"])
    {
        NSLog(@"%@",self.operate);
        NSMutableDictionary *guadanParams = [[NSMutableDictionary alloc] initWithDictionary:self.params];
        [guadanParams setObject:[self.params objectForKey:@"statement_ids"] forKey:@"statement_ids"];
        [guadanParams setObject:@(YES) forKey:@"is_checkout"];
        [self sendShopAssistantXmlWriteCommand:@[@[self.operate.operate_id],guadanParams]];
        return YES;
    }
    if ( params[@"is_update"] )
    {
        self.additionalParams = @[@{@"is_update":@(TRUE)}];
    }
    
    [params setObject:typestr forKey:@"type"];
    if ( self.operate.serial.length > 0 )
    {
        [params setObject:self.operate.serial forKey:@"serial"];
    }
    else
    {
        [params setObject:[NSNumber numberWithInteger:[PersonalProfile currentProfile].sessionID.integerValue] forKey:@"session_id"];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyyMMdd";
        NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
        NSString *timestamp = [NSString stringWithFormat:@"Pad%@%.0f", [dateFormatter stringFromDate:date], timeInterval];
        [params setObject:timestamp forKey:@"serial"];
        self.operate.serial = timestamp;
        [[BSCoreDataManager currentManager] save];
    }
    
    if ( self.orignalOperateID )
    {
        //[params setObject:self.orignalOperateID forKey:@"old_operate_id"];
    }
    
    self.params = [NSDictionary dictionaryWithDictionary:params];
    
    if ( [self.orignalOperateID integerValue] > 0 )
    {
        [self sendShopAssistantXmlWriteExtCommand:@[@[self.orignalOperateID],self.params]];
        //[self sendShopAssistantXmlWriteExtCommand:@[self.params]];
    }
    else
    {
        if ([self isMultiKeshi])
        {
            [self sendShopAssistantXmlCreateMultiCommand:@[self.params]];
        }
        else
        {
            [self sendShopAssistantXmlCreateCommand:@[self.params]];
        }
    }
    
    return YES;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (resultStr.length != 0 && [resultList isKindOfClass:[NSNumber class]])
    {
        if (self.operateType == kPadMemberCardOperateGuadanPay)
        {
            [dict setObject:self.operate.operate_id forKey:@"operate_id"];
        }
        else
        {
            [dict setObject:resultList forKey:@"operate_id"];
        }
        switch (self.operateType)
        {
            case kPadMemberCardOperateCreate:
            {
                NSNumber *memberID = [self.params numberValueForKey:@"member_id"];
                CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:memberID forKey:@"memberID"];
                if (member)
                {
                    BSFetchMemberDetailRequestN *request = [[BSFetchMemberDetailRequestN alloc] initWithMemberID:member.memberID];
                    [request execute];
                }
            }
                break;
            
            case kPadMemberCardOperateCashier:
            case kPadMemberCardOperateBuy:
            case kPadMemberCardOperateRecharge:
            case kPadMemberCardOperateRepayment:
            case kPadMemberCardOperateExchange:
            case kPadMemberCardOperateRefund:
            case kPadMemberCardOperateReplacement:
            case kPadMemberCardOperateActive:
            case kPadMemberCardOperateLost:
            case kPadMemberCardOperateUpgrade:
            case kPadMemberCardOperateBind:
            {
                if (self.operateType == kPadMemberCardOperateBuy || self.operateType == kPadMemberCardOperateCashier) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kBSMemberCashierSuccess object:resultList];
                }
                NSNumber *cardID = [self.params numberValueForKey:@"card_id"];
                //BSFetchMemberCardDetailRequest *request = [[BSFetchMemberCardDetailRequest alloc] initWithMemberCardID:cardID];
                //[request execute];
            }
                break;
                
            case kPadMemberCardOperateMerger:
            {
                BSFetchMemberDetailRequestN *request = [[BSFetchMemberDetailRequestN alloc] initWithMemberID:self.operate.member.memberID];
                [request execute];
            }
                break;
                
                
            default:
                break;
        }
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    NSNumber *cardID = [self.params numberValueForKey:@"card_id"];
    NSString *cardNumber = [self.params stringValueForKey:@"no"];
    [dict setObject:((cardID.integerValue != 0) ? cardID : @"") forKey:@"card_id"];
    [dict setObject:((cardNumber.integerValue != 0) ? cardNumber : @"") forKey:@"card_no"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSMemberCardOperateResponse object:dict userInfo:params];
}

- (BOOL)isMultiKeshi
{
    if ([[PersonalProfile currentProfile].multiKeshiSetting intValue] == 0)
    {
        return [PersonalProfile currentProfile].is_multi_department;
    }
    else if ([[PersonalProfile currentProfile].multiKeshiSetting intValue] == 1)
    {
        return NO;
    }
    else if ([[PersonalProfile currentProfile].multiKeshiSetting intValue] == 2)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
