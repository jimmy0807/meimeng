//
//  CDZongkongShoushuCustomer+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/7/11.
//
//

#import "CDZongkongShoushuCustomer+CoreDataProperties.h"

@implementation CDZongkongShoushuCustomer (CoreDataProperties)

+ (NSFetchRequest<CDZongkongShoushuCustomer *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDZongkongShoushuCustomer"];
}

@dynamic designers_id;
@dynamic designers_name;
@dynamic director_employee_id;
@dynamic director_employee_id_name;
@dynamic doctor_id;
@dynamic doctor_name;
@dynamic id;
@dynamic image_url;
@dynamic member_type;
@dynamic name;
@dynamic product_name;
@dynamic start_date;
@dynamic start_date_time;
@dynamic state;
@dynamic time;
@dynamic remark;
@dynamic current_room;
@dynamic paidui_room;

@end
