//
//  CDHFetchResult+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2017/9/25.
//
//

#import "CDHFetchResult+CoreDataProperties.h"

@implementation CDHFetchResult (CoreDataProperties)

+ (NSFetchRequest<CDHFetchResult *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDHFetchResult"];
}

@dynamic doctor_name;
@dynamic note;
@dynamic operate_date;
@dynamic operate_name;
@dynamic shoushu_id;
@dynamic state;
@dynamic state_name;

@end
