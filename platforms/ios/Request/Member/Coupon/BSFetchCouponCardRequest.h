//
//  BSFetchCouponCardRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/11/10.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchCouponCardRequest : ICRequest

- (id)initWithCouponCardIds:(NSArray *)couponCardIds;
- (id)initWithMemberId:(NSNumber *)memberId;

@end
