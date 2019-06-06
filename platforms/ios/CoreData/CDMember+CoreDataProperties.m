//
//  CDMember+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2017/11/9.
//
//

#import "CDMember+CoreDataProperties.h"

@implementation CDMember (CoreDataProperties)

+ (NSFetchRequest<CDMember *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDMember"];
}

@dynamic amount;
@dynamic arrearsAmount;
@dynamic astro;
@dynamic birthday;
@dynamic blood_type;
@dynamic companyID;
@dynamic companyName;
@dynamic courseArrearsAmount;
@dynamic dd_partner;
@dynamic director_employee;
@dynamic director_employee_id;
@dynamic dj_partner;
@dynamic dl_partner;
@dynamic doctor_id;
@dynamic doctor_name;
@dynamic email;
@dynamic employee_name;
@dynamic first_treat_date;
@dynamic gender;
@dynamic h_patient_type;
@dynamic idCardNumber;
@dynamic image_url;
@dynamic imageName;
@dynamic isAcitve;
@dynamic isDefaultCustomer;
@dynamic isTiyan;
@dynamic isWevipCustom;
@dynamic lastUpdate;
@dynamic member_address;
@dynamic member_feedback_count;
@dynamic member_fenlei;
@dynamic member_guwen_id;
@dynamic member_guwen_name;
@dynamic member_identity_id;
@dynamic member_jishi_id;
@dynamic member_jishi_name;
@dynamic member_level;
@dynamic member_qq;
@dynamic member_qy_count;
@dynamic member_shejishi_id;
@dynamic member_shejishi_name;
@dynamic member_sign_date;
@dynamic member_source;
@dynamic member_title_id;
@dynamic member_title_name;
@dynamic member_tuijian_staff_id;
@dynamic member_tuijian_staff_name;
@dynamic member_tuijian_vip_id;
@dynamic member_tuijian_vip_name;
@dynamic member_tz_count;
@dynamic member_wx;
@dynamic memberID;
@dynamic memberName;
@dynamic memberNameFirstLetter;
@dynamic memberNameLetter;
@dynamic memberNameSingleLetter;
@dynamic memberNo;
@dynamic mobile;
@dynamic patient_tag;
@dynamic point;
@dynamic product_all_ids;
@dynamic record_id;
@dynamic record_note;
@dynamic record_time;
@dynamic showPatient;
@dynamic sortIndex;
@dynamic status;
@dynamic storeID;
@dynamic storeName;
@dynamic yimei_member_type;
@dynamic parent_id;
@dynamic parent_name;
@dynamic amounts;
@dynamic arrears;
@dynamic card;
@dynamic changeShops;
@dynamic consumes;
@dynamic coupons;
@dynamic feedbacks;
@dynamic guwen;
@dynamic jishi;
@dynamic member_tuijian;
@dynamic points;
@dynamic posOperate;
@dynamic qinyous;
@dynamic recentOperates;
@dynamic staff_tuijian;
@dynamic store;
@dynamic tezhengs;
@dynamic title;
@dynamic tuijian_members;

@end
