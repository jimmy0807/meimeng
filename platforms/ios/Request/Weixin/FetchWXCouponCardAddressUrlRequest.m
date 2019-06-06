//
//  FetchWXCouponCardAddressUrlRequest.m
//  Boss
//
//  Created by jimmy on 16/5/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FetchWXCouponCardAddressUrlRequest.h"

@interface FetchWXCouponCardAddressUrlRequest ()
@property(nonatomic, strong)NSArray* wxCardTemplates;
@property(nonatomic, strong)NSString* phoneNumber;
@end

@implementation FetchWXCouponCardAddressUrlRequest

- (instancetype)initWithWxCardTemplates:(NSArray*)wxCardTemplates phoneNumber:(NSString*)phoneNumber
{
    self = [super init];
    if ( self )
    {
        self.wxCardTemplates = wxCardTemplates;
        self.phoneNumber = phoneNumber;
    }
    
    return self;
}

-(BOOL)willStart
{
    [super willStart];
    
    NSString *cmd =  cmd = [NSString stringWithFormat:@"%@%@", SERVER_IP ,@"/xmlrpc/2/ds_api"];
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"company_born_uuid"] = profile.companyUUID;
    params[@"shop_born_uuid"] = profile.shopUUID;
    //params[@"is_unique_code"] = [NSNumber numberWithBool:FALSE];
    NSMutableArray* ids = [NSMutableArray array];
    for ( CDWXCardTemplate* t in self.wxCardTemplates )
    {
        [ids addObject:t.template_id];
    }
    
    params[@"card_ids"] = ids;
    params[@"phone"] = self.phoneNumber;
    
    NSString *jsonString = [BNXmlRpc jsonWithArray:@[params]];
    NSString *xmlString = [BNXmlRpc xmlMethod:@"wxcard_coupo_qrcode" jsonString:jsonString];
    
    [self sendXmlCommand:cmd params:xmlString];
    
    return true;
}


- (void)didFinishOnMainThread
{
    NSDictionary *retDict = (NSDictionary *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchWXCouponCardAddressUrlResponse object:self userInfo:retDict];
}

@end
