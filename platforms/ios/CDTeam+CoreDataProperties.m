//
//  CDTeam+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2017/9/25.
//
//

#import "CDTeam+CoreDataProperties.h"

@implementation CDTeam (CoreDataProperties)

+ (NSFetchRequest<CDTeam *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDTeam"];
}

@dynamic team_id;
@dynamic name;

@end
