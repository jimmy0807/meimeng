//
//  BSFechShopRequest.m
//  Boss
//
//  Created by lining on 15/5/8.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFechShopRequest.h"

@interface BSFechShopRequest ()
@end

@implementation BSFechShopRequest
-(BOOL)willStart
{
    self.tableName = @"born.shop";
    NSMutableArray *mutablArray = [NSMutableArray array];
    if ([PersonalProfile currentProfile].shopIds.count > 0) {
        [mutablArray addObject:@[@"id",@"in",[PersonalProfile currentProfile].shopIds]];
    }
    if (self.filterString) {
        [mutablArray addObject:@[@"name",@"ilike",self.filterString]];
    }
    self.filter = [NSArray arrayWithArray:mutablArray];
    self.field = @[@"name"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    
    
    if (retArray.count > 0) {
        NSLog(@"请求成功");
    }
    else
    {
        NSLog(@"请求失败");
    }
}
@end
