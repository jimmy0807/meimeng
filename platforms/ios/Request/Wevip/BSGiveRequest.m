//
//  BSGiveRequest.m
//  Boss
//
//  Created by lining on 15/11/23.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSGiveRequest.h"
#import "SBJson.h"
#import "NSArray+JSON.h"

@interface BSGiveRequest ()
@property (strong, nonatomic) CDPosOperate *opereate;
@property (assign, nonatomic) CouponObject *coupon;
@end

@implementation BSGiveRequest
- (instancetype)initWithOperate:(CDPosOperate *)operate coupon:(CouponObject *)coupon
{
    self = [super init];
    if (self) {
        self.opereate = operate;
        self.coupon = coupon;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    NSString *itemString = @"";
    if (self.items) {
        itemString = [self.items JSONRepresentation];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"card_no"] = self.opereate.memberCard.cardNo;
    params[@"card_uuid"] = self.opereate.memberCard.cardUUID;
    params[@"company_uuid"] = [PersonalProfile currentProfile].companyUUID;
    params[@"comster_id"] = self.opereate.wevip_member_id;
    params[@"course_money"] = self.coupon.courseMoney ? self.coupon.courseMoney : @0;
    params[@"expired_date"] = self.coupon.expiredDate;
    params[@"item_ids"] = itemString;
    params[@"member_no"] = self.opereate.member.memberNo;
    params[@"money"] = self.coupon.money ? self.coupon.money : @0;
    params[@"need_share"] = self.coupon.needShare;
    params[@"phone"] = self.opereate.member_mobile;
    params[@"shop_uuid"] = self.opereate.shop.shop_uuid;
    params[@"total_times"] = self.coupon.totalTimes;
    params[@"type"] = self.coupon.type;
    params[@"description"] = self.coupon.remarks ? self.coupon.remarks : @"";
    
    static NSString *cmd = @"/createCard";
    [self sendWeVipCommend:cmd params:params nosignKeys:@[@"item_ids"]];
    
    return TRUE;
}


- (void)didFinishOnMainThread
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *ret = [self.resultDictionary stringValueForKey:@"result"];
    if ([ret isEqualToString:@"SUCCESS"]) {
        NSLog(@"赠送成功");
    }
    else
    {
        NSLog(@"赠送失败");
        
        [dict setObject:@"rm" forKey:@"赠送失败，请稍后重试"];
        [dict setObject:@"rc" forKey:@-1];
    }
//    [dict setObject:@"rm" forKey:[ret stringByAppendingString:@"message"]];
    if ([self.coupon.type integerValue] == CouponType_ticket) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSGiveTicketResponse object:self.coupon.expiredDate userInfo:dict];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSGiveCardResponse object:self.coupon.expiredDate userInfo:dict];
    }
    
  
}

@end
