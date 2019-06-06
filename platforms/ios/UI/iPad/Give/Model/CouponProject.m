//
//  CouponProject.m
//  Boss
//
//  Created by lining on 15/11/23.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "CouponProject.h"

@implementation CouponProject
- (instancetype)initWithItem:(CDProjectItem *)item
{
    self = [super init];
    if (self) {
        self.item = item;
        self.count = 1;
    }
    return self;
}

@end
