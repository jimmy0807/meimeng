//
//  CDCouponCard+CoreDataProperties.h
//  Boss
//
//  Created by XiaXianBing on 2016-4-7.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDCouponCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDCouponCard (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSString *buyMobile;
@property (nullable, nonatomic, retain) NSNumber *cardID;
@property (nullable, nonatomic, retain) NSString *cardName;
@property (nullable, nonatomic, retain) NSString *cardNote;
@property (nullable, nonatomic, retain) NSString *cardNumber;
@property (nullable, nonatomic, retain) NSNumber *cardPrice;
@property (nullable, nonatomic, retain) NSNumber *cardType;
@property (nullable, nonatomic, retain) NSNumber *companyID;
@property (nullable, nonatomic, retain) NSString *companyName;
@property (nullable, nonatomic, retain) NSNumber *courseRemainAmount;
@property (nullable, nonatomic, retain) NSNumber *courseRemainQty;
@property (nullable, nonatomic, retain) NSNumber *discount;
@property (nullable, nonatomic, retain) NSString *invalidDate;
@property (nullable, nonatomic, retain) NSNumber *isInvalid;
@property (nullable, nonatomic, retain) NSNumber *isPush;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSNumber *memberID;
@property (nullable, nonatomic, retain) NSString *memberName;
@property (nullable, nonatomic, retain) NSNumber *needShare;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSString *publishedDate;
@property (nullable, nonatomic, retain) NSNumber *remainAmount;
@property (nullable, nonatomic, retain) NSString *remark;
@property (nullable, nonatomic, retain) NSNumber *sourceType;
@property (nullable, nonatomic, retain) NSNumber *state;
@property (nullable, nonatomic, retain) NSNumber *storeID;
@property (nullable, nonatomic, retain) NSString *storeName;
@property (nullable, nonatomic, retain) CDMember *member;
@property (nullable, nonatomic, retain) CDPosOperate *posOperate;
@property (nullable, nonatomic, retain) NSOrderedSet<CDCouponCardProduct *> *products;

@end

@interface CDCouponCard (CoreDataGeneratedAccessors)

- (void)insertObject:(CDCouponCardProduct *)value inProductsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromProductsAtIndex:(NSUInteger)idx;
- (void)insertProducts:(NSArray<CDCouponCardProduct *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeProductsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInProductsAtIndex:(NSUInteger)idx withObject:(CDCouponCardProduct *)value;
- (void)replaceProductsAtIndexes:(NSIndexSet *)indexes withProducts:(NSArray<CDCouponCardProduct *> *)values;
- (void)addProductsObject:(CDCouponCardProduct *)value;
- (void)removeProductsObject:(CDCouponCardProduct *)value;
- (void)addProducts:(NSOrderedSet<CDCouponCardProduct *> *)values;
- (void)removeProducts:(NSOrderedSet<CDCouponCardProduct *> *)values;

@end

NS_ASSUME_NONNULL_END
