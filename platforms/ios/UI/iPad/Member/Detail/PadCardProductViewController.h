//
//  PadCardProductViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-4-7.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface PadCardProductViewController : ICCommonViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard;
- (id)initWithCouponCard:(CDCouponCard *)couponCard;

- (void)refreshWithMemberCard:(CDMemberCard *)memberCard;
- (void)refreshWithCouponCard:(CDCouponCard *)couponCard;

@end
