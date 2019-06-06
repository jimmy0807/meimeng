//
//  CDH9ShoushuTag+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/8/22.
//
//

#import "CDH9ShoushuTag+CoreDataProperties.h"

@implementation CDH9ShoushuTag (CoreDataProperties)

+ (NSFetchRequest<CDH9ShoushuTag *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDH9ShoushuTag"];
}

@dynamic name;
@dynamic sort_index;
@dynamic tag_id;
@dynamic memberNameLetter;
@dynamic memberNameFirstLetter;

@end
