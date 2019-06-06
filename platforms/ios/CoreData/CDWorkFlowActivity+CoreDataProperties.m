//
//  CDWorkFlowActivity+CoreDataProperties.m
//  ds
//
//  Created by jimmy on 16/10/28.
//
//

#import "CDWorkFlowActivity+CoreDataProperties.h"

@implementation CDWorkFlowActivity (CoreDataProperties)

+ (NSFetchRequest<CDWorkFlowActivity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDWorkFlowActivity"];
}

@dynamic name;
@dynamic parentID;
@dynamic isStart;
@dynamic isEnd;
@dynamic role;
@dynamic workID;

@end
