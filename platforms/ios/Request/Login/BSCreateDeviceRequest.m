//
//  SACreateDeviceRequest.m
//  ShopAssistant
//
//  Created by jimmy on 15/3/16.
//  Copyright (c) 2015年 jimmy. All rights reserved.
//

#import "BSCreateDeviceRequest.h"
#import "NSData+Additions.h"
#import "BSLoginRequestStep2.h"

@interface BSCreateDeviceRequest ()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

@implementation BSCreateDeviceRequest

- (id)initWithUserName:(NSString *)username password:(NSString *)password
{
    self = [super init];
    if (self)
    {
        self.username = username;
        self.password = password;
    }
    
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    
    PersonalProfile *profile = [PersonalProfile currentProfile];
    
    NSString *cmd = [NSString stringWithFormat:@"%@%@", profile.baseUrl, @"/xmlrpc/2/ds_api"];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"name"] = [profile getUUID];
    NSString* deviceName = [UIDevice currentDevice].name;
    NSCharacterSet *filterSet = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\'\"\\|~(＜＞$%^&*)_+"];
    deviceName = [[deviceName componentsSeparatedByCharactersInSet:filterSet] componentsJoinedByString:@""];
    params[@"note"] = [NSString stringWithFormat:@"%@:%@",deviceName,self.username];
    params[@"login"] = self.username;
    NSData *userData = [[[PersonalProfile currentProfile] getUUID] dataUsingEncoding:NSUTF8StringEncoding];
    params[@"key"] = [userData md5Hash];
    
    NSString *jsonString = [BNXmlRpc jsonWithArray:@[profile.sql,@"",@"born.client.security",params]];
    NSString *xmlString = [BNXmlRpc xmlMethod:@"security_create" jsonString:jsonString];
    

    [self sendXmlCommand:cmd params:xmlString];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    NSNumber *result = (NSNumber *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    NSDictionary *retDict = (NSDictionary *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    
    if ([retDict isKindOfClass:[NSDictionary class]])
    {
        NSInteger errorCode = [[retDict numberValueForKey:@"errcode"] integerValue];
        NSString  *errorMsg = [retDict stringValueForKey:@"errmsg"];
        
        if (errorCode ==  0) {
            
            NSNumber *deviceId = [[retDict objectForKey:@"data"] objectForKey:@"id"];
            BSLoginRequestStep2 *request = [[BSLoginRequestStep2 alloc] initWithUserName:self.username password:self.password];
            request.deviceId = deviceId;
            [request execute];
        }
        else
        {
            dict = [self generateResponse:errorMsg];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSLoginResponse object:self userInfo:dict];
        }
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSLoginResponse object:self userInfo:dict];
    }
}

@end
