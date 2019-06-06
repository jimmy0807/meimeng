//
//  BSStaffCreateRequest.m
//  Boss
//
//  Created by mac on 15/7/8.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSStaffCreateRequest.h"

@interface BSStaffCreateRequest ()
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) CDStaff *staff;
@end

@implementation BSStaffCreateRequest
- (id)initWithStaff:(CDStaff *)staff params:(NSDictionary *)params
{
    self = [super init];
    if(self)
    {
        self.staff = staff;
        self.params = params;
    }
    return self;
}

- (BOOL)willStart
{
    self.needCompany = YES;
    self.tableName = @"hr.employee";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.params];
    [params setObject:[PersonalProfile currentProfile].businessId forKey:@"company_id"];
    
    self.additionalParams = @[@{@"tz":@"Asia/Shanghai"}];
    [self sendShopAssistantXmlCreateCommand:@[params]];
    return YES;
}

-(void)didFinishOnMainThread
{
    NSNumber *retArray = (NSNumber *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray integerValue]>0) {
        
        self.staff.staffID = retArray;
        [[BSCoreDataManager currentManager] save:nil];
        [dict setObject:@0 forKey:@"rc"];
    }
    else
    {
        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSStaffCreateResponse object:nil userInfo:dict];
}
@end
