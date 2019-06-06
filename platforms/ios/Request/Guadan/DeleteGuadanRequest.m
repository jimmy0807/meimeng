//
//  DeleteGuadanRequest.m
//  meim
//
//  Created by 波恩公司 on 2017/12/21.
//

#import "DeleteGuadanRequest.h"

@implementation DeleteGuadanRequest

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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GuadanDeleteResponse" object:nil userInfo:nil];
    self.finished(dict);
}

@end

