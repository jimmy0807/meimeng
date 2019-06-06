//
//  HJiaohaoCancelRequest.m
//  meim
//
//  Created by jimmy on 2017/6/16.
//
//

#import "HJiaohaoCancelRequest.h"

@implementation HJiaohaoCancelRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:profile.userID, @"user_id", nil];
    params[@"id"] = self.jiaohao.jiaohao_id;
    params[@"current_workflow_activity_id"] = self.jiaohao.current_workflow_activity_id;
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"jump_workflow" params:@[params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableArray *searchList = nil;
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    
    if (resultStr.length != 0 && resultList != nil && [resultList isKindOfClass:[NSDictionary class]])
    {
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHJiaoHaoCancelResponse object:nil userInfo:dict];
}

@end
