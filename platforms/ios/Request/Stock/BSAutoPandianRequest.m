


//
//  BSAutoPandianRequest.m
//  Boss
//
//  Created by lining on 15/9/17.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSAutoPandianRequest.h"
#import "BSFetchSiglePanDianRequest.h"

@interface BSAutoPandianRequest ()
@property(nonatomic, strong) CDPanDian *panDian;
@end

@implementation BSAutoPandianRequest

- (id)initWithPanDian:(CDPanDian *)panDian
{
    self = [super init];
    if (self) {
        self.panDian = panDian;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"stock.inventory";
    
    [self sendRpcXmlStyle:@"prepare_inventory" params:@[@[self.panDian.pd_id]]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    id resultArray =[BNXmlRpc arrayWithXmlRpc:resultStr];
    if ([resultArray isKindOfClass:[NSNumber class]]) {
        if ([resultArray integerValue] == 1) {
            [dict setObject:@0 forKey:@"rc"];
            self.panDian.state = @"confirm";
            [[BSCoreDataManager currentManager] save:nil];
            
            BSFetchSiglePanDianRequest *request = [[BSFetchSiglePanDianRequest alloc] initWithPanDian:self.panDian];
            [request execute];
            
        }
        else
        {
            dict = [self generateResponse:@"请求发生错误"];
        }
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSAutoPanDianResponse object:nil userInfo:dict];
}

@end
