//
//  CDMemberVisit+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/5/3.
//
//

#import "CDMemberVisit+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDMemberVisit (CoreDataProperties)

+ (NSFetchRequest<CDMemberVisit *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *advisory_id;
@property (nullable, nonatomic, copy) NSString *advisory_name;
@property (nullable, nonatomic, copy) NSString *category;
@property (nullable, nonatomic, copy) NSString *create_date;
@property (nullable, nonatomic, copy) NSNumber *customer_id;
@property (nullable, nonatomic, copy) NSString *customer_name;
@property (nullable, nonatomic, copy) NSString *day;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nameFirstLetter;
@property (nullable, nonatomic, copy) NSString *nameLetter;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSNumber *operate_id;
@property (nullable, nonatomic, copy) NSString *operate_name;
@property (nullable, nonatomic, copy) NSString *plant_visit_date;
@property (nullable, nonatomic, copy) NSNumber *plant_visit_user_id;
@property (nullable, nonatomic, copy) NSString *plant_visit_user_name;
@property (nullable, nonatomic, copy) NSNumber *sortIndex;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSNumber *visit_id;
@property (nullable, nonatomic, copy) NSNumber *visit_user_id;
@property (nullable, nonatomic, copy) NSString *visit_user_name;
@property (nullable, nonatomic, copy) NSString *product_names;
@property (nullable, nonatomic, copy) NSString *visit_date;
@property (nullable, nonatomic, retain) NSOrderedSet<CDYimeiImage *> *photos;

@end

@interface CDMemberVisit (CoreDataGeneratedAccessors)

- (void)insertObject:(CDYimeiImage *)value inPhotosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPhotosAtIndex:(NSUInteger)idx;
- (void)insertPhotos:(NSArray<CDYimeiImage *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePhotosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPhotosAtIndex:(NSUInteger)idx withObject:(CDYimeiImage *)value;
- (void)replacePhotosAtIndexes:(NSIndexSet *)indexes withPhotos:(NSArray<CDYimeiImage *> *)values;
- (void)addPhotosObject:(CDYimeiImage *)value;
- (void)removePhotosObject:(CDYimeiImage *)value;
- (void)addPhotos:(NSOrderedSet<CDYimeiImage *> *)values;
- (void)removePhotos:(NSOrderedSet<CDYimeiImage *> *)values;

@end

NS_ASSUME_NONNULL_END
