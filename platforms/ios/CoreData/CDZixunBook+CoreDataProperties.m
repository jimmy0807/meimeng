//
//  CDZixunBook+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/6/22.
//
//

#import "CDZixunBook+CoreDataProperties.h"

@implementation CDZixunBook (CoreDataProperties)

+ (NSFetchRequest<CDZixunBook *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDZixunBook"];
}

@dynamic book_id;
@dynamic consume_date;
@dynamic create_date;
@dynamic create_uid_name;
@dynamic image_url;
@dynamic member_id;
@dynamic member_type;
@dynamic name;
@dynamic nameFirstLetter;
@dynamic nameLetter;
@dynamic queue_no;
@dynamic queue_no_name;
@dynamic sort_index;
@dynamic start_date;
@dynamic state;
@dynamic designer_id;
@dynamic director_id;
@dynamic designer_name;
@dynamic director_name;
@dynamic room_id;
@dynamic advisory_state;

@end
