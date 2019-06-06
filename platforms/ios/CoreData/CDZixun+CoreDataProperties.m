//
//  CDZixun+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/7/5.
//
//

#import "CDZixun+CoreDataProperties.h"

@implementation CDZixun (CoreDataProperties)

+ (NSFetchRequest<CDZixun *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDZixun"];
}

@dynamic advice;
@dynamic advisory_end_date;
@dynamic advisory_start_date;
@dynamic age;
@dynamic client_date;
@dynamic condition;
@dynamic create_date;
@dynamic customer_state_name;
@dynamic designer_id;
@dynamic designer_name;
@dynamic director_id;
@dynamic director_name;
@dynamic doctor_id;
@dynamic doctor_name;
@dynamic image_url;
@dynamic image_urls;
@dynamic member_id;
@dynamic member_level;
@dynamic member_name;
@dynamic member_type;
@dynamic nameFirstLetter;
@dynamic nameLetter;
@dynamic no;
@dynamic operate_id;
@dynamic product_ids;
@dynamic product_names;
@dynamic select_product_ids;
@dynamic select_product_names;
@dynamic queue_no;
@dynamic queue_no_name;
@dynamic room_id;
@dynamic room_name;
@dynamic sex;
@dynamic sort_index;
@dynamic state;
@dynamic state_name;
@dynamic visit_id;
@dynamic xingzuo;
@dynamic xuexing;
@dynamic zixun_id;
@dynamic zixun_local_type;
@dynamic mobile;
@dynamic images;
@dynamic yimei_buwei;

@end
