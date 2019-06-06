//
//  BSLoginRequest.m
//  Boss
//
//  Created by lining on 15/3/31.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSLoginRequest.h"
#import "PersonalProfile.h"
#import "NSArray+JSON.h"
#import "ICRequestManager.h"
#import "ICKeyChainManager.h"
#import "BSCoreDataManager.h"
#import "BSCreateDeviceRequest.h"
#import "BNXmlRpc.h"

@interface BSLoginRequest ()

@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *password;

@end

@implementation BSLoginRequest
-(id)initWithUserName:(NSString *)username password:(NSString *)password
{
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
    }
    return self;
}

-(BOOL)willStart
{
    [super willStart];
    
    NSString *cmd =  cmd = [NSString stringWithFormat:@"%@%@", SERVER_IP ,@"/xmlrpc/2/ds_api"];

    NSString *jsonStr = [BNXmlRpc jsonWithArray:@[@[self.username]]];
    NSString *xmlStr = [BNXmlRpc xmlMethod:@"server_url" jsonString:jsonStr];
    [self sendXmlCommand:cmd params:xmlStr];
    
    return true;
}


- (void)didFinishOnMainThread
{
    NSMutableDictionary *dict;//这里不用初始化
    NSDictionary *retDict = (NSDictionary *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    
    if ([retDict isKindOfClass:[NSDictionary class]])
    {
        NSNumber *errorRet = [retDict numberValueForKey:@"errcode"];
        NSString *errorMsg = [retDict stringValueForKey:@"errmsg"];
        [dict setValue:[NSNumber numberWithBool:YES] forKey:@"rc"];
        [dict setValue:errorMsg forKey:@"rm"];
        if (errorRet.integerValue == 0)
        {
            NSArray *resultArray = [retDict arrayValueForKey:@"data"];
            NSLog(@"%@",resultArray);
            PersonalProfile *profile = [[PersonalProfile alloc] init];
            profile.baseUrl = resultArray[0];
            profile.sql = resultArray[1];
            profile.born_uuid = resultArray[2];
            [profile save];
            
            BSCreateDeviceRequest *request = [[BSCreateDeviceRequest alloc] initWithUserName:self.username password:self.password];
            [request execute];
        }
        else if (errorRet.integerValue == 1)
        {
            dict = [self generateResponse:errorMsg andErrorRet:1];
            NSLog(@"登陆错误处理dict:%@",dict);
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSLoginResponse object:self userInfo:dict];
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
