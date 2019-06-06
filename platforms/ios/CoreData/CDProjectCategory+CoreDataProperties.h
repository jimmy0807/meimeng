//
//  CDProjectCategory+CoreDataProperties.h
//  ds
//
//  Created by lining on 2016/10/24.
//
//

#import "CDProjectCategory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDProjectCategory (CoreDataProperties)

+ (NSFetchRequest<CDProjectCategory *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *categoryID;
@property (nullable, nonatomic, copy) NSString *categoryName;
@property (nullable, nonatomic, copy) NSString *createDate;
@property (nullable, nonatomic, copy) NSNumber *itemCount;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSNumber *otherCount;
@property (nullable, nonatomic, copy) NSNumber *parentID;
@property (nullable, nonatomic, copy) NSString *parentName;
@property (nullable, nonatomic, copy) NSNumber *sequence;
@property (nullable, nonatomic, copy) NSString *serialID;
@property (nullable, nonatomic, copy) NSNumber *departments_id;
@property (nullable, nonatomic, copy) NSString *departments_name;
@property (nullable, nonatomic, retain) NSSet<CDProjectItem *> *items;
@property (nullable, nonatomic, retain) CDProjectCategory *parent;
@property (nullable, nonatomic, retain) NSOrderedSet<CDProjectCategory *> *subCategory;
@property (nullable, nonatomic, retain) NSSet<CDProjectTemplate *> *templates;

@end

@interface CDProjectCategory (CoreDataGeneratedAccessors)

- (void)addItemsObject:(CDProjectItem *)value;
- (void)removeItemsObject:(CDProjectItem *)value;
- (void)addItems:(NSSet<CDProjectItem *> *)values;
- (void)removeItems:(NSSet<CDProjectItem *> *)values;

- (void)insertObject:(CDProjectCategory *)value inSubCategoryAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSubCategoryAtIndex:(NSUInteger)idx;
- (void)insertSubCategory:(NSArray<CDProjectCategory *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSubCategoryAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSubCategoryAtIndex:(NSUInteger)idx withObject:(CDProjectCategory *)value;
- (void)replaceSubCategoryAtIndexes:(NSIndexSet *)indexes withSubCategory:(NSArray<CDProjectCategory *> *)values;
- (void)addSubCategoryObject:(CDProjectCategory *)value;
- (void)removeSubCategoryObject:(CDProjectCategory *)value;
- (void)addSubCategory:(NSOrderedSet<CDProjectCategory *> *)values;
- (void)removeSubCategory:(NSOrderedSet<CDProjectCategory *> *)values;

- (void)addTemplatesObject:(CDProjectTemplate *)value;
- (void)removeTemplatesObject:(CDProjectTemplate *)value;
- (void)addTemplates:(NSSet<CDProjectTemplate *> *)values;
- (void)removeTemplates:(NSSet<CDProjectTemplate *> *)values;

@end

NS_ASSUME_NONNULL_END
