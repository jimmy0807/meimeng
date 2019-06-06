//
//  MemberPay.m
//  Boss
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "MemberPay.h"

@implementation MemberPay
-(NSString *)payMoney
{
//    NSRange range = NSMakeRange(1, _payMoney.length-1);
//    NSString *money = [_payMoney substringWithRange:range];
    if([_payMoney isEqualToString:@""])
    {
        return @"0";
    }else{
        return _payMoney;
    }
}
@end
