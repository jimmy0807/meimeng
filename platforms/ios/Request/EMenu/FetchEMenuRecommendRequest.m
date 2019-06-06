//
//  FetchEMenuRecommendRequest.m
//  meim
//
//  Created by 波恩公司 on 2018/3/28.
//

#import "FetchEMenuRecommendRequest.h"

@implementation FetchEMenuRecommendRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:profile.userID forKey:@"user_id"];
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"pad_menu_recommend_product_list" params:@[params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EMenuRecFetchResponse" object:nil userInfo:resultList];
    //self.finished(dict);
}

@end


