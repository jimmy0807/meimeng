//
//  CDPartner+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/5/4.
//
//

#import "CDPartner+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDPartner (CoreDataProperties)

+ (NSFetchRequest<CDPartner *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *business_employee_id;
@property (nullable, nonatomic, copy) NSString *business_employee_name;
@property (nullable, nonatomic, copy) NSNumber *designer_employee_id;
@property (nullable, nonatomic, copy) NSString *designer_employee_name;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nameFirstLetter;
@property (nullable, nonatomic, copy) NSString *nameLetter;
@property (nullable, nonatomic, copy) NSString *nameSingleLetter;
@property (nullable, nonatomic, copy) NSString *partner_category;
@property (nullable, nonatomic, copy) NSNumber *partner_id;
@property (nullable, nonatomic, copy) NSString *street;
@property (nullable, nonatomic, copy) NSString *sign_date;
@property (nullable, nonatomic, copy) NSString *mobile;
@property (nullable, nonatomic, copy) NSString *identification;
@property (nullable, nonatomic, retain) NSOrderedSet<CDYimeiImage *> *photos;

@end

@interface CDPartner (CoreDataGeneratedAccessors)

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
