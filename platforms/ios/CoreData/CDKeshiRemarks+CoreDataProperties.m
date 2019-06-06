//
//  CDKeshiRemarks+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2018/3/2.
//
//

#import "CDKeshiRemarks+CoreDataProperties.h"

@implementation CDKeshiRemarks (CoreDataProperties)

+ (NSFetchRequest<CDKeshiRemarks *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDKeshiRemarks"];
}

@dynamic remark_id;
@dynamic remark_name;

@end
