//
//  CDQuestionResult+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/6/14.
//
//

#import "CDQuestionResult+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDQuestionResult (CoreDataProperties)

+ (NSFetchRequest<CDQuestionResult *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *company_id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *recommend;
@property (nullable, nonatomic, copy) NSNumber *result_id;
@property (nullable, nonatomic, retain) NSOrderedSet<CDQuestionResultItem *> *items;

@end

@interface CDQuestionResult (CoreDataGeneratedAccessors)

- (void)insertObject:(CDQuestionResultItem *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray<CDQuestionResultItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(CDQuestionResultItem *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray<CDQuestionResultItem *> *)values;
- (void)addItemsObject:(CDQuestionResultItem *)value;
- (void)removeItemsObject:(CDQuestionResultItem *)value;
- (void)addItems:(NSOrderedSet<CDQuestionResultItem *> *)values;
- (void)removeItems:(NSOrderedSet<CDQuestionResultItem *> *)values;

@end

NS_ASSUME_NONNULL_END
