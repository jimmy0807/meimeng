//
//  FetchWXCardUrlRequest.m
//  Boss
//
//  Created by jimmy on 16/5/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FetchWXCardUrlRequest.h"

@implementation FetchWXCardUrlRequest

-(BOOL)willStart
{
    [super willStart];
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    if ( profile.companyUUID.length == 0 )
    {
        return FALSE;
    }
    
    NSString *cmd =  cmd = [NSString stringWithFormat:@"%@%@", SERVER_IP ,@"/xmlrpc/2/ds_api"];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"company_born_uuid"] = profile.companyUUID;
    params[@"shop_born_uuid"] = profile.shopUUID;
    
    NSString *jsonString = [BNXmlRpc jsonWithArray:@[params]];
    NSString *xmlString = [BNXmlRpc xmlMethod:@"wxcard_url" jsonString:jsonString];
    
    [self sendXmlCommand:cmd params:xmlString];
    
    return true;
}


- (void)didFinishOnMainThread
{
    NSDictionary *retDict = (NSDictionary *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    
    if ([retDict isKindOfClass:[NSDictionary class]])
    {
        NSNumber *errorRet = [retDict numberValueForKey:@"errcode"];
        if (errorRet.integerValue == 0)
        {
            NSDictionary* params = retDict[@"data"];
            if ( [params isKindOfClass:[NSDictionary class]] )
            {
                NSArray* url = params[@"url"];
                PersonalProfile* profile = [PersonalProfile currentProfile];
                if ( [url isKindOfClass:[NSArray class]] )
                {
                    profile.wxcard_url = url[0];
                }
                else
                {
                    profile.wxcard_url = params[@"url"];
                }
                
                [profile save];
            }
        }
    }
}

@end
