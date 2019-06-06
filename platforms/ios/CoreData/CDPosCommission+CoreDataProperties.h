//
//  CDPosCommission+CoreDataProperties.h
//  Boss
//
//  Created by lining on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPosCommission.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPosCommission (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *base_amount;
@property (nullable, nonatomic, retain) NSString *commission_date;
@property (nullable, nonatomic, retain) NSNumber *commission_id;
@property (nullable, nonatomic, retain) NSNumber *company_id;
@property (nullable, nonatomic, retain) NSString *company_name;
@property (nullable, nonatomic, retain) NSNumber *do_amount;
@property (nullable, nonatomic, retain) NSNumber *do_point_count;
@property (nullable, nonatomic, retain) NSNumber *employee_id;
@property (nullable, nonatomic, retain) NSString *employee_name;
@property (nullable, nonatomic, retain) NSNumber *gift;
@property (nullable, nonatomic, retain) NSNumber *gift_count;
@property (nullable, nonatomic, retain) NSNumber *is_dian_dan;
@property (nullable, nonatomic, retain) NSNumber *operate_id;
@property (nullable, nonatomic, retain) NSString *operate_name;
@property (nullable, nonatomic, retain) NSNumber *point_count;
@property (nullable, nonatomic, retain) NSNumber *product_id;
@property (nullable, nonatomic, retain) NSString *product_name;
@property (nullable, nonatomic, retain) NSString *remark;
@property (nullable, nonatomic, retain) NSNumber *rule_id;
@property (nullable, nonatomic, retain) NSString *rule_name;
@property (nullable, nonatomic, retain) NSNumber *sale_amount;
@property (nullable, nonatomic, retain) NSString *sale_or_do;
@property (nullable, nonatomic, retain) NSNumber *sale_point_count;
@property (nullable, nonatomic, retain) NSNumber *shop_id;
@property (nullable, nonatomic, retain) NSString *shop_name;
@property (nullable, nonatomic, retain) CDPosOperate *operate;

@end

NS_ASSUME_NONNULL_END
