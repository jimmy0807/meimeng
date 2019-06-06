//
//  CDZongkongDoctorPerson+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2017/10/10.
//
//

#import "CDZongkongDoctorPerson+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDZongkongDoctorPerson (CoreDataProperties)

+ (NSFetchRequest<CDZongkongDoctorPerson *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *designer_name;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSNumber *doing_cnt;
@property (nullable, nonatomic, copy) NSNumber *done_cnt;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *start_date;
@property (nullable, nonatomic, copy) NSString *state_name;
@property (nullable, nonatomic, copy) NSNumber *waiting_cnt;
@property (nullable, nonatomic, copy) NSString *waiting_name;
@property (nullable, nonatomic, retain) NSOrderedSet<CDZongkongDoctorCustomer *> *current_customers;
@property (nullable, nonatomic, retain) NSOrderedSet<CDZongkongDoctorCustomer *> *paidui_customers;

@end

@interface CDZongkongDoctorPerson (CoreDataGeneratedAccessors)

- (void)insertObject:(CDZongkongDoctorCustomer *)value inCurrent_customersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCurrent_customersAtIndex:(NSUInteger)idx;
- (void)insertCurrent_customers:(NSArray<CDZongkongDoctorCustomer *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCurrent_customersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCurrent_customersAtIndex:(NSUInteger)idx withObject:(CDZongkongDoctorCustomer *)value;
- (void)replaceCurrent_customersAtIndexes:(NSIndexSet *)indexes withCurrent_customers:(NSArray<CDZongkongDoctorCustomer *> *)values;
- (void)addCurrent_customersObject:(CDZongkongDoctorCustomer *)value;
- (void)removeCurrent_customersObject:(CDZongkongDoctorCustomer *)value;
- (void)addCurrent_customers:(NSOrderedSet<CDZongkongDoctorCustomer *> *)values;
- (void)removeCurrent_customers:(NSOrderedSet<CDZongkongDoctorCustomer *> *)values;

- (void)insertObject:(CDZongkongDoctorCustomer *)value inPaidui_customersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPaidui_customersAtIndex:(NSUInteger)idx;
- (void)insertPaidui_customers:(NSArray<CDZongkongDoctorCustomer *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePaidui_customersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPaidui_customersAtIndex:(NSUInteger)idx withObject:(CDZongkongDoctorCustomer *)value;
- (void)replacePaidui_customersAtIndexes:(NSIndexSet *)indexes withPaidui_customers:(NSArray<CDZongkongDoctorCustomer *> *)values;
- (void)addPaidui_customersObject:(CDZongkongDoctorCustomer *)value;
- (void)removePaidui_customersObject:(CDZongkongDoctorCustomer *)value;
- (void)addPaidui_customers:(NSOrderedSet<CDZongkongDoctorCustomer *> *)values;
- (void)removePaidui_customers:(NSOrderedSet<CDZongkongDoctorCustomer *> *)values;

@end

NS_ASSUME_NONNULL_END
