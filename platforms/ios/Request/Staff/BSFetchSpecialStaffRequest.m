//
//  BSFetchSpecialStaffRequest.m
//  Boss
//
//  Created by mac on 15/7/21.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchSpecialStaffRequest.h"

@implementation BSFetchSpecialStaffRequest
- (id)initWithStaff:(CDStaff *)staff
{
    if(self =[super init])
    {
        self.staff = staff;
    }
    return self;
}

-(BOOL)willStart
{
    [super willStart];
    self.needCompany = true;
    self.tableName = @"hr.employee";
    self.filter = @[@[@"id",@"=",self.staff.staffID]];
    self.field = @[@"name",@"mobile_phone",@"birthday",@"gender",@"work_email",@"shop_id",@"is_login",@"user_id",@"template_id",@"password",@"pos_config_id",@"department_id",@"job_id",@"isbook",@"no"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        for (NSDictionary *params in retArray) {
//            NSNumber *staffId = [params numberValueForKey:@"id"];
//            CDStaff *staff = [dataManager findEntity:@"CDStaff" withValue:staffId forKey:@"staffID"];
            
            CDStaff *staff = self.staff;
            staff.name = [params stringValueForKey:@"name"];
            //            NSLog(@"%@-%@",staff.name,staff.nameLetter);
            staff.staffNo = [params stringValueForKey:@"no"];
            staff.email = [params stringValueForKey:@"work_email"];
            staff.mobile_phone = [params stringValueForKey:@"mobile_phone"];
            staff.is_book = [params numberValueForKey:@"isbook"];
            staff.is_login = [params numberValueForKey:@"is_login"];
            staff.password = [params stringValueForKey:@"password"];
            
//            NSString *sex = [params stringValueForKey:@"gender"];
//            if([sex isEqualToString:@"male"])
//            {
//                staff.gender = @1;
//            }else if([sex isEqualToString:@"female"])
//            {
//                staff.gender = @0;
//            }else{
//                staff.gender = @(-1);
//            }
            staff.gender = [params stringValueForKey:@"gender"];
            staff.birthday = [params stringValueForKey:@"birthday"];
            
            
            NSArray *user = [params arrayValueForKey:@"user_id"]; //用户(登录账户)
            if (user.count > 0) {
                NSNumber *user_id =  user[0];
                CDUser *staffUser = [dataManager findEntity:@"CDUser" withValue:user_id forKey:@"user_id"];
                if (!staffUser) {
                    staffUser = [dataManager insertEntity:@"CDUser"];
                    staffUser.user_id = user_id;
                }
                staffUser.name = user[1];
                staff.user = staffUser;
                staff.user_id = user_id;
            }
            
            NSArray *template = [params arrayValueForKey:@"template_id"]; //权限(角色)
            if (template.count > 0) {
                NSNumber *template_id = template[0];
                CDStaffRole *staffRole = [dataManager findEntity:@"CDStaffRole" withValue:template_id forKey:@"roleID"];
                if (!staffRole) {
                    staffRole = [dataManager insertEntity:@"CDStaffRole"];
                    staffRole.roleID = template_id;
                }
                staffRole.roleName = template[1];
                staff.role = staffRole;
                staff.template_id  = template_id;
            }
            
            NSArray *pos = [params arrayValueForKey:@"pos_config_id"];   //收银配置
            if (pos.count > 0) {
                NSNumber *posID = pos[0];
                CDPosConfig *posConfig = [dataManager findEntity:@"CDPosConfig" withValue:posID forKey:@"posID"];
                if (!posConfig)
                {
                    posConfig = [dataManager insertEntity:@"CDPosConfig"];
                    posConfig.posID = posID;
                }
                posConfig.posName = pos[1];
                staff.pos = posConfig;
            }
            NSArray *department = [params arrayValueForKey:@"department_id"]; //部门
            if (department.count > 0) {
                NSNumber *department_id = department[0];
                CDStaffDepartment *staffDepartment = [dataManager findEntity:@"CDStaffDepartment" withValue:department_id forKey:@"department_id"];
                if (!staffDepartment) {
                    staffDepartment = [dataManager insertEntity:@"CDStaffDepartment"];
                    staffDepartment.department_id = department_id;
                }
                staffDepartment.department_name = department[1];
                
                staff.department = staffDepartment;
            }
            
            NSArray *job = [params arrayValueForKey:@"job_id"];  //职位(job)
            if (job.count > 0) {
                NSNumber *job_id = job[0];
                CDStaffJob *staffJob = [dataManager findEntity:@"CDStaffJob" withValue:job_id forKey:@"job_id"];
                if (!staffJob) {
                    staffJob = [dataManager insertEntity:@"CDStaffJob"];
                    staffJob.job_id = job_id;
                }
                staffJob.job_name = job[1];
                
                staff.job = staffJob;
            }
            
            
            
            NSArray *shop_id = [params arrayValueForKey:@"shop_id"]; //门店
            if (shop_id.count > 0) {
                NSNumber *storeId = [shop_id objectAtIndex:0];
                CDStore *store = [dataManager findEntity:@"CDStore" withValue:storeId forKey:@"storeID"];
                if (!store) {
                    store = [dataManager insertEntity:@"CDStore"];
                    store.storeID = storeId;
                }
                store.storeName = [shop_id objectAtIndex:1];
                
                staff.store = store;
                
                staff.imgName = [NSString stringWithFormat:@"staff_%@_%@",storeId,staff.staffID]; //名字自己拼的
            }
            
        }
        [dataManager save:nil];
        [dict setObject:@0 forKey:@"rc"];
    }
    else
    {
        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchSpecialStaffRequest object:nil userInfo:dict];
}

@end
