//
//  HHuizhenCreateRequest_N.m
//  meim
//
//  Created by jimmy on 2017/7/24.
//
//

#import "HHuizhenCreateRequest_N.h"

@implementation HHuizhenCreateRequest_N

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    self.params[@"user_id"] = profile.userID;
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"update_record_line_nine" params:@[self.params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHHuizhenCreateResponse object:nil userInfo:dict];
}

@end
