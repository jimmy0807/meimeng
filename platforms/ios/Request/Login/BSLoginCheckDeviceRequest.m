//
//  BSLoginCheckDeviceRequest.m
//  Boss
//
//  Created by lining on 15/3/31.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSLoginCheckDeviceRequest.h"
#import "PersonalProfile.h"
#import "BSLoginRequestStep3.h"
#import "BSCreateDeviceRequest.h"


@interface BSLoginCheckDeviceRequest ()
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) PersonalProfile *profile;
@end

@implementation BSLoginCheckDeviceRequest

-(id)initWithUserName:(NSString *)username passWord:(NSString *)password profile:(id)profile
{
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
        self.profile = profile;
    }
    return self;
}

-(BOOL)willStart
{
    NSString *cmd = [NSString stringWithFormat:@"%@%@",self.profile.baseUrl,@"/xmlrpc/2/object"];
    NSString *jsonString = [BNXmlRpc jsonWithArray:@[self.profile.sql,self.profile.userID,self.profile.deviceString,@"born.client.security",@"search_read",@[@[@"name",@"=",[self.profile getUUID]]],@[@"id",@"state"]]];
    NSString *xmlString = [BNXmlRpc xmlMethod:@"execute" jsonString:jsonString];
    
    [self sendXmlCommand:cmd params:xmlString];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    
    if (resultArray.count != 0)
    {
        NSDictionary* params = resultArray[0];
        if ([params[@"state"] isEqualToString:@"approved"])
        {
            [ICKeyChainManager setCurrentServiceName:[self.profile.userID stringValue]];
            [ICKeyChainManager storeUsername:USER_Name andPassword:self.username];
            [ICKeyChainManager storeUsername:USER_PASSWORD andPassword:self.password];
            
            BSLoginRequestStep3 *request = [[BSLoginRequestStep3 alloc] init];
            [request execute];
        }
        else
        {
            BSCreateDeviceRequest *request = [[BSCreateDeviceRequest alloc] initWithUserName:self.username password:self.password];
            [request execute];
            
            [dict setValue:[NSNumber numberWithBool:NO] forKey:@"rc"];
            [dict setValue:@"这台设备还未通过审核,请让管理员到OE后台通过审核" forKey:@"rm"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSLoginResponse object:self userInfo:dict];
        }
    }
    else
    {
        BSCreateDeviceRequest *request = [[BSCreateDeviceRequest alloc] initWithUserName:self.username password:self.password];
        [request execute];
        
        [dict setValue:@(-1) forKey:@"rc"];
        [dict setValue:@"用户名或密码错误" forKey:@"rm"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSLoginResponse object:self userInfo:dict];
    }
}

@end
