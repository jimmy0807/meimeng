//
//  CDHGuadan+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/8/24.
//
//

#import "CDHGuadan+CoreDataProperties.h"

@implementation CDHGuadan (CoreDataProperties)

+ (NSFetchRequest<CDHGuadan *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDHGuadan"];
}

@dynamic card_id;
@dynamic departments_id;
@dynamic departments_name;
@dynamic designers_id;
@dynamic designers_name;
@dynamic director_employee_id;
@dynamic director_employee_name;
@dynamic doctor_id;
@dynamic doctor_name;
@dynamic employee_id;
@dynamic employee_name;
@dynamic guadan_id;
@dynamic member_id;
@dynamic member_name;
@dynamic nameFirstLetter;
@dynamic nameLetter;
@dynamic no;
@dynamic note;
@dynamic queue_no;
@dynamic remark;
@dynamic sort_index;
@dynamic state;
@dynamic display_note;
@dynamic card_items;
@dynamic items;

@end
