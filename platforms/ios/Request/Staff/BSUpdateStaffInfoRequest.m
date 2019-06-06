//
//  BSUpdateStaffInfoRequest.m
//  Boss
//
//  Created by mac on 15/7/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSUpdateStaffInfoRequest.h"

@implementation BSUpdateStaffInfoRequest
- (id)initWithStaffID:(NSNumber *)staffID attributeDic:(NSDictionary *)params
{
    self = [super init];
    if(self)
    {
        self.staffID = staffID;
        self.params = params;
    }
    return self;
}
- (BOOL)willStart
{
    self.needCompany = YES;
    self.tableName = @"hr.employee";
    self.additionalParams = @[@{@"tz":@"Asia/Shanghai"}];
    [self sendShopAssistantXmlWriteCommand:@[@[self.staffID], self.params]];
    
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if ([resultList isKindOfClass:[NSNumber class]])
    {
        if([(NSNumber *)resultList  isEqual: @1])
        {
            [params setValue:@0 forKey:@"rc"];
            [params setValue:@0 forKey:@"rm"];
            [[BSCoreDataManager currentManager] save:nil];
        }
    }
    else
    {
        params = [self generateResponse:@"修改失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSUpdateStaffInfoResponse object:self userInfo:params];
}
@end
