//
//  CDProjectItem+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2018/4/23.
//
//

#import "CDProjectItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDProjectItem (CoreDataProperties)

+ (NSFetchRequest<CDProjectItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *barcode;
@property (nullable, nonatomic, copy) NSNumber *bornCategory;
@property (nullable, nonatomic, copy) NSNumber *canBook;
@property (nullable, nonatomic, copy) NSNumber *canPurchase;
@property (nullable, nonatomic, copy) NSNumber *canSale;
@property (nullable, nonatomic, copy) NSNumber *cardDeduct;
@property (nullable, nonatomic, copy) NSNumber *categoryID;
@property (nullable, nonatomic, copy) NSString *categoryName;
@property (nullable, nonatomic, copy) NSNumber *companyID;
@property (nullable, nonatomic, copy) NSString *companyName;
@property (nullable, nonatomic, copy) NSString *createDate;
@property (nullable, nonatomic, copy) NSString *defaultCode;
@property (nullable, nonatomic, copy) NSNumber *departments_id;
@property (nullable, nonatomic, copy) NSString *description_notice;
@property (nullable, nonatomic, copy) NSNumber *doFixedPercent;
@property (nullable, nonatomic, copy) NSNumber *doPercent;
@property (nullable, nonatomic, copy) NSNumber *extraPrice;
@property (nullable, nonatomic, copy) NSNumber *fixedCardDeduct;
@property (nullable, nonatomic, copy) NSNumber *forecastAmount;
@property (nullable, nonatomic, copy) NSNumber *giftFixedCommission;
@property (nullable, nonatomic, copy) NSNumber *giftFixedPercent;
@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, copy) NSString *imageNameMedium;
@property (nullable, nonatomic, copy) NSString *imageNamePad;
@property (nullable, nonatomic, copy) NSString *imageNameSmall;
@property (nullable, nonatomic, copy) NSString *imageNameVariant;
@property (nullable, nonatomic, copy) NSString *imageSmallUrl;
@property (nullable, nonatomic, copy) NSString *imageUrl;
@property (nullable, nonatomic, copy) NSNumber *inAddition;
@property (nullable, nonatomic, copy) NSNumber *inHandAmount;
@property (nullable, nonatomic, copy) NSString *introduction;
@property (nullable, nonatomic, copy) NSNumber *isActive;
@property (nullable, nonatomic, copy) NSNumber *isGiftHasCommission;
@property (nullable, nonatomic, copy) NSNumber *itemID;
@property (nullable, nonatomic, copy) NSString *itemName;
@property (nullable, nonatomic, copy) NSString *itemNameFirstLetter;
@property (nullable, nonatomic, copy) NSString *itemNameLetter;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSNumber *maxPrice;
@property (nullable, nonatomic, copy) NSNumber *minPrice;
@property (nullable, nonatomic, copy) NSString *mix_image_url;
@property (nullable, nonatomic, copy) NSNumber *notCardDeduct;
@property (nullable, nonatomic, copy) NSNumber *notFixedCardDeduct;
@property (nullable, nonatomic, copy) NSNumber *package_count;
@property (nullable, nonatomic, copy) NSNumber *parent_id;
@property (nullable, nonatomic, copy) NSString *product_group_image_url;
@property (nullable, nonatomic, copy) NSNumber *project_group_id;
@property (nullable, nonatomic, copy) NSString *project_group_name;
@property (nullable, nonatomic, copy) NSNumber *sequence;
@property (nullable, nonatomic, copy) NSNumber *stanardPrice;
@property (nullable, nonatomic, copy) NSNumber *subItemCount;
@property (nullable, nonatomic, copy) NSNumber *templateID;
@property (nullable, nonatomic, copy) NSString *templateName;
@property (nullable, nonatomic, copy) NSNumber *time;
@property (nullable, nonatomic, copy) NSNumber *totalPrice;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSNumber *uomID;
@property (nullable, nonatomic, copy) NSString *uomName;
@property (nullable, nonatomic, retain) NSOrderedSet<CDProjectAttributeValue *> *attributeValues;
@property (nullable, nonatomic, retain) CDProjectCategory *category;
@property (nullable, nonatomic, retain) NSSet<CDCouponCardProduct *> *couponCardProject;
@property (nullable, nonatomic, retain) NSSet<CDMemberCardProject *> *memberCardProject;
@property (nullable, nonatomic, retain) CDPurchaseOrderMoveItem *moveItem;
@property (nullable, nonatomic, retain) NSSet<CDPurchaseOrderLine *> *orderline;
@property (nullable, nonatomic, retain) NSSet<CDPanDianItem *> *panDianItem;
@property (nullable, nonatomic, retain) NSSet<CDProjectItem *> *parentItems;
@property (nullable, nonatomic, retain) NSSet<CDPosBaseProduct *> *posProducts;
@property (nullable, nonatomic, retain) CDProjectTemplate *projectTemplate;
@property (nullable, nonatomic, retain) NSSet<CDProjectRelated *> *sameRelateds;
@property (nullable, nonatomic, retain) NSSet<CDProjectItem *> *subItems;
@property (nullable, nonatomic, retain) NSSet<CDProjectRelated *> *subRelateds;
@property (nullable, nonatomic, retain) NSOrderedSet<CDCurrentUseItem *> *useItem;
@property (nullable, nonatomic, retain) CDProjectConsumable *consumeItems;
@property (nullable, nonatomic, retain) CDProjectCheck *checkItem;
@property (nullable, nonatomic, copy) NSNumber *is_check_service;
@property (nullable, nonatomic, copy) NSNumber *is_consumables;
@property (nullable, nonatomic, copy) NSNumber *is_prescription;
@property (nullable, nonatomic, copy) NSString *check_ids;
@property (nullable, nonatomic, copy) NSString *consumables_ids;

