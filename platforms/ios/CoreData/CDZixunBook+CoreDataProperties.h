//
//  CDZixunBook+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/6/22.
//
//

#import "CDZixunBook+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDZixunBook (CoreDataProperties)

+ (NSFetchRequest<CDZixunBook *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *book_id;
@property (nullable, nonatomic, copy) NSString *consume_date;
@property (nullable, nonatomic, copy) NSString *create_date;
@property (nullable, nonatomic, copy) NSString *create_uid_name;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *member_type;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nameFirstLetter;
@property (nullable, nonatomic, copy) NSString *nameLetter;
@property (nullable, nonatomic, copy) NSString *queue_no;
@property (nullable, nonatomic, copy) NSString *queue_no_name;
@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *start_date;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSNumber *designer_id;
@property (nullable, nonatomic, copy) NSNumber *director_id;
@property (nullable, nonatomic, copy) NSString *designer_name;
@property (nullable, nonatomic, copy) NSString *director_name;
@property (nullable, nonatomic, copy) NSNumber *room_id;
@property (nullable, nonatomic, copy) NSString *advisory_state;

@end

NS_ASSUME_NONNULL_END
