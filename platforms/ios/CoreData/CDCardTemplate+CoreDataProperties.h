//
//  CDCardTemplate+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/4/18.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDCardTemplate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDCardTemplate (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *buy_price;
@property (nullable, nonatomic, retain) NSNumber *card_type;
@property (nullable, nonatomic, retain) NSNumber *company_id;
@property (nullable, nonatomic, retain) NSString *company_name;
@property (nullable, nonatomic, retain) NSNumber *default_cut;
@property (nullable, nonatomic, retain) NSNumber *discount;
@property (nullable, nonatomic, retain) NSString *expire_date;
@property (nullable, nonatomic, retain) NSNumber *invail_days;
@property (nullable, nonatomic, retain) NSNumber *is_customize;
@property (nullable, nonatomic, retain) NSString *last_update;
@property (nullable, nonatomic, retain) NSString *long_description;
@property (nullable, nonatomic, retain) NSNumber *need_share;
@property (nullable, nonatomic, retain) NSNumber *shop_id;
@property (nullable, nonatomic, retain) NSString *shop_name;
@property (nullable, nonatomic, retain) NSString *short_description;
@property (nullable, nonatomic, retain) NSNumber *template_id;
@property (nullable, nonatomic, retain) NSString *template_name;
@property (nullable, nonatomic, retain) NSString *template_pic_name;
@property (nullable, nonatomic, retain) NSString *template_pic_url;
@property (nullable, nonatomic, retain) NSNumber *money;
@property (nullable, nonatomic, retain) NSOrderedSet<CDCardTemplateProduct *> *template_products;

@end

@interface CDCardTemplate (CoreDataGeneratedAccessors)

- (void)insertObject:(CDCardTemplateProduct *)value inTemplate_productsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTemplate_productsAtIndex:(NSUInteger)idx;
- (void)insertTemplate_products:(NSArray<CDCardTemplateProduct *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTemplate_productsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTemplate_productsAtIndex:(NSUInteger)idx withObject:(CDCardTemplateProduct *)value;
- (void)replaceTemplate_productsAtIndexes:(NSIndexSet *)indexes withTemplate_products:(NSArray<CDCardTemplateProduct *> *)values;
- (void)addTemplate_productsObject:(CDCardTemplateProduct *)value;
- (void)removeTemplate_productsObject:(CDCardTemplateProduct *)value;
- (void)addTemplate_products:(NSOrderedSet<CDCardTemplateProduct *> *)values;
- (void)removeTemplate_products:(NSOrderedSet<CDCardTemplateProduct *> *)values;

@end

NS_ASSUME_NONNULL_END
