//
//  DeleteCouponCardRequest.m
//  meim
//
//  Created by jimmy on 2017/8/23.
//
//

#import "DeleteCouponCardRequest.h"

@implementation DeleteCouponCardRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    self.params[@"user_id"] = profile.userID;
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"unlink_coupon" params:@[self.params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    
    self.finished(dict);
}

@end
