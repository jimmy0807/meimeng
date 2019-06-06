//
//  CDZongkongShoushuRoom+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/7/11.
//
//

#import "CDZongkongShoushuRoom+CoreDataClass.h"
@class CDZongkongShoushuCustomer;

NS_ASSUME_NONNULL_BEGIN

@interface CDZongkongShoushuRoom (CoreDataProperties)

+ (NSFetchRequest<CDZongkongShoushuRoom *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *doing_count;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *room_id;
@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *state_name;
@property (nullable, nonatomic, copy) NSString *wait_message;
@property (nullable, nonatomic, copy) NSNumber *waiting_count;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, copy) NSString *shejishi;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *start_date;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, retain) NSOrderedSet<CDZongkongShoushuCustomer *> *current_customers;
@property (nullable, nonatomic, retain) NSOrderedSet<CDZongkongShoushuCustomer *> *paidui_customers;

@end

@interface CDZongkongShoushuRoom (CoreDataGeneratedAccessors)

- (void)insertObject:(CDZongkongShoushuCustomer *)value inCurrent_customersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCurrent_customersAtIndex:(NSUInteger)idx;
- (void)insertCurrent_customers:(NSArray<CDZongkongShoushuCustomer *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCurrent_customersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCurrent_customersAtIndex:(NSUInteger)idx withObject:(CDZongkongShoushuCustomer *)value;
- (void)replaceCurrent_customersAtIndexes:(NSIndexSet *)indexes withCurrent_customers:(NSArray<CDZongkongShoushuCustomer *> *)values;
- (void)addCurrent_customersObject:(CDZongkongShoushuCustomer *)value;
- (void)removeCurrent_customersObject:(CDZongkongShoushuCustomer *)value;
- (void)addCurrent_customers:(NSOrderedSet<CDZongkongShoushuCustomer *> *)values;
- (void)removeCurrent_customers:(NSOrderedSet<CDZongkongShoushuCustomer *> *)values;

- (void)insertObject:(CDZongkongShoushuCustomer *)value inPaidui_customersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPaidui_customersAtIndex:(NSUInteger)idx;
- (void)insertPaidui_customers:(NSArray<CDZongkongShoushuCustomer *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePaidui_customersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPaidui_customersAtIndex:(NSUInteger)idx withObject:(CDZongkongShoushuCustomer *)value;
- (void)replacePaidui_customersAtIndexes:(NSIndexSet *)indexes withPaidui_customers:(NSArray<CDZongkongShoushuCustomer *> *)values;
- (void)addPaidui_customersObject:(CDZongkongShoushuCustomer *)value;
- (void)removePaidui_customersObject:(CDZongkongShoushuCustomer *)value;
- (void)addPaidui_customers:(NSOrderedSet<CDZongkongShoushuCustomer *> *)values;
- (void)removePaidui_customers:(NSOrderedSet<CDZongkongShoushuCustomer *> *)values;

@end

NS_ASSUME_NONNULL_END
