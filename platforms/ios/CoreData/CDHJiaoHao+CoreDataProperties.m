//
//  CDHJiaoHao+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2018/5/3.
//
//

#import "CDHJiaoHao+CoreDataProperties.h"

@implementation CDHJiaoHao (CoreDataProperties)

+ (NSFetchRequest<CDHJiaoHao *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDHJiaoHao"];
}

@dynamic advisory_product_names;
@dynamic create_uid;
@dynamic current_workflow_activity_id;
@dynamic customer_id;
@dynamic customer_name;
@dynamic departments_id;
@dynamic doctor_id;
@dynamic doctor_name;
@dynamic is_print;
@dynamic is_update;
@dynamic jiaohao_id;
@dynamic jump_name;
@dynamic keshi_id;
@dynamic keshi_name;
@dynamic member_type;
@dynamic memberNameFirstLetter;
@dynamic memberNameLetter;
@dynamic operate_employee_ids;
@dynamic print_url;
@dynamic progre_status;
@dynamic queue;
@dynamic queue_no;
@dynamic sort_index;
@dynamic state;
@dynamic willCancel;
@dynamic peitai_nurse_id;
@dynamic peitai_nurse_name;
@dynamic xunhui_nurse_id;
@dynamic xunhui_nurse_name;
@dynamic anesthetist_id;
@dynamic anesthetist_name;
@dynamic flow;

@end
