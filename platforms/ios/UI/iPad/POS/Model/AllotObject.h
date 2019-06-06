//
//  AllotSaleObject.h
//  Boss
//
//  Created by lining on 15/11/5.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllotObject : NSObject
@property(nonatomic, strong) CDStaff *staff;
@property(nonatomic, strong) CDPosCommission *commission;
@property(nonatomic, strong) CDCommissionRule *commissionRule;
@property(nonatomic, strong) NSNumber *employee_id;
@property(nonatomic, strong) NSString *employee_name;
@property(nonatomic, strong) NSNumber *count;
@property(nonatomic, strong) NSNumber *money;
@property(nonatomic, strong) NSNumber *priceUnit;
@property(nonatomic, strong) NSString *techType;//分配技师时的手法类型
@property(nonatomic, strong) NSNumber *is_dian_dan;
@property(nonatomic, strong) NSNumber *rule_id;
@property(nonatomic, strong) NSString *rule_name;
@property(nonatomic, assign) bool gift;
@property(nonatomic, strong) NSNumber *giftCount;
@end
