//
//  CDProjectConsumable+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2018/4/23.
//
//

#import "CDProjectConsumable+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDProjectConsumable (CoreDataProperties)

+ (NSFetchRequest<CDProjectConsumable *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *amount;
@property (nullable, nonatomic, copy) NSNumber *baseProductID;
@property (nullable, nonatomic, copy) NSString *baseProductName;
@property (nullable, nonatomic, copy) NSNumber *consumableID;
@property (nullable, nonatomic, copy) NSString *createDate;
@property (nullable, nonatomic, copy) NSNumber *isStock;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSNumber *productID;
@property (nullable, nonatomic, copy) NSString *productName;
@property (nullable, nonatomic, copy) NSNumber *qty;
@property (nullable, nonatomic, copy) NSNumber *uomID;
@property (nullable, nonatomic, copy) NSString *uomName;
@property (nullable, nonatomic, retain) NSSet<CDProjectTemplate *> *projectItems;
@property (nullable, nonatomic, retain) CDProjectItem *projectItem;

@end

@interface CDProjectConsumable (CoreDataGeneratedAccessors)

- (void)addProjectItemsObject:(CDProjectTemplate *)value;
- (void)removeProjectItemsObject:(CDProjectTemplate *)value;
- (void)addProjectItems:(NSSet<CDProjectTemplate *> *)values;
- (void)removeProjectItems:(NSSet<CDProjectTemplate *> *)values;

@end

NS_ASSUME_NONNULL_END
