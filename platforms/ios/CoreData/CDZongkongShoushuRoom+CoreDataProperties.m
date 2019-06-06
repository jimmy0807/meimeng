//
//  CDZongkongShoushuRoom+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/7/11.
//
//

#import "CDZongkongShoushuRoom+CoreDataProperties.h"

@implementation CDZongkongShoushuRoom (CoreDataProperties)

+ (NSFetchRequest<CDZongkongShoushuRoom *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDZongkongShoushuRoom"];
}

@dynamic doing_count;
@dynamic name;
@dynamic room_id;
@dynamic sort_index;
@dynamic state;
@dynamic state_name;
@dynamic wait_message;
@dynamic waiting_count;
@dynamic image_url;
@dynamic shejishi;
@dynamic doctor_name;
@dynamic member_name;
@dynamic start_date;
@dynamic type;
@dynamic current_customers;
@dynamic paidui_customers;

@end
