//
//  CDBingfangRoom+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2018/4/27.
//
//

#import "CDBingfangRoom+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDBingfangRoom (CoreDataProperties)

+ (NSFetchRequest<CDBingfangRoom *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *customer_state;
@property (nullable, nonatomic, copy) NSNumber *designers_id;
@property (nullable, nonatomic, copy) NSString *designers_name;
@property (nullable, nonatomic, copy) NSNumber *director_employee_id;
@property (nullable, nonatomic, copy) NSString *director_employee_name;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, copy) NSNumber *is_recycle;
@property (nullable, nonatomic, copy) NSNumber *line_id;
@property (nullable, nonatomic, copy) NSNumber *hospitalized_id;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *member_type;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *room_id;
@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *start_date;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *state1;
@property (nullable, nonatomic, copy) NSString *wait_message;
@property (nullable, nonatomic, copy) NSNumber *operate_id;
@property (nullable, nonatomic, copy) NSString *ward_name;

@property (nullable, nonatomic, retain) NSOrderedSet<CDBingfangRoomPerson *> *person;

@end

@interface CDBingfangRoom (CoreDataGeneratedAccessors)

- (void)insertObject:(CDBingfangRoomPerson *)value inPersonAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPersonAtIndex:(NSUInteger)idx;
- (void)insertPerson:(NSArray<CDBingfangRoomPerson *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePersonAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPersonAtIndex:(NSUInteger)idx withObject:(CDBingfangRoomPerson *)value;
- (void)replacePersonAtIndexes:(NSIndexSet *)indexes withPerson:(NSArray<CDBingfangRoomPerson *> *)values;
- (void)addPersonObject:(CDBingfangRoomPerson *)value;
- (void)removePersonObject:(CDBingfangRoomPerson *)value;
- (void)addPerson:(NSOrderedSet<CDBingfangRoomPerson *> *)values;
- (void)removePerson:(NSOrderedSet<CDBingfangRoomPerson *> *)values;

@end

NS_ASSUME_NONNULL_END
