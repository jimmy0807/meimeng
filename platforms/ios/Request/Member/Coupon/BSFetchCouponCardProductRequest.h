//
//  BSFetchCouponCardProductRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/11/10.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchCouponCardProductRequest : ICRequest

- (id)initWithCouponCardProductIds:(NSArray *)productIds;
- (id)initWithCouponCardId:(NSNumber *)couponId;
@end
