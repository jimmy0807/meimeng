//
//  CDBingfangRoomPerson+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2018/4/27.
//
//

#import "CDBingfangRoomPerson+CoreDataProperties.h"

@implementation CDBingfangRoomPerson (CoreDataProperties)

+ (NSFetchRequest<CDBingfangRoomPerson *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"CDBingfangRoomPerson"];
}

@dynamic customer_state;
@dynamic designers_id;
@dynamic designers_name;
@dynamic director_employee_id;
@dynamic director_employee_name;
@dynamic image_url;
@dynamic line_id;
@dynamic member_id;
@dynamic member_name;
@dynamic member_type;
@dynamic start_date;
@dynamic state;
@dynamic room;

@end
