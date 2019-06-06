//
//  CDZongkongLiyuanPerson+CoreDataProperties.h
//  meim
//
//  Created by 宋海斌 on 2017/6/22.
//
//

#import "CDZongkongLiyuanPerson+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDZongkongLiyuanPerson (CoreDataProperties)

+ (NSFetchRequest<CDZongkongLiyuanPerson *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *billed_time;
@property (nullable, nonatomic, copy) NSString *leave_time;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, copy) NSString *mobile;
@property (nullable, nonatomic, copy) NSString *member_type;
@property (nullable, nonatomic, retain) NSOrderedSet<CDZongkongLiyuanItem *> *item;

@end

@interface CDZongkongLiyuanPerson (CoreDataGeneratedAccessors)

- (void)insertObject:(CDZongkongLiyuanItem *)value inItemAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemAtIndex:(NSUInteger)idx;
- (void)insertItem:(NSArray<CDZongkongLiyuanItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemAtIndex:(NSUInteger)idx withObject:(CDZongkongLiyuanItem *)value;
- (void)replaceItemAtIndexes:(NSIndexSet *)indexes withItem:(NSArray<CDZongkongLiyuanItem *> *)values;
- (void)addItemObject:(CDZongkongLiyuanItem *)value;
- (void)removeItemObject:(CDZongkongLiyuanItem *)value;
- (void)addItem:(NSOrderedSet<CDZongkongLiyuanItem *> *)values;
- (void)removeItem:(NSOrderedSet<CDZongkongLiyuanItem *> *)values;

@end

NS_ASSUME_NONNULL_END
