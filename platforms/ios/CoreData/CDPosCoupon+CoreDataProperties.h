//
//  CDPosCoupon+CoreDataProperties.h
//  Boss
//
//  Created by lining on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPosCoupon.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPosCoupon (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *born_uuid;
@property (nullable, nonatomic, retain) NSNumber *consum_coupon_line_id;
@property (nullable, nonatomic, retain) NSString *consum_coupon_product_lines;
@property (nullable, nonatomic, retain) NSNumber *consume_money;
@property (nullable, nonatomic, retain) NSNumber *coupon_id;
@property (nullable, nonatomic, retain) NSString *coupon_name;
@property (nullable, nonatomic, retain) NSString *coupon_no;
@property (nullable, nonatomic, retain) NSNumber *operate_id;
@property (nullable, nonatomic, retain) NSString *operate_name;
@property (nullable, nonatomic, retain) NSNumber *shop_id;
@property (nullable, nonatomic, retain) NSString *shop_name;
@property (nullable, nonatomic, retain) NSOrderedSet<CDPosOperate *> *operates;
@property (nullable, nonatomic, retain) NSOrderedSet<CDPosCouponProduct *> *products;

@end

@interface CDPosCoupon (CoreDataGeneratedAccessors)

- (void)insertObject:(CDPosOperate *)value inOperatesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromOperatesAtIndex:(NSUInteger)idx;
- (void)insertOperates:(NSArray<CDPosOperate *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeOperatesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInOperatesAtIndex:(NSUInteger)idx withObject:(CDPosOperate *)value;
- (void)replaceOperatesAtIndexes:(NSIndexSet *)indexes withOperates:(NSArray<CDPosOperate *> *)values;
- (void)addOperatesObject:(CDPosOperate *)value;
- (void)removeOperatesObject:(CDPosOperate *)value;
- (void)addOperates:(NSOrderedSet<CDPosOperate *> *)values;
- (void)removeOperates:(NSOrderedSet<CDPosOperate *> *)values;

- (void)insertObject:(CDPosCouponProduct *)value inProductsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromProductsAtIndex:(NSUInteger)idx;
- (void)insertProducts:(NSArray<CDPosCouponProduct *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeProductsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInProductsAtIndex:(NSUInteger)idx withObject:(CDPosCouponProduct *)value;
- (void)replaceProductsAtIndexes:(NSIndexSet *)indexes withProducts:(NSArray<CDPosCouponProduct *> *)values;
- (void)addProductsObject:(CDPosCouponProduct *)value;
- (void)removeProductsObject:(CDPosCouponProduct *)value;
- (void)addProducts:(NSOrderedSet<CDPosCouponProduct *> *)values;
- (void)removeProducts:(NSOrderedSet<CDPosCouponProduct *> *)values;

@end

NS_ASSUME_NONNULL_END
