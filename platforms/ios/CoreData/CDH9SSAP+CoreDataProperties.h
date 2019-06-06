//
//  CDH9SSAP+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/8/7.
//
//

#import "CDH9SSAP+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDH9SSAP (CoreDataProperties)

+ (NSFetchRequest<CDH9SSAP *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *year_month;
@property (nullable, nonatomic, copy) NSNumber *day;
@property (nullable, nonatomic, copy) NSNumber *count;
@property (nullable, nonatomic, retain) NSOrderedSet<CDH9SSAPEvent *> *event;

@end

@interface CDH9SSAP (CoreDataGeneratedAccessors)

- (void)insertObject:(CDH9SSAPEvent *)value inEventAtIndex:(NSUInteger)idx;
- (void)removeObjectFromEventAtIndex:(NSUInteger)idx;
- (void)insertEvent:(NSArray<CDH9SSAPEvent *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeEventAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInEventAtIndex:(NSUInteger)idx withObject:(CDH9SSAPEvent *)value;
- (void)replaceEventAtIndexes:(NSIndexSet *)indexes withEvent:(NSArray<CDH9SSAPEvent *> *)values;
- (void)addEventObject:(CDH9SSAPEvent *)value;
- (void)removeEventObject:(CDH9SSAPEvent *)value;
- (void)addEvent:(NSOrderedSet<CDH9SSAPEvent *> *)values;
- (void)removeEvent:(NSOrderedSet<CDH9SSAPEvent *> *)values;

@end

NS_ASSUME_NONNULL_END
