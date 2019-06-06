//
//  CDMemberCardProject+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/5/18.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberCardProject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberCardProject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *born_category;
@property (nullable, nonatomic, retain) NSNumber *card_id;
@property (nullable, nonatomic, retain) NSString *card_name;
@property (nullable, nonatomic, retain) NSString *create_date;
@property (nullable, nonatomic, retain) NSString *defaultCode;
@property (nullable, nonatomic, retain) NSNumber *depositQty;
@property (nullable, nonatomic, retain) NSString *depositState;
@property (nullable, nonatomic, retain) NSString *detailInfo;
@property (nullable, nonatomic, retain) NSNumber *discount;
@property (nullable, nonatomic, retain) NSNumber *isDeposit;
@property (nullable, nonatomic, retain) NSNumber *isLimited;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSString *limitedDate;
@property (nullable, nonatomic, retain) NSNumber *localCount;
@property (nullable, nonatomic, retain) NSNumber *member_id;
@property (nullable, nonatomic, retain) NSString *member_name;
@property (nullable, nonatomic, retain) NSNumber *operateID;
@property (nullable, nonatomic, retain) NSString *operateName;
@property (nullable, nonatomic, retain) NSNumber *parent_product_id;
@property (nullable, nonatomic, retain) NSNumber *productLineID;
@property (nullable, nonatomic, retain) NSNumber *projectCount;
@property (nullable, nonatomic, retain) NSNumber *projectID;
@property (nullable, nonatomic, retain) NSString *projectManualPrice;
@property (nullable, nonatomic, retain) NSString *projectName;
@property (nullable, nonatomic, retain) NSNumber *projectPrice;
@property (nullable, nonatomic, retain) NSNumber *projectPriceUnit;
@property (nullable, nonatomic, retain) NSNumber *projectTotalPrice;
@property (nullable, nonatomic, retain) NSNumber *purchaseQty;
@property (nullable, nonatomic, retain) NSNumber *remainDepositQty;
@property (nullable, nonatomic, retain) NSNumber *remainQty;
@property (nullable, nonatomic, retain) NSString *section_date;
@property (nullable, nonatomic, retain) NSNumber *uomID;
@property (nullable, nonatomic, retain) NSString *uomName;
@property (nullable, nonatomic, retain) NSString *section_category;
@property (nullable, nonatomic, retain) CDMemberCard *card;
@property (nullable, nonatomic, retain) CDProjectItem *item;
@property (nullable, nonatomic, retain) CDMemberCard *memberCard;
@property (nullable, nonatomic, retain) NSOrderedSet<CDCurrentUseItem *> *useItem;

@end

@interface CDMemberCardProject (CoreDataGeneratedAccessors)

- (void)insertObject:(CDCurrentUseItem *)value inUseItemAtIndex:(NSUInteger)idx;
- (void)removeObjectFromUseItemAtIndex:(NSUInteger)idx;
- (void)insertUseItem:(NSArray<CDCurrentUseItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeUseItemAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInUseItemAtIndex:(NSUInteger)idx withObject:(CDCurrentUseItem *)value;
- (void)replaceUseItemAtIndexes:(NSIndexSet *)indexes withUseItem:(NSArray<CDCurrentUseItem *> *)values;
- (void)addUseItemObject:(CDCurrentUseItem *)value;
- (void)removeUseItemObject:(CDCurrentUseItem *)value;
- (void)addUseItem:(NSOrderedSet<CDCurrentUseItem *> *)values;
- (void)removeUseItem:(NSOrderedSet<CDCurrentUseItem *> *)values;

@end

NS_ASSUME_NONNULL_END
