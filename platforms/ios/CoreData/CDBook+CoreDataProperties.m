//
//  CDBook+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2017/12/28.
//
//

#import "CDBook+CoreDataProperties.h"

@implementation CDBook (CoreDataProperties)

+ (NSFetchRequest<CDBook *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDBook"];
}

@dynamic address;
@dynamic approve_date;
@dynamic approve_id;
@dynamic approve_mark;
@dynamic approve_name;
@dynamic aside_time;
@dynamic book_id;
@dynamic booker_name;
@dynamic columnIdx;
@dynamic company_id;
@dynamic company_name;
@dynamic consume_date;
@dynamic create_uid;
@dynamic designers_id;
@dynamic designers_name;
@dynamic designers_service_id;
@dynamic designers_service_name;
@dynamic director_employee_id;
@dynamic director_employee_name;
@dynamic doctor_id;
@dynamic doctor_name;
@dynamic email;
@dynamic employee_id;
@dynamic employee_name;
@dynamic end_date;
@dynamic gender;
@dynamic is_active;
@dynamic is_anesthetic;
@dynamic is_checked;
@dynamic is_partner;
@dynamic is_reservation_bill;
@dynamic is_visit;
@dynamic isUsed;
@dynamic lastUpdate;
@dynamic mark;
@dynamic member_id;
@dynamic member_name;
@dynamic member_type;
@dynamic name;
@dynamic operate_id;
@dynamic operate_name;
@dynamic orginColumnIdx;
@dynamic people_num;
@dynamic product_ids;
@dynamic product_name;
@dynamic recommend_member_phone;
@dynamic room_id;
@dynamic room_name;
@dynamic shop_id;
@dynamic shop_name;
@dynamic source;
@dynamic start_date;
@dynamic state;
@dynamic table_id;
@dynamic table_name;
@dynamic technician_id;
@dynamic technician_name;
@dynamic telephone;
@dynamic is_consult_finished;
@dynamic posOperate;
@dynamic posProduct;
@dynamic tableUse;
@dynamic useItem;

@end
