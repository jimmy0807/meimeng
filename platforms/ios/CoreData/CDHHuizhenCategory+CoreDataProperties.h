//
//  CDHHuizhenCategory+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/7/21.
//
//

#import "CDHHuizhenCategory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDHHuizhenCategory (CoreDataProperties)

+ (NSFetchRequest<CDHHuizhenCategory *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *cateogry_id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *parent_id;
@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, retain) NSOrderedSet<CDHHuizhenCategory *> *childs;
@property (nullable, nonatomic, retain) CDHHuizhenCategory *parent;

@end

@interface CDHHuizhenCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(CDHHuizhenCategory *)value inChildsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildsAtIndex:(NSUInteger)idx;
- (void)insertChilds:(NSArray<CDHHuizhenCategory *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildsAtIndex:(NSUInteger)idx withObject:(CDHHuizhenCategory *)value;
- (void)replaceChildsAtIndexes:(NSIndexSet *)indexes withChilds:(NSArray<CDHHuizhenCategory *> *)values;
- (void)addChildsObject:(CDHHuizhenCategory *)value;
- (void)removeChildsObject:(CDHHuizhenCategory *)value;
- (void)addChilds:(NSOrderedSet<CDHHuizhenCategory *> *)values;
- (void)removeChilds:(NSOrderedSet<CDHHuizhenCategory *> *)values;

@end

NS_ASSUME_NONNULL_END
