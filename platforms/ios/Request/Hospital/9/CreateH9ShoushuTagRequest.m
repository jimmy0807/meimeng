//
//  CreateH9ShoushuTagRequest.m
//  meim
//
//  Created by jimmy on 2017/8/22.
//
//

#import "CreateH9ShoushuTagRequest.h"

@implementation CreateH9ShoushuTagRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    self.params[@"user_id"] = profile.userID;
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"update_operate_tag" params:@[self.params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    
    self.requestFinished(dict, [resultList numberValueForKey:@"data"]);
}

@end
