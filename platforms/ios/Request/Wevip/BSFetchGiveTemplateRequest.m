//
//  BSFetchGiveTemplateRequest.m
//  Boss
//
//  Created by lining on 16/3/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchGiveTemplateRequest.h"

@implementation BSFetchGiveTemplateRequest
- (BOOL)willStart
{
    [super willStart];
    
    self.tableName = @"born.weika.product";
    self.filter = @[@[@"is_featured",@"=",@1]];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    if ([retArray isKindOfClass:[NSArray class]]) {
        
    }
    
}

@end
