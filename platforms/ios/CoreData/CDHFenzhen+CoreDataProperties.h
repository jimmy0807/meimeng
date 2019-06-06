//
//  CDHFenzhen+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/4/17.
//
//

#import "CDHFenzhen+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDHFenzhen (CoreDataProperties)

+ (NSFetchRequest<CDHFenzhen *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *fenzhen_id;
@property (nullable, nonatomic, copy) NSNumber *advisory_id;
@property (nullable, nonatomic, copy) NSNumber *category_id;
@property (nullable, nonatomic, copy) NSString *category_name;
@property (nullable, nonatomic, copy) NSNumber *channel_id;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *create_date;
@property (nullable, nonatomic, copy) NSString *customer_category;
@property (nullable, nonatomic, copy) NSNumber *customer_id;
@property (nullable, nonatomic, copy) NSString *customer_name;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *receiver_id;
@property (nullable, nonatomic, copy) NSString *receiver_name;
@property (nullable, nonatomic, copy) NSNumber *reservation_id;
@property (nullable, nonatomic, copy) NSNumber *type_id;
@property (nullable, nonatomic, copy) NSString *type_name;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSString *advisory_name;

@end

NS_ASSUME_NONNULL_END
