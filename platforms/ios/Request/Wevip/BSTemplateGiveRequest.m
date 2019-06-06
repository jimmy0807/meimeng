//
//  BSTemplateGiveRequest.m
//  Boss
//
//  Created by lining on 16/4/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSTemplateGiveRequest.h"

@interface BSTemplateGiveRequest ()
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation BSTemplateGiveRequest
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
    self.tableName = @"born.weika.product";
    
    [self sendRpcXmlStyle:@"create_coupon" params:@[self.params]];

    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSNumber class]]) {
        NSLog(@"赠送成功");
    }
    else
    {
        NSLog(@"赠送失败");
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    if (self.type == TemplateType_coupon) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSGiveTicketResponse object:nil userInfo:dict];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSGiveCardResponse object:nil userInfo:dict];
    }
}

@end
