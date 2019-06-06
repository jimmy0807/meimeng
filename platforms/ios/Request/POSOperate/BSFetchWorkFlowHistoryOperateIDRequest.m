//
//  BSFetchWorkFlowHistoryOperateIDRequest.m
//  meim
//
//  Created by jimmy on 2017/6/15.
//
//

#import "BSFetchWorkFlowHistoryOperateIDRequest.h"

@implementation BSFetchWorkFlowHistoryOperateIDRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:profile.userID forKey:@"user_id"];
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"medical_member_info" params:@[params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (resultStr.length != 0 && resultList != nil && [resultList isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *resuntDitc = (NSDictionary *)resultList;
        NSDictionary *data = [resuntDitc objectForKey:@"data"];
        
        if ([data isKindOfClass:[NSArray class]])
        {
            
        }
    }
}

@end
