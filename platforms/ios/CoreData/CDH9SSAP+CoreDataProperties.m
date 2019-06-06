//
//  CDH9SSAP+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/8/7.
//
//

#import "CDH9SSAP+CoreDataProperties.h"

@implementation CDH9SSAP (CoreDataProperties)

+ (NSFetchRequest<CDH9SSAP *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDH9SSAP"];
}

@dynamic sort_index;
@dynamic year_month;
@dynamic day;
@dynamic count;
@dynamic event;

@end
