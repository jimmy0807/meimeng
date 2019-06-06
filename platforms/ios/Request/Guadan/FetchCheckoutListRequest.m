//
//  FetchCheckoutListRequest.m
//  meim
//
//  Created by 波恩公司 on 2017/12/11.
//

#import "FetchCheckoutListRequest.h"

@implementation FetchCheckoutListRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:profile.userID forKey:@"user_id"];
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"checkout_list" params:@[params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GuadanFetchResponse" object:nil userInfo:resultList];
    //self.finished(dict);
}

@end

