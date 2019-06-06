//
//  CDPosWashHand+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2018/4/27.
//
//

#import "CDPosWashHand+CoreDataProperties.h"

@implementation CDPosWashHand (CoreDataProperties)

+ (NSFetchRequest<CDPosWashHand *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDPosWashHand"];
}

@dynamic anesthetist_id;
@dynamic anesthetist_name;
@dynamic binglika_id;
@dynamic current_activity_id;
@dynamic current_work_index;
@dynamic currentWorkflowID;
@dynamic display_remark;
@dynamic doctor_id;
@dynamic doctor_name;
@dynamic flow_end;
@dynamic fumayao_time;
@dynamic imageUrl;
@dynamic keshi_id;
@dynamic keshi_name;
@dynamic medical_note;
@dynamic diagnose;
@dynamic treatment;
@dynamic member_id;
@dynamic member_mobile;
@dynamic member_name;
@dynamic member_name_detail;
@dynamic memberNameFirstLetter;
@dynamic memberNameLetter;
@dynamic name;
@dynamic note;
@dynamic operate_activity_id;
@dynamic operate_date;
@dynamic operate_date_detail;
@dynamic operate_id;
@dynamic peitai_nurse_id;
@dynamic peitai_nurse_name;
@dynamic prescriptions;
@dynamic print_url;
@dynamic remark;
@dynamic role_option;
@dynamic sign_member_name;
@dynamic sort_index;
@dynamic state;
@dynamic work_names;
@dynamic xunhui_nurse_id;
@dynamic xunhui_nurse_name;
@dynamic yimei_guwenName;
@dynamic yimei_member_type;
@dynamic yimei_operate_employee_ids;
@dynamic yimei_operate_employee_name;
@dynamic yimei_queueID;
@dynamic yimei_shejishiName;
@dynamic yimei_shejizongjianName;
@dynamic yimei_sign_after;
@dynamic yimei_sign_before;
@dynamic customer_state_name;
@dynamic customer_state;
@dynamic activity_state_name;
@dynamic activity_state;
@dynamic chufang_items;
@dynamic feichufang_items;
@dynamic yimei_before;
@dynamic consumable_ids;

@end
