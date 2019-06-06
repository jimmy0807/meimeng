//
//  OperateManager.h
//  Boss
//
//  Created by lining on 16/7/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kChangeMemberAndCard    @"kChangeMemberAndCard"
#define kShopCartDataChanged    @"kShopCartDataChanged"
#define kLocalGuaDanResponse    @"kLocalGuaDanResponse"

@interface OperateManager : NSObject
+ (instancetype)shareManager;

@property (nonatomic, strong) NSMutableArray *cardItems;
@property (nonatomic, strong) CDPosOperate *posOperate;

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) CDCouponCard *couponCard;

- (void)addObject:(NSObject *)object;

- (void)reloadPosOperate;
- (void)guaDan;
@end
