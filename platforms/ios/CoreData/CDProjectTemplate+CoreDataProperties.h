//
//  CDProjectTemplate+CoreDataProperties.h
//  meim
//
//  Created by lining on 2017/1/17.
//
//

#import "CDProjectTemplate+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDProjectTemplate (CoreDataProperties)

+ (NSFetchRequest<CDProjectTemplate *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *available_in_pos;
@property (nullable, nonatomic, copy) NSNumber *available_in_weixin;
@property (nullable, nonatomic, copy) NSString *barcode;
@property (nullable, nonatomic, copy) NSNumber *book_ok;
@property (nullable, nonatomic, copy) NSNumber *bornCategory;
@property (nullable, nonatomic, copy) NSNumber *canBook;
@property (nullable, nonatomic, copy) NSNumber *canPurchase;
@property (nullable, nonatomic, copy) NSNumber *canSale;
@property (nullable, nonatomic, copy) NSNumber *category_id;
@property (nullable, nonatomic, copy) NSNumber *categoryID;
@property (nullable, nonatomic, copy) NSString *categoryName;
@property (nullable, nonatomic, copy) NSNumber *companyID;
@property (nullable, nonatomic, copy) NSString *companyName;
@property (nullable, nonatomic, copy) NSString *createDate;
@property (nullable, nonatomic, copy) NSString *default_code;
@property (nullable, nonatomic, copy) NSString *defaultCode;
@property (nullable, nonatomic, copy) NSNumber *exchange;
@property (nullable, nonatomic, copy) NSString *image;
@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, copy) NSString *imageNameMedium;
@property (nullable, nonatomic, copy) NSString *imageNamePad;
@property (nullable, nonatomic, copy) NSString *imageNameSmall;
@property (nullable, nonatomic, copy) NSString *imageNameVariant;
@property (nullable, nonatomic, copy) NSString *imageSmallUrl;
@property (nullable, nonatomic, copy) NSString *imageUrl;
@property (nullable, nonatomic, copy) NSString *introduction;
@property (nullable, nonatomic, copy) NSNumber *is_main_product;
@property (nullable, nonatomic, copy) NSNumber *is_recommend;
@property (nullable, nonatomic, copy) NSNumber *is_show_weika;
@property (nullable, nonatomic, copy) NSNumber *is_spread;
@property (nullable, nonatomic, copy) NSNumber *isActive;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSNumber *list_price;
@property (nullable, nonatomic, copy) NSNumber *listPrice;
@property (nullable, nonatomic, copy) NSNumber *minPrice;
@property (nullable, nonatomic, copy) NSNumber *pos_categ_id;
@property (nullable, nonatomic, copy) NSNumber *purchase_ok;
@property (nullable, nonatomic, copy) NSNumber *qty_available;
@property (nullable, nonatomic, copy) NSNumber *sale_ok;
@property (nullable, nonatomic, copy) NSNumber *sequence;
@property (nullable, nonatomic, copy) NSNumber *standard_price;
@property (nullable, nonatomic, copy) NSNumber *templateID;
@property (nullable, nonatomic, copy) NSString *templateName;
@property (nullable, nonatomic, copy) NSString *templateNameFirstLetter;
@property (nullable, nonatomic, copy) NSString *templateNameLetter;
@property (nullable, nonatomic, copy) NSNumber *time;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSNumber *uomID;
@property (nullable, nonatomic, copy) NSString *uomName;
@property (nullable, nonatomic, copy) NSNumber *virtual_available;
@property (nullable, nonatomic, copy) NSNumber *memberPrice;
@property (nullable, nonatomic, retain) NSOrderedSet<CDProjectAttributeLine *> *attributeLines;
@property (nullable, nonatomic, retain) CDProjectCategory *category;
@property (nullable, nonatomic, retain) NSOrderedSet<CDProjectConsumable *> *consumables;
@property (nullable, nonatomic, retain) NSOrderedSet<CDProjectItem *> *projectItems;

@end

@interface CDProjectTemplate (CoreDataGeneratedAccessors)

- (void)insertObject:(CDProjectAttributeLine *)value inAttributeLinesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAttributeLinesAtIndex:(NSUInteger)idx;
- (void)insertAttributeLines:(NSArray<CDProjectAttributeLine *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAttributeLinesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAttributeLinesAtIndex:(NSUInteger)idx withObject:(CDProjectAttributeLine *)value;
- (void)replaceAttributeLinesAtIndexes:(NSIndexSet *)indexes withAttributeLines:(NSArray<CDProjectAttributeLine *> *)values;
- (void)addAttributeLinesObject:(CDProjectAttributeLine *)value;
- (void)removeAttributeLinesObject:(CDProjectAttributeLine *)value;
- (void)addAttributeLines:(NSOrderedSet<CDProjectAttributeLine *> *)values;
- (void)removeAttributeLines:(NSOrderedSet<CDProjectAttributeLine *> *)values;

- (void)insertObject:(CDProjectConsumable *)value inConsumablesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromConsumablesAtIndex:(NSUInteger)idx;
- (void)insertConsumables:(NSArray<CDProjectConsumable *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeConsumablesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInConsumablesAtIndex:(NSUInteger)idx withObject:(CDProjectConsumable *)value;
- (void)replaceConsumablesAtIndexes:(NSIndexSet *)indexes withConsumables:(NSArray<CDProjectConsumable *> *)values;
- (void)addConsumablesObject:(CDProjectConsumable *)value;
- (void)removeConsumablesObject:(CDProjectConsumable *)value;
- (void)addConsumables:(NSOrderedSet<CDProjectConsumable *> *)values;
- (void)removeConsumables:(NSOrderedSet<CDProjectConsumable *> *)values;

- (void)insertObject:(CDProjectItem *)value inProjectItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromProjectItemsAtIndex:(NSUInteger)idx;
- (void)insertProjectItems:(NSArray<CDProjectItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeProjectItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInProjectItemsAtIndex:(NSUInteger)idx withObject:(CDProjectItem *)value;
- (void)replaceProjectItemsAtIndexes:(NSIndexSet *)indexes withProjectItems:(NSArray<CDProjectItem *> *)values;
- (void)addProjectItemsObject:(CDProjectItem *)value;
- (void)removeProjectItemsObject:(CDProjectItem *)value;
- (void)addProjectItems:(NSOrderedSet<CDProjectItem *> *)values;
- (void)removeProjectItems:(NSOrderedSet<CDProjectItem *> *)values;

@end

NS_ASSUME_NONNULL_END
