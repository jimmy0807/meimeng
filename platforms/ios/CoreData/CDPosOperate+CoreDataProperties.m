//
//  CDPosOperate+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/6/17.
//
//

#import "CDPosOperate+CoreDataProperties.h"

@implementation CDPosOperate (CoreDataProperties)

+ (NSFetchRequest<CDPosOperate *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDPosOperate"];
}

@dynamic amount;
@dynamic anesthetic_consuming;
@dynamic arrear_ids;
@dynamic binglika_id;
@dynamic born_uuid;
@dynamic card_id;
@dynamic card_name;
@dynamic card_shop_id;
@dynamic card_shop_name;
@dynamic commission_ids;
@dynamic consume_line_ids;
@dynamic consume_product_names;
@dynamic current_workflow_activity_id;
@dynamic currentWorkflowID;
@dynamic day;
@dynamic display_remark;
@dynamic doctor_id;
@dynamic doctor_name;
@dynamic handno;
@dynamic index;
@dynamic isLocal;
@dynamic isTakeout;
@dynamic keshi_id;
@dynamic keshi_name;
@dynamic line_display_name;
@dynamic localUpdateDate;
@dynamic member_id;
@dynamic member_mobile;
@dynamic member_name;
@dynamic memberNameFirstLetter;
@dynamic memberNameLetter;
@dynamic name;
@dynamic note;
@dynamic now_arrears_amount;
@dynamic now_card_amount;
@dynamic nowAmount;
@dynamic occupy_restaurant_id;
@dynamic old_operate_id;
@dynamic operate_date;
@dynamic operate_id;
@dynamic operate_shop_id;
@dynamic operate_shop_name;
@dynamic operate_user_id;
@dynamic operate_user_name;
@dynamic operateType;
@dynamic orderCreateStaffID;
@dynamic orderCreateStaffName;
@dynamic orderID;
@dynamic orderNumber;
@dynamic orderState;
@dynamic period_id;
@dynamic period_name;
@dynamic pricelist_id;
@dynamic pricelist_name;
@dynamic product_line_ids;
@dynamic progre_status;
@dynamic remark;
@dynamic restaurant_person_count;
@dynamic role_option;
@dynamic serial;
@dynamic session_id;
@dynamic session_name;
@dynamic state;
@dynamic statement_ids;
@dynamic type;
@dynamic wevip_member_id;
@dynamic wevip_member_name;
@dynamic workflow_id;
@dynamic year_month;
@dynamic year_month_day;
@dynamic yimei_guwenID;
@dynamic yimei_guwenName;
@dynamic yimei_member_type;
@dynamic yimei_operate_employee_id;
@dynamic yimei_operate_employee_ids;
@dynamic yimei_operate_employee_name;
@dynamic yimei_orderIndex;
@dynamic yimei_provision_id;
@dynamic yimei_queueID;
@dynamic yimei_shejishiID;
@dynamic yimei_shejishiName;
@dynamic yimei_shejizongjianID;
@dynamic yimei_shejizongjianName;
@dynamic yimei_sign_after;
@dynamic yimei_sign_before;
@dynamic doctorids;
@dynamic departmentids;
@dynamic productids;
@dynamic book;
@dynamic cardForOperateList;
@dynamic commissions;
@dynamic consumCoupons;
@dynamic couponCard;
@dynamic firstKeshi;
@dynamic member;
@dynamic memberCard;
@dynamic payInfos;
@dynamic products;
@dynamic recentMember;
@dynamic restaurant_table;
@dynamic shop;
@dynamic useItems;
@dynamic yimei_activity;
@dynamic yimei_before;

@end
