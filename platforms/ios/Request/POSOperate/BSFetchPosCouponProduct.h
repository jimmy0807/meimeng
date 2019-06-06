//
//  BSFetchPosCoupanProduct.h
//  Boss
//
//  Created by lining on 15/11/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchPosCouponProduct : ICRequest
//- (instancetype) initWithCoupon:(CDPosCoupon *)consumeCoupon operate:(CDPosOperate *)operate;
@property (nonatomic, strong) NSArray *couponIds;
@property (strong, nonatomic) CDPosOperate *operate;
@end
