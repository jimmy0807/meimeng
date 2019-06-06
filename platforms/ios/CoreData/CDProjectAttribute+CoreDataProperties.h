//
//  CDProjectAttribute+CoreDataProperties.h
//  Boss
//
//  Created by jiangfei on 16/8/3.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDProjectAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDProjectAttribute (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *attributeID;
@property (nullable, nonatomic, retain) NSString *attributeName;
@property (nullable, nonatomic, retain) NSString *createDate;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSNumber *isSeleted;
@property (nullable, nonatomic, retain) NSSet<CDProjectAttributeLine *> *attributeLines;
@property (nullable, nonatomic, retain) NSOrderedSet<CDProjectAttributeValue *> *attributeValues;

@end

@interface CDProjectAttribute (CoreDataGeneratedAccessors)

- (void)addAttributeLinesObject:(CDProjectAttributeLine *)value;
- (void)removeAttributeLinesObject:(CDProjectAttributeLine *)value;
- (void)addAttributeLines:(NSSet<CDProjectAttributeLine *> *)values;
- (void)removeAttributeLines:(NSSet<CDProjectAttributeLine *> *)values;

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

@end

NS_ASSUME_NONNULL_END
