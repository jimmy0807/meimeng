//
//  DeleteHuizhenRequest.m
//  meim
//
//  Created by jimmy on 2017/8/10.
//
//

#import "DeleteHuizhenRequest.h"

@implementation DeleteHuizhenRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    self.params[@"user_id"] = profile.userID;
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"unlink_record_line" params:@[self.params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:kHHuizhenCreateResponse object:nil userInfo:dict];
    self.finished(dict);
}

@end
