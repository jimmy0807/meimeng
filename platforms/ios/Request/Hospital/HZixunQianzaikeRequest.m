//
//  HZixunQianzaikeRequest.m
//  meim
//
//  Created by jimmy on 2017/5/5.
//
//

#import "HZixunQianzaikeRequest.h"

@implementation HZixunQianzaikeRequest

- (BOOL)willStart
{
    self.tableName = @"born.medical.advisory";
    
    [self sendRpcXmlStyle:@"to_visit" params:@[@[self.zixun.zixun_id]]];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSNumber *memberID = nil;
    if (resultStr.length != 0)
    {
    }
}

@end
