//
//  CDHFenzhen+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/4/17.
//
//

#import "CDHFenzhen+CoreDataProperties.h"

@implementation CDHFenzhen (CoreDataProperties)

+ (NSFetchRequest<CDHFenzhen *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDHFenzhen"];
}

@dynamic fenzhen_id;
@dynamic advisory_id;
@dynamic category_id;
@dynamic category_name;
@dynamic channel_id;
@dynamic content;
@dynamic create_date;
@dynamic customer_category;
@dynamic customer_id;
@dynamic customer_name;
@dynamic name;
@dynamic receiver_id;
@dynamic receiver_name;
@dynamic reservation_id;
@dynamic type_id;
@dynamic type_name;
@dynamic lastUpdate;
@dynamic advisory_name;

@end
