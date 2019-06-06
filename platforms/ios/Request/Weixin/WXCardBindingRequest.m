//
//  WXCardBindingRequest.m
//  Boss
//
//  Created by jimmy on 16/5/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "WXCardBindingRequest.h"

@interface WXCardBindingRequest ()
@property(nonatomic, strong)CDMemberCard* card;
@end

@implementation WXCardBindingRequest

- (instancetype)initWithMemberCard:(CDMemberCard*)memberCard
{
    self = [super init];
    if ( self )
    {
        self.card = memberCard;
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
    params[@"card_born_uuid"] = self.card.cardUUID;
    params[@"card_id"] = self.card.cardID;
    
    NSString *jsonString = [BNXmlRpc jsonWithArray:@[params]];
    NSString *xmlString = [BNXmlRpc xmlMethod:@"wxcard_binding" jsonString:jsonString];
    
    [self sendXmlCommand:cmd params:xmlString];
    
    return true;
}


- (void)didFinishOnMainThread
{
    NSDictionary *retDict = (NSDictionary *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kWeixinCardBindingResponse object:nil userInfo:retDict];
}

@end
