//
//  CDHJiaoHaoWorkflow+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/7/3.
//
//

#import "CDHJiaoHaoWorkflow+CoreDataProperties.h"

@implementation CDHJiaoHaoWorkflow (CoreDataProperties)

+ (NSFetchRequest<CDHJiaoHaoWorkflow *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDHJiaoHaoWorkflow"];
}

@dynamic workflow_id;
@dynamic state;
@dynamic name;
@dynamic operate_time;
@dynamic jiaohao;

@end
