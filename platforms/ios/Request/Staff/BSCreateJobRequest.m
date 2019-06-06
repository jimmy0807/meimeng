//
//  BSCreateJobRequest.m
//  Boss
//
//  Created by mac on 15/7/15.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSCreateJobRequest.h"

@interface BSCreateJobRequest ()
@property(nonatomic, strong) NSDictionary *params;
@property(nonatomic, strong) CDStaffJob *staffJob;
@end

@implementation BSCreateJobRequest
- (id)initWithStaffJob:(CDStaffJob *)job params:(NSDictionary *)params
{
    self = [super init];
    if(self)
    {
        self.params = params;
        self.staffJob = job;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"hr.job";
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
        
        
        self.staffJob.job_id = retArray;
        [[BSCoreDataManager currentManager] save:nil];
        
    }
    else
    {
        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSJobCreateResponse object:nil userInfo:dict];
}

@end
