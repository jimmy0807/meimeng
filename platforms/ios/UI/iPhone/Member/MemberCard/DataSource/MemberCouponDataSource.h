//
//  MemberCouponDataSource.h
//  Boss
//
//  Created by lining on 16/8/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MemberCouponDataSourceDelegate <NSObject>
@optional
- (void)didSelectctdedCouponCard:(CDCouponCard *)couponCard;
@end

@interface MemberCouponDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *couponCards;
@property (nonatomic, weak) id<MemberCouponDataSourceDelegate>delegate;
@end
