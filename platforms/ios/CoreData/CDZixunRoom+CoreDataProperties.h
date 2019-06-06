//
//  CDZixunRoom+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/6/23.
//
//

#import "CDZixunRoom+CoreDataClass.h"
@class CDZixunRoomPerson;

NS_ASSUME_NONNULL_BEGIN

@interface CDZixunRoom (CoreDataProperties)

+ (NSFetchRequest<CDZixunRoom *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *is_recycle;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *room_id;
@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *wait_message;
@property (nullable, nonatomic, copy) NSNumber *designers_id;
@property (nullable, nonatomic, copy) NSNumber *director_employee_id;
@property (nullable, nonatomic, copy) NSNumber *line_id;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *customer_state;
@property (nullable, nonatomic, copy) NSString *designers_name;
@property (nullable, nonatomic, copy) NSString *director_employee_name;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *member_type;
@property (nullable, nonatomic, copy) NSString *start_date;
@property (nullable, nonatomic, copy) NSString *state1;
@property (nullable, nonatomic, retain) NSOrderedSet<CDZixunRoomPerson *> *person;

@end

@interface CDZixunRoom (CoreDataGeneratedAccessors)

- (void)insertObject:(CDZixunRoomPerson *)value inPersonAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPersonAtIndex:(NSUInteger)idx;
- (void)insertPerson:(NSArray<CDZixunRoomPerson *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePersonAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPersonAtIndex:(NSUInteger)idx withObject:(CDZixunRoomPerson *)value;
- (void)replacePersonAtIndexes:(NSIndexSet *)indexes withPerson:(NSArray<CDZixunRoomPerson *> *)values;
- (void)addPersonObject:(CDZixunRoomPerson *)value;
- (void)removePersonObject:(CDZixunRoomPerson *)value;
- (void)addPerson:(NSOrderedSet<CDZixunRoomPerson *> *)values;
- (void)removePerson:(NSOrderedSet<CDZixunRoomPerson *> *)values;

@end

NS_ASSUME_NONNULL_END
