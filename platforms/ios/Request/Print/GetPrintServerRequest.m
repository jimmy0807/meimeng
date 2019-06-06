//
//  GetPrintServerRequest.m
//  meim
//
//  Created by 波恩公司 on 2017/12/22.
//

#import "GetPrintServerRequest.h"

@implementation GetPrintServerRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:profile.userID forKey:@"user_id"];
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"get_print_servers" params:@[params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetPrintServerResponse" object:nil userInfo:resultList];
    //self.finished(dict);
}

@end


