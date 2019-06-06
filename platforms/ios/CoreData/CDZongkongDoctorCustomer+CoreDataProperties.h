//
//  CDZongkongDoctorCustomer+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2017/10/10.
//
//

#import "CDZongkongDoctorCustomer+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDZongkongDoctorCustomer (CoreDataProperties)

+ (NSFetchRequest<CDZongkongDoctorCustomer *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *designers_name;
@property (nullable, nonatomic, copy) NSString *director_employee_name;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSString *member_image_url;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *queue_no;
@property (nullable, nonatomic, copy) NSString *remark;
@property (nullable, nonatomic, copy) NSString *start_date;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, retain) CDZongkongDoctorPerson *current_doctor;
@property (nullable, nonatomic, retain) CDZongkongDoctorPerson *paidui_doctor;

@end

NS_ASSUME_NONNULL_END
