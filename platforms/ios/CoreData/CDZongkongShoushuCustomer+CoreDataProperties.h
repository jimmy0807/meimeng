//
//  CDZongkongShoushuCustomer+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/7/11.
//
//

#import "CDZongkongShoushuCustomer+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDZongkongShoushuCustomer (CoreDataProperties)

+ (NSFetchRequest<CDZongkongShoushuCustomer *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *designers_id;
@property (nullable, nonatomic, copy) NSString *designers_name;
@property (nullable, nonatomic, copy) NSNumber *director_employee_id;
@property (nullable, nonatomic, copy) NSString *director_employee_id_name;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, copy) NSString *member_type;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *product_name;
@property (nullable, nonatomic, copy) NSString *start_date;
@property (nullable, nonatomic, copy) NSString *start_date_time;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *remark;
@property (nullable, nonatomic, retain) CDZongkongShoushuRoom *current_room;
@property (nullable, nonatomic, retain) CDZongkongShoushuRoom *paidui_room;

@end

NS_ASSUME_NONNULL_END
