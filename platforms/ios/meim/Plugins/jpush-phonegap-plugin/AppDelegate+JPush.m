//
//  AppDelegate+JPush.m
//  delegateExtention
//
//  Created by 张庆贺 on 15/8/3.
//  Copyright (c) 2015年 JPush. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "JPushPlugin.h"
#import <objc/runtime.h>
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>
#import "JPushDefine.h"

@implementation AppDelegate (JPush)

+(void)load{
    Method origin1;
    Method swizzle1;
    origin1  = class_getInstanceMethod([self class],@selector(init));
    swizzle1 = class_getInstanceMethod([self class], @selector(init_plus));
    method_exchangeImplementations(origin1, swizzle1);
}

#if !TARGET_IPHONE_SIMULATOR

-(instancetype)init_plus{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidLaunch:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    return [self init_plus];
}

-(void)applicationDidLaunch:(NSNotification *)notification{
    if (notification) {
        if (notification.userInfo) {
            NSDictionary *userInfo1 = [notification.userInfo valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            if (userInfo1.count > 0) {
                [SharedJPushPlugin jpushFireDocumentEvent:JPushDocumentEvent_OpenNotification jsString:[userInfo1 toJsonString]];
            }
            NSDictionary *userInfo2 = [notification.userInfo valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
            if (userInfo2.count > 0) {
                [SharedJPushPlugin jpushFireDocumentEvent:JPushDocumentEvent_StartLocalNotification jsString:[userInfo1 toJsonString]];
            }
        }
        [JPUSHService setDebugMode];
        [self registerForRemoteNotification];
        [JPushPlugin setupJPushSDK:notification.userInfo];
    }
}

-(void)registerForRemoteNotification{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else if([[UIDevice currentDevice].systemVersion floatValue] < 8.0){
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [JPUSHService handleRemoteNotification:userInfo];

    [SharedJPushPlugin jpushFireDocumentEvent:JPushDocumentEvent_ReceiveNotification jsString:[userInfo toJsonString]];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [JPUSHService handleRemoteNotification:userInfo];
    NSString *eventName;
    switch ([UIApplication sharedApplication].applicationState) {
        case UIApplicationStateInactive:
            eventName = JPushDocumentEvent_OpenNotification;
            break;
        case UIApplicationStateActive:
            eventName = JPushDocumentEvent_ReceiveNotification;
            break;
        case UIApplicationStateBackground:
            eventName = JPushDocumentEvent_BackgroundNotification;
            break;
        default:
            break;
    }
    [SharedJPushPlugin jpushFireDocumentEvent:eventName jsString:[userInfo toJsonString]];
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSString* type = userInfo[@"k"];
    
    if ( [type isEqualToString:@"new_order"] )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshPadHome object:nil userInfo:nil];
    }
    else if ( [type isEqualToString:@"new_medical_record"] )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshHospitalMain object:nil userInfo:nil];
    }
    else if ( [type isEqualToString:@"event-nine"] )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGoH9Notify object:nil userInfo:nil];
    }
    
    completionHandler(0);
}

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:notification.request.content.userInfo];
    [SharedJPushPlugin jpushFireDocumentEvent:JPushDocumentEvent_ReceiveNotification jsString:[userInfo toJsonString]];
    
    NSString* type = userInfo[@"k"];
    if ( [type isEqualToString:@"new_order"] )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshPadHome object:nil userInfo:nil];
    }
    else if ( [type isEqualToString:@"new_medical_record"] )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshHospitalMain object:nil userInfo:nil];
    }
    else if ( [type isEqualToString:@"event-nine"] )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:userInfo[@"v"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去看看",nil];
        [v show];
    }
    
    completionHandler(0);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGoH9Notify object:nil userInfo:nil];
    }
}

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:response.notification.request.content.userInfo];
    @try {
        [userInfo setValue:[response valueForKey:@"userText"] forKey:@"userText"];
    } @catch (NSException *exception) { }
    [userInfo setValue:response.actionIdentifier forKey:@"actionIdentifier"];
    [SharedJPushPlugin jpushFireDocumentEvent:JPushDocumentEvent_OpenNotification jsString:[userInfo toJsonString]];
    
    NSString* type = userInfo[@"k"];
    
    if ( [type isEqualToString:@"new_order"] )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshPadHome object:nil userInfo:nil];
    }
    else if ( [type isEqualToString:@"new_medical_record"] )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshHospitalMain object:nil userInfo:nil];
    }
    else if ( [type isEqualToString:@"event-nine"] )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGoH9Notify object:nil userInfo:nil];
    }
    
    completionHandler(0);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:JPushDocumentEvent_ReceiveLocalNotification object:notification.userInfo];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //  [application setApplicationIconBadgeNumber:0];
    //  [application cancelAllLocalNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#endif

@end