@end

@interface CDProjectItem (CoreDataGeneratedAccessors)

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

- (void)addCouponCardProjectObject:(CDCouponCardProduct *)value;
- (void)removeCouponCardProjectObject:(CDCouponCardProduct *)value;
- (void)addCouponCardProject:(NSSet<CDCouponCardProduct *> *)values;
- (void)removeCouponCardProject:(NSSet<CDCouponCardProduct *> *)values;

- (void)addMemberCardProjectObject:(CDMemberCardProject *)value;
- (void)removeMemberCardProjectObject:(CDMemberCardProject *)value;
- (void)addMemberCardProject:(NSSet<CDMemberCardProject *> *)values;
- (void)removeMemberCardProject:(NSSet<CDMemberCardProject *> *)values;

- (void)addOrderlineObject:(CDPurchaseOrderLine *)value;
- (void)removeOrderlineObject:(CDPurchaseOrderLine *)value;
- (void)addOrderline:(NSSet<CDPurchaseOrderLine *> *)values;
- (void)removeOrderline:(NSSet<CDPurchaseOrderLine *> *)values;

- (void)addPanDianItemObject:(CDPanDianItem *)value;
- (void)removePanDianItemObject:(CDPanDianItem *)value;
- (void)addPanDianItem:(NSSet<CDPanDianItem *> *)values;
- (void)removePanDianItem:(NSSet<CDPanDianItem *> *)values;

- (void)addParentItemsObject:(CDProjectItem *)value;
- (void)removeParentItemsObject:(CDProjectItem *)value;
- (void)addParentItems:(NSSet<CDProjectItem *> *)values;
- (void)removeParentItems:(NSSet<CDProjectItem *> *)values;

- (void)addPosProductsObject:(CDPosBaseProduct *)value;
- (void)removePosProductsObject:(CDPosBaseProduct *)value;
- (void)addPosProducts:(NSSet<CDPosBaseProduct *> *)values;
- (void)removePosProducts:(NSSet<CDPosBaseProduct *> *)values;

- (void)addSameRelatedsObject:(CDProjectRelated *)value;
- (void)removeSameRelatedsObject:(CDProjectRelated *)value;
- (void)addSameRelateds:(NSSet<CDProjectRelated *> *)values;
- (void)removeSameRelateds:(NSSet<CDProjectRelated *> *)values;

- (void)addSubItemsObject:(CDProjectItem *)value;
- (void)removeSubItemsObject:(CDProjectItem *)value;
- (void)addSubItems:(NSSet<CDProjectItem *> *)values;
- (void)removeSubItems:(NSSet<CDProjectItem *> *)values;

- (void)addSubRelatedsObject:(CDProjectRelated *)value;
- (void)removeSubRelatedsObject:(CDProjectRelated *)value;
- (void)addSubRelateds:(NSSet<CDProjectRelated *> *)values;
- (void)removeSubRelateds:(NSSet<CDProjectRelated *> *)values;

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
