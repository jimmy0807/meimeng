//
//  BSFetchShopRequest.m
//  Boss
//
//  Created by mac on 15/7/13.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSCreateShopRequest.h"

@implementation BSCreateShopRequest
-(id)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if(self)
    {
        self.needCompany = YES;
        self.params = params;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.shop";
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
        
        [dict setObject:@0 forKey:@"rc"];
        [dict setObject:retArray forKey:@"data"];
    }
    else
    {
        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSShopCreateResponse object:nil userInfo:dict];
}

@end
