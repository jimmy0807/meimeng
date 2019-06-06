//
//  CDProjectAttributeLine+CoreDataProperties.h
//  Boss
//
//  Created by jiangfei on 16/7/30.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDProjectAttributeLine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDProjectAttributeLine (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *attributeID;
@property (nullable, nonatomic, retain) NSNumber *attributeLineID;
@property (nullable, nonatomic, retain) NSString *attributeLineName;
@property (nullable, nonatomic, retain) NSString *attributeName;
@property (nullable, nonatomic, retain) NSString *createDate;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSNumber *templateID;
@property (nullable, nonatomic, retain) NSString *templateName;
@property (nullable, nonatomic, retain) NSNumber *isSelected;
@property (nullable, nonatomic, retain) CDProjectAttribute *attribute;
@property (nullable, nonatomic, retain) NSOrderedSet<CDProjectAttributeValue *> *attributeValues;
@property (nullable, nonatomic, retain) NSSet<CDProjectTemplate *> *projectItems;

@end

@interface CDProjectAttributeLine (CoreDataGeneratedAccessors)

- (void)insertObject:(CDProjectAttributeValue *)value inAttributeValuesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAttributeValuesAtIndex:(NSUInteger)idx;
- (void)insertAttributeValues:(NSArray<CDProjectAttributeValue *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAttributeValuesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAttributeValuesAtIndex:(NSUInteger)idx withObject:(CDProjectAttributeValue *)value;
- (void)replaceAttributeValuesAtIndexes:(NSIndexSet *)indexes withAttributeValues:(NSArray<CDProjectAttributeValue *> *)values;
- (void)addAttributeValuesObject:(CDProjectAttributeValue *)value;
- (void)removeAttributeValuesObject:(CDProjectAttributeValue *)value;
- (void)addAttributeValues:(NSOrderedSet<CDProjectAttributeValue *> *)values;
- (void)removeAttributeValues:(NSOrderedSet<CDProjectAttributeValue *> *)values;

- (void)addProjectItemsObject:(CDProjectTemplate *)value;
- (void)removeProjectItemsObject:(CDProjectTemplate *)value;
- (void)addProjectItems:(NSSet<CDProjectTemplate *> *)values;
- (void)removeProjectItems:(NSSet<CDProjectTemplate *> *)values;

@end

NS_ASSUME_NONNULL_END
