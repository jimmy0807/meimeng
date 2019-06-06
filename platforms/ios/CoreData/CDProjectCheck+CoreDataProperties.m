//
//  CDProjectCheck+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2018/4/24.
//
//

#import "CDProjectCheck+CoreDataProperties.h"

@implementation CDProjectCheck (CoreDataProperties)

+ (NSFetchRequest<CDProjectCheck *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDProjectCheck"];
}

@dynamic checkID;
@dynamic productID;
@dynamic qty;

@end
