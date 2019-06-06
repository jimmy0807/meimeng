//
//  CDOperateActivity+CoreDataProperties.m
//  ds
//
//  Created by jimmy on 16/11/10.
//
//

#import "CDOperateActivity+CoreDataProperties.h"

@implementation CDOperateActivity (CoreDataProperties)

+ (NSFetchRequest<CDOperateActivity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDOperateActivity"];
}

@dynamic activityID;
@dynamic lineID;
@dynamic name;
@dynamic role;
@dynamic state;
@dynamic time;
@dynamic userName;
@dynamic operate;

@end
