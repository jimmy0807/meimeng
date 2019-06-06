//
//  CDHHuizhenCategory+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/7/21.
//
//

#import "CDHHuizhenCategory+CoreDataProperties.h"

@implementation CDHHuizhenCategory (CoreDataProperties)

+ (NSFetchRequest<CDHHuizhenCategory *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDHHuizhenCategory"];
}

@dynamic cateogry_id;
@dynamic name;
@dynamic parent_id;
@dynamic sort_index;
@dynamic image_url;
@dynamic childs;
@dynamic parent;

@end
