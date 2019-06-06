//
//  CDBingfangRoom+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2018/4/27.
//
//

#import "CDBingfangRoom+CoreDataProperties.h"

@implementation CDBingfangRoom (CoreDataProperties)

+ (NSFetchRequest<CDBingfangRoom *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"CDBingfangRoom"];
}

@dynamic customer_state;
@dynamic designers_id;
@dynamic designers_name;
@dynamic director_employee_id;
@dynamic director_employee_name;
@dynamic image_url;
@dynamic is_recycle;
@dynamic line_id;
@dynamic hospitalized_id;
@dynamic member_id;
@dynamic member_name;
@dynamic member_type;
@dynamic name;
@dynamic room_id;
@dynamic sort_index;
@dynamic start_date;
@dynamic state;
@dynamic state1;
@dynamic wait_message;
@dynamic person;
@dynamic operate_id;
@dynamic ward_name;

@end
