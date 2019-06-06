//
//  CDProjectRelated+CoreDataProperties.h
//  Boss
//
//  Created by jiangfei on 16/7/20.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDProjectRelated.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDProjectRelated (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *createDate;
@property (nullable, nonatomic, retain) NSNumber *isUnlimited;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSNumber *openPrice;
@property (nullable, nonatomic, retain) NSNumber *parentProductID;
@property (nullable, nonatomic, retain) NSString *parentProductName;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSNumber *productID;
@property (nullable, nonatomic, retain) NSString *productName;
@property (nullable, nonatomic, retain) NSNumber *quantity;
@property (nullable, nonatomic, retain) NSNumber *relatedID;
@property (nullable, nonatomic, retain) NSNumber *subTotal;

@property (nullable, nonatomic, retain) NSNumber *unlimitedDays;
@property (nullable, nonatomic, retain) NSNumber *is_show_more;
//有效期限
@property (nullable, nonatomic, retain) NSNumber *limited_date;
//有效期限不限次数使用
@property (nullable, nonatomic, retain) NSNumber *limited_qty;
@property (nullable, nonatomic, retain) NSNumber *same_price_replace;
@property (nullable, nonatomic, retain) NSNumber *same_price_replace_max;
@property (nullable, nonatomic, retain) NSNumber *same_price_replace_min;
@property (nullable, nonatomic, retain) CDProjectItem *item;
@property (nullable, nonatomic, retain) NSOrderedSet<CDProjectItem *> *sameItems;

@end

@interface CDProjectRelated (CoreDataGeneratedAccessors)

- (void)insertObject:(CDProjectItem *)value inSameItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSameItemsAtIndex:(NSUInteger)idx;
- (void)insertSameItems:(NSArray<CDProjectItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSameItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSameItemsAtIndex:(NSUInteger)idx withObject:(CDProjectItem *)value;
- (void)replaceSameItemsAtIndexes:(NSIndexSet *)indexes withSameItems:(NSArray<CDProjectItem *> *)values;
- (void)addSameItemsObject:(CDProjectItem *)value;
- (void)removeSameItemsObject:(CDProjectItem *)value;
- (void)addSameItems:(NSOrderedSet<CDProjectItem *> *)values;
- (void)removeSameItems:(NSOrderedSet<CDProjectItem *> *)values;

@end

NS_ASSUME_NONNULL_END
