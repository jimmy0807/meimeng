//
//  BSFetchStaffJobRequest.m
//  Boss
//
//  Created by lining on 15/7/8.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchStaffJobRequest.h"

@implementation BSFetchStaffJobRequest

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"hr.job";
    
    self.filter = @[];
    self.field = @[@"name",@"department_id"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        
        NSArray *jobs = [dataManager fetchAllStaffJobs];
        NSMutableArray *oldJobs = [NSMutableArray arrayWithArray:jobs];
        for (NSDictionary *params in retArray) {
            NSNumber *jobId = [params numberValueForKey:@"id"];
            CDStaffJob *staffJob = [dataManager findEntity:@"CDStaffJob" withValue:jobId forKey:@"job_id"];
            if (staffJob) {
                [oldJobs removeObject:staffJob];
            }
            else
            {
                staffJob = [dataManager insertEntity:@"CDStaffJob"];
                staffJob.job_id = jobId;
            }
            
            staffJob.job_name = [params stringValueForKey:@"name"];
            
            
            NSArray *department = [params arrayValueForKey:@"department_id"];//部门
            if (department.count > 0) {
                NSNumber *department_id = department[0];
                CDStaffDepartment *staffDepartment = [dataManager findEntity:@"CDStaffDepartment" withValue:department_id forKey:@"department_id"];
                if (!staffDepartment) {
                    staffDepartment = [dataManager insertEntity:@"CDStaffDepartment"];
                    staffDepartment.department_id = department_id;
                }
                staffDepartment.department_name = department[1];
                
                staffJob.department = staffDepartment;
            }
        }
        [dataManager deleteObjects:oldJobs];
        [dataManager save:nil];
        [dict setObject:@0 forKey:@"rc"];
    }
    else
    {
        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchStaffJobResponse object:nil userInfo:dict];
        
}
@end
