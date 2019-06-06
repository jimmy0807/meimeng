//
//  BSCreateExtendedRequest.m
//  Boss
//
//  Created by lining on 16/4/27.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSCreateExtendedRequest.h"

@interface BSCreateExtendedRequest ()
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation BSCreateExtendedRequest

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        self.params = params;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    
    self.tableName = @"born.extended";
    
    [self sendRpcXmlStyle:@"create" params:@[self.params]];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict;
    if ([retArray isKindOfClass:[NSNumber class]]) {
        NSLog(@"创建成功");
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSCreateExtendedResponse object:nil userInfo:dict];
}

@end
