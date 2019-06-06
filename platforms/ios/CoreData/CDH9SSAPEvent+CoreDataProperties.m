//
//  CDH9SSAPEvent+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/8/14.
//
//

#import "CDH9SSAPEvent+CoreDataProperties.h"

@implementation CDH9SSAPEvent (CoreDataProperties)

+ (NSFetchRequest<CDH9SSAPEvent *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDH9SSAPEvent"];
}

@dynamic member_id;
@dynamic note;
@dynamic operate_id;
@dynamic operate_line_id;
@dynamic operate_time;
@dynamic product_id;
@dynamic product_name;
@dynamic sort_index;
@dynamic year_month_day;
@dynamic state;
@dynamic state_name;
@dynamic ssap;

@end
