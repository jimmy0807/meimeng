//
//  CDCouponCardProduct+CoreDataProperties.h
//  ds
//
//  Created by lining on 2016/11/18.
//
//

#import "CDCouponCardProduct+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDCouponCardProduct (CoreDataProperties)

+ (NSFetchRequest<CDCouponCardProduct *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *couponName;
@property (nullable, nonatomic, copy) NSString *defaultCode;
@property (nullable, nonatomic, copy) NSNumber *discount;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSNumber *localCount;
@property (nullable, nonatomic, copy) NSNumber *productID;
@property (nullable, nonatomic, copy) NSNumber *productLineID;
@property (nullable, nonatomic, copy) NSString *productName;
@property (nullable, nonatomic, copy) NSNumber *purchaseQty;
@property (nullable, nonatomic, copy) NSNumber *remainQty;
@property (nullable, nonatomic, copy) NSNumber *unitPrice;
@property (nullable, nonatomic, copy) NSNumber *uomID;
@property (nullable, nonatomic, copy) NSString *uomName;
@property (nullable, nonatomic, retain) CDCouponCard *coupon;
@property (nullable, nonatomic, retain) CDProjectItem *item;
@property (nullable, nonatomic, retain) NSSet<CDCurrentUseItem *> *useItem;

@end

@interface CDCouponCardProduct (CoreDataGeneratedAccessors)

- (void)addUseItemObject:(CDCurrentUseItem *)value;
- (void)removeUseItemObject:(CDCurrentUseItem *)value;
- (void)addUseItem:(NSSet<CDCurrentUseItem *> *)values;
- (void)removeUseItem:(NSSet<CDCurrentUseItem *> *)values;

@end

NS_ASSUME_NONNULL_END
