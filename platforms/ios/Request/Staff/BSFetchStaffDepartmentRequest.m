//
//  BSFetchStaffDepartmentRequest.m
//  Boss
//
//  Created by lining on 15/7/8.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchStaffDepartmentRequest.h"

@implementation BSFetchStaffDepartmentRequest

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"hr.department";
    
    self.filter = @[];
    self.field = @[@"name",@"complete_name",@"jobs_ids",@"manager_id",@"parent_id"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        
        NSArray *departments = [dataManager fetchAllStaffDepartments];
        NSMutableArray *oldDepartments = [NSMutableArray arrayWithArray:departments];

        for (NSDictionary *params in retArray) {
            NSNumber *department_id = [params numberValueForKey:@"id"];
            CDStaffDepartment *department = [dataManager findEntity:@"CDStaffDepartment" withValue:department_id forKey:@"department_id"];
            if (department) {
                [oldDepartments removeObject:department];
            }
            else
            {
                department = [dataManager insertEntity:@"CDStaffDepartment"];
                department.department_id = department_id;
            }
            department.department_name = [params stringValueForKey:@"name"];
            department.completeName = [params stringValueForKey:@"complete_name"];
            
            NSArray *job_ids = [params arrayValueForKey:@"jobs_ids"]; //职位ids
            if (job_ids.count > 0) {
                department.job_ids = [job_ids componentsJoinedByString:@","];
            }
            
            NSArray *parent = [params arrayValueForKey:@"parent_id"];//父级部门
            if (parent.count > 0) {
                NSNumber *parnter_id = parent[0];
                department.parnter_id = parnter_id;
                CDStaffDepartment *parentDepartment = [dataManager findEntity:@"CDStaffDepartment" withValue:parnter_id forKey:@"department_id"];
                if (!parentDepartment) {
                    parentDepartment = [dataManager insertEntity:@"CDStaffDepartment"];
                    parentDepartment.department_id = parnter_id;
                }
                parentDepartment.department_name = parent[1];
                department.parentDepartment = parentDepartment;
                
            }
            
            
            
            NSArray *manager = [params arrayValueForKey:@"manager_id"]; //部门经理
            if (manager.count > 0) {
                department.manager_id = manager[0];
                department.manage_name = manager[1];
            }
            
        }
        [dataManager deleteObjects:oldDepartments];
        [dataManager save:nil];
        [dict setObject:@0 forKey:@"rc"];
    }
    else
    {
        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchStaffDepartmentResponse object:nil userInfo:dict];
}

@end
