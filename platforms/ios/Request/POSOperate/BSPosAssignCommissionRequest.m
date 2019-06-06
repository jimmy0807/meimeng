//
//  BSPosAssignCommissionRequest.m
//  Boss
//
//  Created by lining on 15/11/17.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSPosAssignCommissionRequest.h"

@interface BSPosAssignCommissionRequest ()
@property (nonatomic, strong) CDPosOperate *operate;
@end

@implementation BSPosAssignCommissionRequest

- (id)initWithPosOperate:(CDPosOperate *)operate params:(NSMutableDictionary *)params
{
    self = [super init];
    if (self) {
        self.operate = operate;
        self.params = params;
    }
    
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.card.operate";
    [self sendShopAssistantXmlWriteCommand:@[@[self.operate.operate_id],self.params]];
    return TRUE;
}


- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([retArray isKindOfClass:[NSNumber class]]) {
        NSLog(@"业绩分配成功");
    }
    else
    {
        dict = [self generateResponse:@"业绩分配失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kPosAssigncommissionResponse object:nil userInfo:dict];
}

@end
