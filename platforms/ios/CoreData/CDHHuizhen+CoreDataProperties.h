//
//  CDHHuizhen+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/7/25.
//
//

#import "CDHHuizhen+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDHHuizhen (CoreDataProperties)

+ (NSFetchRequest<CDHHuizhen *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *create_date;
@property (nullable, nonatomic, copy) NSString *doctor_url;
@property (nullable, nonatomic, copy) NSNumber *doctors_id;
@property (nullable, nonatomic, copy) NSString *doctors_name;
@property (nullable, nonatomic, copy) NSString *doctors_note;
@property (nullable, nonatomic, copy) NSNumber *first_category_id;
@property (nullable, nonatomic, copy) NSString *first_category_name;
@property (nullable, nonatomic, copy) NSNumber *huizhen_id;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *reason;
@property (nullable, nonatomic, copy) NSString *second_category_ids;
@property (nullable, nonatomic, copy) NSString *second_category_name;
@property (nullable, nonatomic, copy) NSString *title_detail;
@property (nullable, nonatomic, copy) NSString *picUrls;
@property (nullable, nonatomic, copy) NSString *description_str;
@property (nullable, nonatomic, copy) NSString *source;
@property (nullable, nonatomic, retain) CDHBinglika *binglika;
@property (nullable, nonatomic, retain) NSOrderedSet<CDYimeiImage *> *photos;

@end

@interface CDHHuizhen (CoreDataGeneratedAccessors)

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
