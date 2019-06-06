//
//  CDMemberSource+CoreDataProperties.m
//  ds
//
//  Created by jimmy on 16/10/13.
//
//

#import "CDMemberSource+CoreDataProperties.h"

@implementation CDMemberSource (CoreDataProperties)

+ (NSFetchRequest<CDMemberSource *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDMemberSource"];
}

@dynamic name;
@dynamic source_id;

@end
