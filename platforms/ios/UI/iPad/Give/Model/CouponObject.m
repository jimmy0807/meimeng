//
//  CouponObject.m
//  Boss
//
//  Created by lining on 15/11/24.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "CouponObject.h"

@implementation CouponObject

- (instancetype)initWithType:(CouponType)type
{
    self = [super init];
    if (self) {
        self.type = [NSNumber numberWithInt:type];
        self.needShare = @2;
        self.totalTimes = @0;
    }
    return self;
}

- (instancetype)initWithTemplate:(CDCardTemplate *)cardTemplate
{
    self = [super init];
    if (self) {
        self.expiredDate = cardTemplate.expire_date;
        self.money = cardTemplate.money;
        self.short_description = cardTemplate.short_description;
        self.long_description = cardTemplate.long_description;
    }
    
    return self;
}

@end
