//
//  CDHShoushu+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/5/10.
//
//

#import "CDHShoushu+CoreDataClass.h"
@class CDHShoushuLine;

NS_ASSUME_NONNULL_BEGIN

@interface CDHShoushu (CoreDataProperties)

+ (NSFetchRequest<CDHShoushu *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *create_date;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSString *expander_in_date;
@property (nullable, nonatomic, copy) NSString *expander_review_1;
@property (nullable, nonatomic, copy) NSString *expander_review_2;
@property (nullable, nonatomic, copy) NSString *expander_review_3;
@property (nullable, nonatomic, copy) NSString *expander_review_days_1;
@property (nullable, nonatomic, copy) NSString *expander_review_days_2;
@property (nullable, nonatomic, copy) NSString *expander_review_days_3;
@property (nullable, nonatomic, copy) NSString *first_treat_date;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *note;
@property (nullable, nonatomic, copy) NSNumber *shoushu_id;
@property (nullable, nonatomic, retain) CDHBinglika *binglika;
@property (nullable, nonatomic, retain) NSOrderedSet<CDHShoushuLine *> *items;

@end

@interface CDHShoushu (CoreDataGeneratedAccessors)

- (void)insertObject:(CDHShoushuLine *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray<CDHShoushuLine *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(CDHShoushuLine *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray<CDHShoushuLine *> *)values;
- (void)addItemsObject:(CDHShoushuLine *)value;
- (void)removeItemsObject:(CDHShoushuLine *)value;
- (void)addItems:(NSOrderedSet<CDHShoushuLine *> *)values;
- (void)removeItems:(NSOrderedSet<CDHShoushuLine *> *)values;

@end

NS_ASSUME_NONNULL_END
