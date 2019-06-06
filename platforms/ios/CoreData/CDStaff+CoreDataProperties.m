//
//  CDStaff+CoreDataProperties.m
//  meim
//
//  Created by jimmy on 2017/5/26.
//
//

#import "CDStaff+CoreDataProperties.h"

@implementation CDStaff (CoreDataProperties)

+ (NSFetchRequest<CDStaff *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDStaff"];
}

@dynamic address_id;
@dynamic address_name;
@dynamic birthday;
@dynamic departmemt_id;
@dynamic departmemt_name;
@dynamic email;
@dynamic gender;
@dynamic hr_category;
@dynamic imgName;
@dynamic is_book;
@dynamic is_login;
@dynamic job_id;
@dynamic job_name;
@dynamic last_time;
@dynamic latestBookTime;
@dynamic local_nickName;
@dynamic mobile_phone;
@dynamic name;
@dynamic nameLetter;
@dynamic password;
@dynamic rule_id;
@dynamic rule_name;
@dynamic staffID;
@dynamic staffNo;
@dynamic template_id;
@dynamic user_id;
@dynamic work_location;
@dynamic book_time;
@dynamic commissionRule;
@dynamic department;
@dynamic guwen_members;
@dynamic jishi_members;
@dynamic job;
@dynamic keshi;
@dynamic keshi_operate;
@dynamic managerDepartments;
@dynamic pos;
@dynamic role;
@dynamic store;
@dynamic tuijians;
@dynamic user;

@end
