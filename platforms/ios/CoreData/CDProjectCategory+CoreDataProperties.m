//
//  CDProjectCategory+CoreDataProperties.m
//  ds
//
//  Created by lining on 2016/10/24.
//
//

#import "CDProjectCategory+CoreDataProperties.h"

@implementation CDProjectCategory (CoreDataProperties)

+ (NSFetchRequest<CDProjectCategory *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDProjectCategory"];
}

@dynamic categoryID;
@dynamic categoryName;
@dynamic createDate;
@dynamic itemCount;
@dynamic lastUpdate;
@dynamic otherCount;
@dynamic parentID;
@dynamic parentName;
@dynamic sequence;
@dynamic serialID;
@dynamic departments_id;
@dynamic departments_name;
@dynamic items;
@dynamic parent;
@dynamic subCategory;
@dynamic templates;

@end
