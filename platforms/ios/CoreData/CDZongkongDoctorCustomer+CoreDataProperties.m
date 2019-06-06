//
//  CDZongkongDoctorCustomer+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2017/10/10.
//
//

#import "CDZongkongDoctorCustomer+CoreDataProperties.h"

@implementation CDZongkongDoctorCustomer (CoreDataProperties)

+ (NSFetchRequest<CDZongkongDoctorCustomer *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDZongkongDoctorCustomer"];
}

@dynamic designers_name;
@dynamic director_employee_name;
@dynamic doctor_name;
@dynamic member_image_url;
@dynamic member_name;
@dynamic queue_no;
@dynamic remark;
@dynamic start_date;
@dynamic state;
@dynamic current_doctor;
@dynamic paidui_doctor;

@end
