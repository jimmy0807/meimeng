//
//  CDZixunRoomPerson+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/6/14.
//
//

#import "CDZixunRoomPerson+CoreDataProperties.h"

@implementation CDZixunRoomPerson (CoreDataProperties)

+ (NSFetchRequest<CDZixunRoomPerson *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDZixunRoomPerson"];
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
