//
//  BSLoginRequestStep2.m
//  Boss
//
//  Created by lining on 15/3/31.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSLoginRequestStep2.h"
#import "PersonalProfile.h"
#import "BSCoreDataManager.h"
#import "BSLoginRequestStep3.h"
#import "NSData+Additions.h"
#import "JPushManager.h"

@interface BSLoginRequestStep2 ()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

@implementation BSLoginRequestStep2
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
    
    PersonalProfile *profile = [PersonalProfile currentProfile];
    NSString *cmd = [NSString stringWithFormat:@"%@%@",profile.baseUrl,@"/xmlrpc/2/ds_api"];
    
    NSString *signstr = [NSString stringWithFormat:@"login=%@password=%@%@", self.username, self.password, profile.getMD5ForUUID];
    NSString *sign = [[signstr dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
    NSString *jsonString = [BNXmlRpc jsonWithArray:@[profile.sql,self.username,self.password,@{@"client_id":self.deviceId,@"sign":sign}]];
    NSString *xmlString = [BNXmlRpc xmlLoginWithJsonString:jsonString];
    
    [self sendXmlCommand:cmd params:xmlString];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSDictionary *retDict = (NSDictionary*)[BNXmlRpc arrayWithXmlRpc:resultStr];
    
    if ( [retDict isKindOfClass:[NSDictionary class]])
    {
        int errCode = [[retDict numberValueForKey:@"errcode"] integerValue];
        NSString *errMsg = [retDict stringValueForKey:@"errmsg"];
        if (errCode == 0) {
            NSNumber *uid = [[retDict objectForKey:@"data"] numberValueForKey:@"uid"];
            NSString *token = [[retDict objectForKey:@"data"] stringValueForKey:@"access_token"];
            
            PersonalProfile *profile = [PersonalProfile currentProfile];
            profile.userID = uid;
            profile.token = token;
            profile.userName = self.username;
            profile.password = self.password;
            profile.deviceString = [self.deviceId stringValue];
            profile.loginDate = [NSDate date];
            [profile save];
            
            [ICKeyChainManager setCurrentServiceName:[profile.userID stringValue]];
            [ICKeyChainManager storeUsername:USER_Name andPassword:self.username];
            [ICKeyChainManager storeUsername:USER_PASSWORD andPassword:self.password];
            [BSCoreDataManager setCurrentUserName:[NSString stringWithFormat:@"%@%@",profile.userID,profile.sql]];
            
            BSLoginRequestStep3 *request = [[BSLoginRequestStep3 alloc] init];
            request.isLogin = TRUE;
            [request execute];
            
            if ( IS_IPAD )
            {
                [[JPushManager sharedManager] sendRegistrationIDToServer];
            }
        }
        //9月份修改登录 进入这里说明用户已经存在 是密码输错了或者其他错误
        else if (errCode == 1)
        {
            dict = [self generateResponse:errMsg andErrorRet:1];
            NSLog(@"登陆错误处理dict:%@",dict);
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSLoginResponse object:self userInfo:dict];
        }
        else
        {
            dict = [self generateResponse:errMsg];
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
