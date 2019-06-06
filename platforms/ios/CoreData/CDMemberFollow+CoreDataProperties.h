//
//  CDMemberFollow+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/7/10.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberFollow.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberFollow (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *birth_date;
@property (nullable, nonatomic, retain) NSNumber *card_amount;
@property (nullable, nonatomic, retain) NSString *card_no;
@property (nullable, nonatomic, retain) NSNumber *cource_amount;
@property (nullable, nonatomic, retain) NSNumber *cpxs_amount;
@property (nullable, nonatomic, retain) NSNumber *first_week_come_count;
@property (nullable, nonatomic, retain) NSString *follow_date;
@property (nullable, nonatomic, retain) NSNumber *follow_id;
@property (nullable, nonatomic, retain) NSNumber *fourth_week_come_count;
@property (nullable, nonatomic, retain) NSNumber *hlxf_amount;
@property (nullable, nonatomic, retain) NSNumber *last_month_come_count;
@property (nullable, nonatomic, retain) NSNumber *last_month_come_day;
@property (nullable, nonatomic, retain) NSNumber *last_month_cpxs_amount;
@property (nullable, nonatomic, retain) NSNumber *member_id;
@property (nullable, nonatomic, retain) NSString *member_name;
@property (nullable, nonatomic, retain) NSNumber *month;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSString *other_product;
@property (nullable, nonatomic, retain) NSNumber *period_id;
@property (nullable, nonatomic, retain) NSString *period_name;
@property (nullable, nonatomic, retain) NSString *pricelists;
@property (nullable, nonatomic, retain) NSNumber *second_week_come_count;
@property (nullable, nonatomic, retain) NSNumber *shop_id;
@property (nullable, nonatomic, retain) NSString *shop_name;
@property (nullable, nonatomic, retain) NSNumber *third_week_come_count;
@property (nullable, nonatomic, retain) NSNumber *year;
@property (nullable, nonatomic, retain) NSNumber *yye_amount;
@property (nullable, nonatomic, retain) NSNumber *czje_amount;
@property (nullable, nonatomic, retain) NSNumber *last_yye_amount;
@property (nullable, nonatomic, retain) NSNumber *last_czje_amount;
@property (nullable, nonatomic, retain) NSNumber *last_hlxf_amount;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberFollowProduct *> *followProducts;

@end

@interface CDMemberFollow (CoreDataGeneratedAccessors)

- (void)insertObject:(CDMemberFollowProduct *)value inFollowProductsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFollowProductsAtIndex:(NSUInteger)idx;
- (void)insertFollowProducts:(NSArray<CDMemberFollowProduct *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFollowProductsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFollowProductsAtIndex:(NSUInteger)idx withObject:(CDMemberFollowProduct *)value;
- (void)replaceFollowProductsAtIndexes:(NSIndexSet *)indexes withFollowProducts:(NSArray<CDMemberFollowProduct *> *)values;
- (void)addFollowProductsObject:(CDMemberFollowProduct *)value;
- (void)removeFollowProductsObject:(CDMemberFollowProduct *)value;
- (void)addFollowProducts:(NSOrderedSet<CDMemberFollowProduct *> *)values;
- (void)removeFollowProducts:(NSOrderedSet<CDMemberFollowProduct *> *)values;

@end

NS_ASSUME_NONNULL_END
