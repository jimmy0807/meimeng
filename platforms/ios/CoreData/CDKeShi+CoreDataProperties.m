//
//  CDKeShi+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2018/2/5.
//
//

#import "CDKeShi+CoreDataProperties.h"

@implementation CDKeShi (CoreDataProperties)

+ (NSFetchRequest<CDKeShi *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDKeShi"];
}

@dynamic doctor_id;
@dynamic doctor_name;
@dynamic is_display_adviser;
@dynamic is_display_designer;
@dynamic keshi_id;
@dynamic name;
@dynamic parentID;
@dynamic remark_ids;
@dynamic operate_machine;
@dynamic operate1;
@dynamic staff;

@end
