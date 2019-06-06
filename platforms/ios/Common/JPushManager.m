//
//  JPushManager.m
//  Mata
//
//  Created by jimmy on 16/10/25.
//  Copyright © 2016年 Mata. All rights reserved.
//

#import "JPushManager.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "BSUpdatePersonalInfoRequest.h"
#import "BSSetDeviceTokenRequest.h"

static JPushManager* s_sharedManager = nil;

@implementation JPushManager

+ (JPushManager*)sharedManager
{
    @synchronized(s_sharedManager)
    {
        if (s_sharedManager == nil)
        {
            s_sharedManager = [[JPushManager alloc] init];
        }
    }
    
    return s_sharedManager;
}

- (void)sendRegistrationIDToServer
{
    PersonalProfile *myProfile = [PersonalProfile currentProfile];
    if ( myProfile && [myProfile.isLogin boolValue] && self.registrationID.length > 0 )
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        params[@"ds_jpush_registration_id"] = self.registrationID;
        params[@"ds_jpush_tags"] = myProfile.userID;
        params[@"uid"] = myProfile.userID;
        params[@"ds_jpush_alias"] = @"user";
        NSLog(@"%@",[[NSBundle mainBundle] bundleIdentifier]);
        params[@"package_name"] = [[NSBundle mainBundle] bundleIdentifier];

        BSSetDeviceTokenRequest* request = [[BSSetDeviceTokenRequest alloc] initWithParams:params];
        [request execute];
    }
}

@end
