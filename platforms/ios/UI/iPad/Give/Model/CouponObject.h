//
//  CouponObject.h
//  Boss
//
//  Created by lining on 15/11/24.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CouponType
{
    CouponType_ticket = 2,
    CouponType_card,
}CouponType;

@interface CouponObject : NSObject
@property(strong, nonatomic) NSNumber *courseMoney; //礼品劵内项目 总计
@property(strong, nonatomic) NSNumber *money; //礼品卡 金额
@property(strong, nonatomic) NSNumber *needShare;
@property(strong, nonatomic) NSNumber *totalTimes;
@property(strong, nonatomic) NSNumber *type;   //表示类型
@property(strong, nonatomic) NSString *remarks;
@property(strong, nonatomic) NSString *expiredDate; //有效期
@property(strong, nonatomic) NSString *short_description;
@property(strong, nonatomic) NSString *long_description;

- (instancetype) initWithType:(CouponType)type;
- (instancetype)initWithTemplate:(CDCardTemplate *)cardTemplate;

@end
