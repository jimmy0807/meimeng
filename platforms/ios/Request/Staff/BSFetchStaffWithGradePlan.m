//
//  BSFetchStaffWithGradePlan.m
//  Boss
//
//  Created by mac on 15/8/13.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchStaffWithGradePlan.h"

@implementation BSFetchStaffWithGradePlan
- (BOOL)willStart
{
    self.tableName = @"hr.employee";
    self.filter = @[@"rule_id",@"!=",@[]];
    self.additionalParams = @[@{@"tz":@"Asia/Shanghai"}];
    [self sendShopAssistantXmlSearchReadCommand];
    return YES;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = (NSArray *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (retArray.count>0)
    {
        

    }
    else
    {
        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSJobCreateResponse object:nil userInfo:dict];
}

@end
