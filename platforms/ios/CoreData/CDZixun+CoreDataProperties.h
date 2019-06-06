//
//  CDZixun+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/7/5.
//
//

#import "CDZixun+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDZixun (CoreDataProperties)

+ (NSFetchRequest<CDZixun *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *advice;
@property (nullable, nonatomic, copy) NSString *advisory_end_date;
@property (nullable, nonatomic, copy) NSString *advisory_start_date;
@property (nullable, nonatomic, copy) NSString *age;
@property (nullable, nonatomic, copy) NSString *client_date;
@property (nullable, nonatomic, copy) NSString *condition;
@property (nullable, nonatomic, copy) NSString *create_date;
@property (nullable, nonatomic, copy) NSString *customer_state_name;
@property (nullable, nonatomic, copy) NSNumber *designer_id;
@property (nullable, nonatomic, copy) NSString *designer_name;
@property (nullable, nonatomic, copy) NSNumber *director_id;
@property (nullable, nonatomic, copy) NSString *director_name;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, copy) NSString *image_urls;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *member_level;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *member_type;
@property (nullable, nonatomic, copy) NSString *nameFirstLetter;
@property (nullable, nonatomic, copy) NSString *nameLetter;
@property (nullable, nonatomic, copy) NSString *no;
@property (nullable, nonatomic, copy) NSNumber *operate_id;
@property (nullable, nonatomic, copy) NSString *product_ids;
@property (nullable, nonatomic, copy) NSString *product_names;
@property (nullable, nonatomic, copy) NSString *select_product_ids;
@property (nullable, nonatomic, copy) NSString *select_product_names;
@property (nullable, nonatomic, copy) NSString *queue_no;
@property (nullable, nonatomic, copy) NSString *queue_no_name;
@property (nullable, nonatomic, copy) NSNumber *room_id;
@property (nullable, nonatomic, copy) NSString *room_name;
@property (nullable, nonatomic, copy) NSString *sex;
@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *state_name;
@property (nullable, nonatomic, copy) NSNumber *visit_id;
@property (nullable, nonatomic, copy) NSString *xingzuo;
@property (nullable, nonatomic, copy) NSString *xuexing;
@property (nullable, nonatomic, copy) NSNumber *zixun_id;
@property (nullable, nonatomic, copy) NSString *zixun_local_type;
@property (nullable, nonatomic, copy) NSString *mobile;
@property (nullable, nonatomic, retain) NSOrderedSet<CDYimeiImage *> *images;
@property (nullable, nonatomic, retain) NSOrderedSet<CDYimeiBuwei *> *yimei_buwei;

@end

@interface CDZixun (CoreDataGeneratedAccessors)

- (void)insertObject:(CDYimeiImage *)value inImagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromImagesAtIndex:(NSUInteger)idx;
- (void)insertImages:(NSArray<CDYimeiImage *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeImagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInImagesAtIndex:(NSUInteger)idx withObject:(CDYimeiImage *)value;
- (void)replaceImagesAtIndexes:(NSIndexSet *)indexes withImages:(NSArray<CDYimeiImage *> *)values;
- (void)addImagesObject:(CDYimeiImage *)value;
- (void)removeImagesObject:(CDYimeiImage *)value;
- (void)addImages:(NSOrderedSet<CDYimeiImage *> *)values;
- (void)removeImages:(NSOrderedSet<CDYimeiImage *> *)values;

- (void)insertObject:(CDYimeiBuwei *)value inYimei_buweiAtIndex:(NSUInteger)idx;
- (void)removeObjectFromYimei_buweiAtIndex:(NSUInteger)idx;
- (void)insertYimei_buwei:(NSArray<CDYimeiBuwei *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeYimei_buweiAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInYimei_buweiAtIndex:(NSUInteger)idx withObject:(CDYimeiBuwei *)value;
- (void)replaceYimei_buweiAtIndexes:(NSIndexSet *)indexes withYimei_buwei:(NSArray<CDYimeiBuwei *> *)values;
- (void)addYimei_buweiObject:(CDYimeiBuwei *)value;
- (void)removeYimei_buweiObject:(CDYimeiBuwei *)value;
- (void)addYimei_buwei:(NSOrderedSet<CDYimeiBuwei *> *)values;
- (void)removeYimei_buwei:(NSOrderedSet<CDYimeiBuwei *> *)values;

@end

NS_ASSUME_NONNULL_END
