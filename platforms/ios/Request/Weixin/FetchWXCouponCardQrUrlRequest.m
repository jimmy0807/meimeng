//
//  FetchWXCouponCardQrUrlRequest.m
//  Boss
//
//  Created by jimmy on 16/5/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FetchWXCouponCardQrUrlRequest.h"

@interface FetchWXCouponCardQrUrlRequest ()
@property(nonatomic, strong)NSArray* wxCardTemplates;
@property(nonatomic, strong)NSString* phoneNumber;
@end

@implementation FetchWXCouponCardQrUrlRequest

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
    params[@"can_share"] = [NSNumber numberWithBool:YES];
    CDStore* s = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:profile.shopIds[0] forKey:@"storeID"];
    params[@"page_title"] = s.storeName.length > 0 ? s.storeName : @"PAD客户端";
    
    NSMutableArray* ids = [NSMutableArray array];
    for ( CDWXCardTemplate* t in self.wxCardTemplates )
    {
        [ids addObject:t.template_id];
    }
    
    params[@"card_ids"] = ids;
    params[@"phone"] = self.phoneNumber;
    
    NSString *jsonString = [BNXmlRpc jsonWithArray:@[params]];
    NSString *xmlString = [BNXmlRpc xmlMethod:@"wxcard_coupo_url" jsonString:jsonString];
    
    [self sendXmlCommand:cmd params:xmlString];
    
    return true;
}


- (void)didFinishOnMainThread
{
    NSDictionary *retDict = (NSDictionary *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchWXCouponCardQrUrlResponse object:self userInfo:retDict];
}

@end
