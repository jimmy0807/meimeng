//
//  CDHZixun+CoreDataProperties.h
//  meim
//
//  Created by bonn on 2017/4/27.
//
//

#import "CDHZixun+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDHZixun (CoreDataProperties)

+ (NSFetchRequest<CDHZixun *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *advice;
@property (nullable, nonatomic, copy) NSString *advisory_product_names;
@property (nullable, nonatomic, copy) NSNumber *cagegory_id;
@property (nullable, nonatomic, copy) NSString *category_name;
@property (nullable, nonatomic, copy) NSString *condition;
@property (nullable, nonatomic, copy) NSNumber *customer_id;
@property (nullable, nonatomic, copy) NSString *customer_name;
@property (nullable, nonatomic, copy) NSNumber *designers_id;
@property (nullable, nonatomic, copy) NSString *designers_name;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSNumber *employee_id;
@property (nullable, nonatomic, copy) NSString *employee_name;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nameFirstLetter;
@property (nullable, nonatomic, copy) NSString *nameLetter;
@property (nullable, nonatomic, copy) NSString *nameSingleLetter;
@property (nullable, nonatomic, copy) NSNumber *storeID;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSNumber *zixun_id;
@property (nullable, nonatomic, copy) NSString *mobile;
@property (nullable, nonatomic, copy) NSString *gender;

@end

NS_ASSUME_NONNULL_END
