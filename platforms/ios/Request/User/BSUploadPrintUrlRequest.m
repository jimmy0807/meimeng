//
//  BSUploadPrintUrlRequest.m
//  meim
//
//  Created by 波恩公司 on 2018/5/15.
//

#import "BSUploadPrintUrlRequest.h"

@implementation BSUploadPrintUrlRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    self.params[@"user_id"] = profile.userID;
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"upload_print_url" params:@[self.params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadPrintUrlResponse" object:nil userInfo:nil];
    //self.finished(dict);
}

@end
