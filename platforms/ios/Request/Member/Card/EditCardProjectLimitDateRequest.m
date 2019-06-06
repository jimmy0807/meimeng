//
//  EditCardProjectLimitDateRequest.m
//  meim
//
//  Created by jimmy on 2017/8/17.
//
//

#import "EditCardProjectLimitDateRequest.h"

@implementation EditCardProjectLimitDateRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    self.params[@"user_id"] = profile.userID;
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"update_limited_date" params:@[self.params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    
    self.finished(dict);
}

@end
