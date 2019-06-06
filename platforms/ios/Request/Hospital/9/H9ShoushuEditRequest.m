//
//  H9ShoushuEditRequest.m
//  meim
//
//  Created by jimmy on 2017/8/15.
//
//

#import "H9ShoushuEditRequest.h"

@implementation H9ShoushuEditRequest

- (BOOL)willStart
{
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"update_medical_operate_line" params:@[self.params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHShoushuCreateResponse object:nil userInfo:dict];
    
    if ( self.finished )
    {
        self.finished(dict);
    }
}

@end
