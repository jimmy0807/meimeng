//
//  CDProjectAttributeValue+CoreDataProperties.h
//  Boss
//
//  Created by jiangfei on 16/7/30.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDProjectAttributeValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDProjectAttributeValue (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *attributeID;
@property (nullable, nonatomic, retain) NSString *attributeName;
@property (nullable, nonatomic, retain) NSNumber *attributeValueID;
@property (nullable, nonatomic, retain) NSString *attributeValueName;
@property (nullable, nonatomic, retain) NSString *createDate;
@property (nullable, nonatomic, retain) NSString *displayName;
@property (nullable, nonatomic, retain) NSNumber *extraPrice;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSNumber *isSeleted;
@property (nullable, nonatomic, retain) CDProjectAttribute *attribute;
@property (nullable, nonatomic, retain) NSSet<CDProjectAttributeLine *> *attributeLines;
@property (nullable, nonatomic, retain) NSSet<CDProjectAttributePrice *> *attributePrices;
@property (nullable, nonatomic, retain) NSSet<CDProjectItem *> *projectItems;

@end

@interface CDProjectAttributeValue (CoreDataGeneratedAccessors)

- (void)addAttributeLinesObject:(CDProjectAttributeLine *)value;
- (void)removeAttributeLinesObject:(CDProjectAttributeLine *)value;
- (void)addAttributeLines:(NSSet<CDProjectAttributeLine *> *)values;
- (void)removeAttributeLines:(NSSet<CDProjectAttributeLine *> *)values;

- (void)addAttributePricesObject:(CDProjectAttributePrice *)value;
- (void)removeAttributePricesObject:(CDProjectAttributePrice *)value;
- (void)addAttributePrices:(NSSet<CDProjectAttributePrice *> *)values;
- (void)removeAttributePrices:(NSSet<CDProjectAttributePrice *> *)values;

- (void)addProjectItemsObject:(CDProjectItem *)value;
- (void)removeProjectItemsObject:(CDProjectItem *)value;
- (void)addProjectItems:(NSSet<CDProjectItem *> *)values;
- (void)removeProjectItems:(NSSet<CDProjectItem *> *)values;

@end

NS_ASSUME_NONNULL_END
