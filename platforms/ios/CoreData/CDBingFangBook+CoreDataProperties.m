//
//  CDBingFangBook+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2018/5/11.
//
//

#import "CDBingFangBook+CoreDataProperties.h"

@implementation CDBingFangBook (CoreDataProperties)

+ (NSFetchRequest<CDBingFangBook *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDBingFangBook"];
}

@dynamic advisory_state;
@dynamic book_id;
@dynamic consume_date;
@dynamic create_date;
@dynamic create_uid_name;
@dynamic designer_id;
@dynamic designer_name;
@dynamic director_id;
@dynamic director_name;
@dynamic image_url;
@dynamic member_id;
@dynamic member_type;
@dynamic name;
@dynamic nameFirstLetter;
@dynamic nameLetter;
@dynamic queue_no;
@dynamic queue_no_name;
@dynamic room_id;
@dynamic sort_index;
@dynamic start_date;
@dynamic state;
@dynamic doctor_name;
@dynamic doctor_id;
@dynamic nurse_name;
@dynamic nurse_id;
@dynamic nursing_level;
@dynamic doctors_note;
@dynamic operate_id;

@end
