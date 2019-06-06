//
//  CDHShoushuLine+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/8/23.
//
//

#import "CDHShoushuLine+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDHShoushuLine (CoreDataProperties)

+ (NSFetchRequest<CDHShoushuLine *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *create_date;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSNumber *has_confirm;
@property (nullable, nonatomic, copy) NSNumber *hospitalized_id;
@property (nullable, nonatomic, copy) NSString *hospitalized_name;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSNumber *line_id;
@property (nullable, nonatomic, copy) NSNumber *medical_operate_id;
@property (nullable, nonatomic, copy) NSString *medical_operate_name;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSString *operate_date;
@property (nullable, nonatomic, copy) NSString *operate_tags;
@property (nullable, nonatomic, copy) NSNumber *product_id;
@property (nullable, nonatomic, copy) NSString *product_name;
@property (nullable, nonatomic, copy) NSString *review_date;
@property (nullable, nonatomic, copy) NSNumber *review_days;
@property (nullable, nonatomic, copy) NSNumber *sortIndex;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *write_name;
@property (nullable, nonatomic, copy) NSNumber *write_uid;
@property (nullable, nonatomic, copy) NSString *operate_tags_names;
@property (nullable, nonatomic, retain) CDHShoushu *shoushu;

@end

NS_ASSUME_NONNULL_END
