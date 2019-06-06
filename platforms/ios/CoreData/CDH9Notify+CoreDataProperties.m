//
//  CDH9Notify+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/8/4.
//
//

#import "CDH9Notify+CoreDataProperties.h"

@implementation CDH9Notify (CoreDataProperties)

+ (NSFetchRequest<CDH9Notify *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDH9Notify"];
}

@dynamic sort_index;
@dynamic name;
@dynamic user_id;
@dynamic state;
@dynamic state_name;
@dynamic planning_time;
@dynamic member_id;
@dynamic doctor_id;
@dynamic type;
@dynamic title;
@dynamic notify_id;

@end
