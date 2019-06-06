//
//  BSCreateDepartmentRequest.m
//  Boss
//
//  Created by mac on 15/7/14.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSCreateDepartmentRequest.h"

@interface BSCreateDepartmentRequest ()
@property(nonatomic,strong)NSDictionary *params;
@property(nonatomic, strong) CDStaffDepartment *department;
@end

@implementation BSCreateDepartmentRequest
- (id)initWithDepartment:(CDStaffDepartment *)department params:(NSDictionary *)params
{
    self = [super init];
    if(self)
    {
        self.params = params;
        self.department = department;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"hr.department";
    //    NSDictionary *params = self.attributeDic;
    self.additionalParams = @[@{@"tz":@"Asia/Shanghai"}];
    [self sendShopAssistantXmlCreateCommand:@[self.params]];
    return YES;
}

-(void)didFinishOnMainThread
{
    NSNumber *retArray = (NSNumber *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray integerValue]>0) {
        self.department.department_id = retArray;
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSDepartmentCreateResponse object:nil userInfo:dict];
}

@end
