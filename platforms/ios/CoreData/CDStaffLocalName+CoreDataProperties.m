//
//  CDStaffLocalName+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 17/2/15.
//
//

#import "CDStaffLocalName+CoreDataProperties.h"

@implementation CDStaffLocalName (CoreDataProperties)

+ (NSFetchRequest<CDStaffLocalName *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDStaffLocalName"];
}

@dynamic name;
@dynamic staffID;
@dynamic time;
@dynamic lastUpdate;

@end
