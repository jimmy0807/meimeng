//
//  CDZixunRoom+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/6/23.
//
//

#import "CDZixunRoom+CoreDataProperties.h"

@implementation CDZixunRoom (CoreDataProperties)

+ (NSFetchRequest<CDZixunRoom *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDZixunRoom"];
}

@dynamic is_recycle;
@dynamic name;
@dynamic room_id;
@dynamic sort_index;
@dynamic state;
@dynamic wait_message;
@dynamic designers_id;
@dynamic director_employee_id;
@dynamic line_id;
@dynamic member_id;
@dynamic customer_state;
@dynamic designers_name;
@dynamic director_employee_name;
@dynamic image_url;
@dynamic member_name;
@dynamic member_type;
@dynamic start_date;
@dynamic state1;
@dynamic person;

@end
