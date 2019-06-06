//
//  CDCommissionRule+CoreDataProperties.h
//  ds
//
//  Created by lining on 16/10/12.
//
//

#import "CDCommissionRule+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDCommissionRule (CoreDataProperties)

+ (NSFetchRequest<CDCommissionRule *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *rule_name;
@property (nullable, nonatomic, copy) NSNumber *rule_id;
@property (nullable, nonatomic, copy) NSString *sale_price_sel;
@property (nullable, nonatomic, copy) NSNumber *shop_id;
@property (nullable, nonatomic, copy) NSString *shop_name;
@property (nullable, nonatomic, copy) NSNumber *company_id;
@property (nullable, nonatomic, copy) NSString *company_name;
@property (nullable, nonatomic, retain) NSOrderedSet<CDStaff *> *staffs;

@end

@interface CDCommissionRule (CoreDataGeneratedAccessors)

- (void)insertObject:(CDStaff *)value inStaffsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromStaffsAtIndex:(NSUInteger)idx;
- (void)insertStaffs:(NSArray<CDStaff *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeStaffsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInStaffsAtIndex:(NSUInteger)idx withObject:(CDStaff *)value;
- (void)replaceStaffsAtIndexes:(NSIndexSet *)indexes withStaffs:(NSArray<CDStaff *> *)values;
- (void)addStaffsObject:(CDStaff *)value;
- (void)removeStaffsObject:(CDStaff *)value;
- (void)addStaffs:(NSOrderedSet<CDStaff *> *)values;
- (void)removeStaffs:(NSOrderedSet<CDStaff *> *)values;

@end

NS_ASSUME_NONNULL_END
