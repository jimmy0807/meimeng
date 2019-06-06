//
//  CDHBinglika+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/5/9.
//
//

#import "CDHBinglika+CoreDataClass.h"

@class CDHHuizhen;
@class CDHShoushu;

NS_ASSUME_NONNULL_BEGIN

@interface CDHBinglika (CoreDataProperties)

+ (NSFetchRequest<CDHBinglika *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *binglika_id;
@property (nullable, nonatomic, copy) NSString *create_date;
@property (nullable, nonatomic, copy) NSString *first_treat_date;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *mobile;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, retain) NSOrderedSet<CDHHuizhen *> *huizhen;
@property (nullable, nonatomic, retain) NSOrderedSet<CDHShoushu *> *shoushu;

@end

@interface CDHBinglika (CoreDataGeneratedAccessors)

- (void)insertObject:(CDHHuizhen *)value inHuizhenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHuizhenAtIndex:(NSUInteger)idx;
- (void)insertHuizhen:(NSArray<CDHHuizhen *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHuizhenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHuizhenAtIndex:(NSUInteger)idx withObject:(CDHHuizhen *)value;
- (void)replaceHuizhenAtIndexes:(NSIndexSet *)indexes withHuizhen:(NSArray<CDHHuizhen *> *)values;
- (void)addHuizhenObject:(CDHHuizhen *)value;
- (void)removeHuizhenObject:(CDHHuizhen *)value;
- (void)addHuizhen:(NSOrderedSet<CDHHuizhen *> *)values;
- (void)removeHuizhen:(NSOrderedSet<CDHHuizhen *> *)values;

- (void)insertObject:(CDHShoushu *)value inShoushuAtIndex:(NSUInteger)idx;
- (void)removeObjectFromShoushuAtIndex:(NSUInteger)idx;
- (void)insertShoushu:(NSArray<CDHShoushu *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeShoushuAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInShoushuAtIndex:(NSUInteger)idx withObject:(CDHShoushu *)value;
- (void)replaceShoushuAtIndexes:(NSIndexSet *)indexes withShoushu:(NSArray<CDHShoushu *> *)values;
- (void)addShoushuObject:(CDHShoushu *)value;
- (void)removeShoushuObject:(CDHShoushu *)value;
- (void)addShoushu:(NSOrderedSet<CDHShoushu *> *)values;
- (void)removeShoushu:(NSOrderedSet<CDHShoushu *> *)values;

@end

NS_ASSUME_NONNULL_END
