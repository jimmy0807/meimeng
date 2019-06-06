/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  ds
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "PersonalProfile.h"
#import "LoginScrollViewController.h"
#import "ICKeyChainManager.h"
#import "BSCoreDataManager.h"
#import "BSUserDefaultsManager.h"
#import "UINavigationBar+Background.h"
#import "CBRotateNavigationController.h"
#import "HomeTabController.h"

#import "HomeViewController.h"
#import "SettingViewController.h"
#import "ServiceViewController.h"
#import "SupplierViewController.h"

#import "BossPermissionManager.h"
#import "BSLoginRequestStep3.h"
#import "BSLoginRequestStep2.h"

#import "VUtil.h"
#import "HomeCountDataManager.h"
#import "BSSetDeviceTokenRequest.h"
#import "BNCheckNewVersionManager.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"

#import "PadLoginViewController.h"
#import "PadHomeViewController.h"

#import "CBLoadingView.h"
#import "BSPadDataRequest.h"
#import "PayBankManager.h"
#import "PosMachineManager.h"
#import "JPushManager.h"
#import "BSUpdatePersonalInfoRequest.h"
#import "BSPrintPosOperateRequestNew.h"
#import "BSFetchPrinterStatusRequest.h"
#import "BSPrintOpenCashBoxRequest.h"
#import "BSfetchPrinterScannerRequest.h"
#import "BSFetchStartInfoRequest.h"
#import "PadPicHomeViewController.h"
#import <Bugly/Bugly.h>
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#ifdef meim_dev
#import "meim_dev-Swift.h"
#else
#import "meim-Swift.h"
#endif

#import "ResetIPManager.h"

@interface AppDelegate()
@property(copy,nonatomic)NSTimer *connectDeviceTimer;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    
    [ResetIPManager sharedInstance];
    
    //[[[BSPrintPosOperateRequestNew alloc] init] execute];
    
    //[[[BSFetchPrinterStatusRequest alloc] init] execute];
    //[[[BSPrintOpenCashBoxRequest alloc] init] execute];

    [Bugly startWithAppId:@"410ce65d8b"];

    NSString *cachePath = [VUtil cachePath];
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes: nil error: nil];
    }
    
    if ( DEVICE_IS_IPAD )
    {
        [[[BSfetchPrinterScannerRequest alloc] init] execute];
        
        //[PosMachineManager sharedManager];
        [BossPermissionManager sharedManager];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
        BOOL bFetchUserInfo = FALSE;
        PersonalProfile *myProfile = [PersonalProfile currentProfile];
        if ( myProfile && [myProfile.isLogin boolValue] && [BSUserDefaultsManager sharedManager].rememberPassword )
        {
            [ICKeyChainManager setCurrentServiceName:[myProfile.userID stringValue]];
            [BSCoreDataManager setCurrentUserName:[NSString stringWithFormat:@"%@%@",myProfile.userID,myProfile.sql]];
            
            bFetchUserInfo = TRUE;
        }
        
        CBRotateNavigationController *naviController = nil;
        PadPicHomeViewController * centerViewController = [[PadPicHomeViewController alloc] initWithNibName:@"PadPicHomeViewController" bundle:nil];
        PadSideBarViewController * leftSiderViewController = [[PadSideBarViewController alloc] initWithDelegate:nil];
        
        naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
        [naviController setNavigationBarHidden:YES animated:NO];
        
        MMDrawerController * drawerController = [[MMDrawerController alloc]
                                                 initWithCenterViewController:naviController
                                                 leftDrawerViewController:leftSiderViewController
                                                 rightDrawerViewController:nil];
        
        drawerController.shouldStretchDrawer = NO;
        [drawerController setMaximumLeftDrawerWidth:300];
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible)
         {
             MMDrawerControllerDrawerVisualStateBlock block;
             block = [[MMExampleDrawerVisualStateManager sharedManager] drawerVisualStateBlockForDrawerSide:drawerSide];
             if(block)
             {
                 block(drawerController, drawerSide, percentVisible);
             }
         }];
        self.window.rootViewController = drawerController;
        
        
        BOOL isRememberPassword = [BSUserDefaultsManager sharedManager].rememberPassword;
        NSString *passwordKey = GestureUnlockPassword([myProfile.userID stringValue]);
        NSString *gesturePassword = [ICKeyChainManager getPasswordForUsername:passwordKey];
        BOOL shouldLogout = [self shouldAutoLogout];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeHome:) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
        if ([ICKeyChainManager getCurrentServiceName].length != 0 && isRememberPassword && gesturePassword.length != 0 && !shouldLogout )
        {
            GestureUnlockView *gestureUnlockView = [[GestureUnlockView alloc] initWithGestureUnlockType:GestureUnlockType_Login];
            gestureUnlockView.tag = kGestureUnlockViewTag;
            gestureUnlockView.delegate = self;
            [[[UIApplication sharedApplication] keyWindow] addSubview:gestureUnlockView];
            
            if ( bFetchUserInfo )
            {
                BSLoginRequestStep3 *request = [[BSLoginRequestStep3 alloc] init];
                [request execute];
            }
        }
        else
        {
            if ( shouldLogout )
            {
                UIAlertView *v = [[UIAlertView alloc] initWithTitle:nil message:@"距离您上次登录已经12个小时,请重新登录" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [v show];
            }
            PadLoginViewController *padLoginVC = [[PadLoginViewController alloc] initWithNibName:@"PadLoginViewController" bundle:nil];
            CBRotateNavigationController *loginNav = [[CBRotateNavigationController alloc] initWithRootViewController:padLoginVC];
            [loginNav.navigationBar setCustomizedNaviBar:YES];
            if (IS_SDK8)
            {
                [naviController.view addSubview:loginNav.view];
            }
            
            [naviController presentViewController:loginNav animated:NO completion:nil];
        }
        
        [[BNCheckNewVersionManager sharedManager] fetchServerVersion];
#if !TARGET_IPHONE_SIMULATOR
        // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //可以添加自定义categories
            //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
            //      NSSet<UNNotificationCategory *> *categories;
            //      entity.categories = categories;
            //    }
            //    else {
            //      NSSet<UIUserNotificationCategory *> *categories;
            //      entity.categories = categories;
            //    }
        }
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        
        // 3.0.0以前版本旧的注册方式
        //  if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        //    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        //    entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        //    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        //#endif
        //  } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //      //可以添加自定义categories
        //      [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
        //                                                        UIUserNotificationTypeSound |
        //                                                        UIUserNotificationTypeAlert)
        //                                            categories:nil];
        //  } else {
        //      //categories 必须为nil
        //      [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
        //                                                        UIRemoteNotificationTypeSound |
        //                                                        UIRemoteNotificationTypeAlert)
        //                                            categories:nil];
        //  }
        NSString *appKey = @"cfae909b03f61b27f0ca1ff1";
        if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.born.boss"])
        {
            appKey = @"b2be608652debfebfa2dcb38";
        }
        //如不需要使用IDFA，advertisingIdentifier 可为nil
        [JPUSHService setupWithOption:launchOptions appKey:appKey
                              channel:@"AppStore"
                     apsForProduction:TRUE
                advertisingIdentifier:nil];
        [JPUSHService setDebugMode];
        //2.1.9版本新增获取registration id block接口。
        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
            if(resCode == 0){
                [JPushManager sharedManager].registrationID = registrationID;
                [[JPushManager sharedManager] sendRegistrationIDToServer];
            }
            else{
                NSLog(@"registrationID获取失败，code：%d",resCode);
            }
        }];
#endif
    }
    else
    {
        if ([PersonalProfile currentProfile].isLogin) {
            BSLoginRequestStep3 *request = [[BSLoginRequestStep3 alloc] init];
            [request execute];
        }
        
        self.viewController = [[MainViewController alloc] init];
        
        return [super application:application didFinishLaunchingWithOptions:launchOptions];
    }
    
    ///TODO: 连接写字本（自动连接默认设备 保存在UserDefault中的）
    [self autoConnectDefaultInkDevice];
    
    return YES;
}

#pragma mark -
#pragma mark GestureUnlockViewDelegate Methods
- (void)gestureUnlockSuccess:(GestureUnlockView *)gestureUnlockView
{
    if ( DEVICE_IS_IPAD )
    {
        [[BSPadDataRequest sharedInstance] startDataRequest];
        BSFetchStartInfoRequest *request = [[BSFetchStartInfoRequest alloc] init];
        [request execute];
    }
    
}

- (void)gestureUnlockFailed:(GestureUnlockView *)gestureUnlockView
{
    CBRotateNavigationController *rootViewController = (CBRotateNavigationController *)self.window.rootViewController;
    // iOS6之前
    //if ([rootViewController modalViewController] != nil)
    //{
    //    [[rootViewController modalViewController] dismissModalViewControllerAnimated:NO];
    //}
    if ([rootViewController presentedViewController] != nil)
    {
        [[rootViewController presentedViewController] dismissViewControllerAnimated:NO completion:nil];
    }
    
    UIViewController* v;
    if ( DEVICE_IS_IPAD )
    {
        v = [[PadLoginViewController alloc] initWithNibName:@"PadLoginViewController" bundle:nil];
    }
    else
    {
        v = [[LoginScrollViewController alloc] initWithNibName:NIBCT(@"LoginScrollViewController") bundle:nil];
    }
    
    CBRotateNavigationController *loginNav = [[CBRotateNavigationController alloc] initWithRootViewController:v];
    [loginNav.navigationBar setCustomizedNaviBar:YES];
    
    if (IS_SDK8)
    {
        [rootViewController.view addSubview:loginNav.view];
    }
    [rootViewController presentViewController:loginNav animated:NO completion:nil];
}

- (void)gestureUnlockForgetGesture:(GestureUnlockView *)gestureUnlockView
{
    CBRotateNavigationController *rootViewController = (CBRotateNavigationController *)self.window.rootViewController;
    // iOS6之前
    //if ([rootViewController modalViewController] != nil)
    //{
    //    [[rootViewController modalViewController] dismissModalViewControllerAnimated:NO];
    //}
    if ([rootViewController presentedViewController] != nil)
    {
        [[rootViewController presentedViewController] dismissViewControllerAnimated:NO completion:nil];
    }
    
    UIViewController* v;
    if ( DEVICE_IS_IPAD )
    {
        v = [[PadLoginViewController alloc] initWithNibName:@"PadLoginViewController" bundle:nil];
    }
    else
    {
        v = [[LoginScrollViewController alloc] initWithNibName:NIBCT(@"LoginScrollViewController") bundle:nil];
    }
    
    CBRotateNavigationController *loginNav = [[CBRotateNavigationController alloc] initWithRootViewController:v];
    [loginNav.navigationBar setCustomizedNaviBar:YES];
    
    if (IS_SDK8)
    {
        [rootViewController.view addSubview:loginNav.view];
    }
    [rootViewController presentViewController:loginNav animated:NO completion:nil];
}

- (void)gestureUnlockChangeAccount:(GestureUnlockView *)gestureUnlockView
{
    CBRotateNavigationController *rootViewController = (CBRotateNavigationController *)self.window.rootViewController;
    // iOS6之前
    //if ([rootViewController modalViewController] != nil)
    //{
    //    [[rootViewController modalViewController] dismissModalViewControllerAnimated:NO];
    //}
    if ([rootViewController presentedViewController] != nil)
    {
        [[rootViewController presentedViewController] dismissViewControllerAnimated:NO completion:nil];
    }
    
    UIViewController* v;
    if ( DEVICE_IS_IPAD )
    {
        v = [[PadLoginViewController alloc] initWithNibName:@"PadLoginViewController" bundle:nil];
    }
    else
    {
        v = [[LoginScrollViewController alloc] initWithNibName:NIBCT(@"LoginScrollViewController") bundle:nil];
    }
    
    CBRotateNavigationController *loginNav = [[CBRotateNavigationController alloc] initWithRootViewController:v];
    [loginNav.navigationBar setCustomizedNaviBar:YES];
    
    if (IS_SDK8)
    {
        [rootViewController.view addSubview:loginNav.view];
    }
    [rootViewController presentViewController:loginNav animated:NO completion:nil];
}

#pragma mark -
#pragma mark PushNotification
static NSString *pushStatus ()
{
    return [[UIApplication sharedApplication] enabledRemoteNotificationTypes] ?
    @"Notifications were active for this application" :
    @"Remote notifications were not active for this application";
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSMutableString* tokenString = [NSMutableString stringWithFormat:@"%@", deviceToken];
    [tokenString replaceOccurrencesOfString: @"<" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [tokenString length])];
    [tokenString replaceOccurrencesOfString: @">" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [tokenString length])];
    [tokenString replaceOccurrencesOfString: @" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [tokenString length])];
    NSLog(@"== device token string: %@", tokenString);
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *identifier = [infoDict objectForKey:@"CFBundleIdentifier"];
    
    if ( [identifier isEqualToString:@"com.born-innovative.boss"] )
    {
        BSSetDeviceTokenRequest* request = [[BSSetDeviceTokenRequest alloc] initWithToken:[NSString stringWithFormat:@"B%@",tokenString]];
        [request execute];
    }
    else
    {
        BSSetDeviceTokenRequest* request = [[BSSetDeviceTokenRequest alloc] initWithToken:[NSString stringWithFormat:@"C%@",tokenString]];
        [request execute];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *status = [NSString stringWithFormat:@"%@\nRegistration failed.\n\nError: %@", pushStatus(), [error localizedDescription]];
    NSLog(@"%@",status);
    NSLog(@"Error in registration. Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Push Notification: %@", userInfo);
}

// 2017年09月27日14:39:55  宋海斌 注释原因  此处会导致 微信支付结果无法正常返回
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    if ( [url.scheme isEqualToString:@"boss"] ) //weika://a?b  scheme:weika host:a query:b
//    {
//        return YES;
//    }
//    else if ([url.scheme isEqualToString:@"wx3e18cef36f359534"])
//    {
//        [[WeixinManager shareManager] handleOpenURL:url];
//    }
//    else if ([url.scheme isEqualToString:@"AlipayBoss"])
//    {
//        [[ICAlipayManager sharedManager] handleOpenURL:url];
//    }
//    else if ([url.scheme isEqualToString:@"PosBoss"])
//    {
//        [[PayBankManager sharedManager] handleOpenURL:url];
//    }
//
//    return YES;
//}

- (void)clearCahce
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //[JPUSHService resetBadge];
    
    if ( DEVICE_IS_IPAD )
    {
        //[[PosMachineManager sharedManager] disConnectSwipeCard];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WillResignActive" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ( DEVICE_IS_IPAD )
    {
        //[[PosMachineManager sharedManager] connectPosMachine];
        //[[PosMachineManager sharedManager] connectSwipeCard];
    }
    
    [[ResetIPManager sharedInstance] reload];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidBecomeActive" object:nil];
    [[CBLoadingView shareLoadingView] hide];
}

- (BOOL)shouldAutoLogout
{
    if ( [[PersonalProfile currentProfile].isLogin boolValue] )
    {
        if ( [[NSDate date] timeIntervalSinceDate:[PersonalProfile currentProfile].loginDate] >= 3600 * 12
            )
        {
            [PersonalProfile deleteProfile];
            return TRUE;
        }
    }
    
    return FALSE;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if ( [self shouldAutoLogout] )
    {
        CBRotateNavigationController *rootViewController = (CBRotateNavigationController *)self.window.rootViewController;
        if ([rootViewController presentedViewController] != nil)
        {
            [[rootViewController presentedViewController] dismissViewControllerAnimated:NO completion:nil];
        }
        
        UIViewController* v;
        if ( DEVICE_IS_IPAD )
        {
            v = [[PadLoginViewController alloc] initWithNibName:@"PadLoginViewController" bundle:nil];
        }
        else
        {
            v = [[LoginScrollViewController alloc] initWithNibName:NIBCT(@"LoginScrollViewController") bundle:nil];
        }
        
        CBRotateNavigationController *loginNav = [[CBRotateNavigationController alloc] initWithRootViewController:v];
        [loginNav.navigationBar setCustomizedNaviBar:YES];
        
        if (IS_SDK8)
        {
            [rootViewController.view addSubview:loginNav.view];
        }
        [rootViewController presentViewController:loginNav animated:NO completion:nil];
        
        UIAlertView *v2 = [[UIAlertView alloc] initWithTitle:nil message:@"距离您上次登录已经12个小时,请重新登录" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [v2 show];
    }
}

//<<<<<<< HEAD
- (void)comeHome:(UIApplication *)application {
    NSLog(@"进入后台");
}

- (void)applicationWillTerminate:(UIApplication *)application {
//    [PersonalProfile deleteProfile];
//    [BSUserDefaultsManager sharedManager].rememberPassword = NO;
    NSLog(@"程序被杀死");
    [[[BSWILLManager shared] connectingInkDevice] close];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hasStepFirstConnected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//=======
-(void)autoConnectDefaultInkDevice {
    
    ///注册连接失败通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectDeviceCatch) name:@"connectDeviceCatchNotiName" object:nil];
    
    NSString *inkDeviceName = [[NSUserDefaults standardUserDefaults] stringForKey:@"InkDeviceName"];
    
    if (inkDeviceName != nil) {
        //self.perform(#selector(connectDefaultDeviceTask), with: self, afterDelay: 0.5)
        [self performSelector:@selector(connectDefaultDeviceTask) withObject:nil afterDelay:0.5];
    
    }
}

-(void)connectDeviceCatch {
    
    NSString *inkDeviceName = [[NSUserDefaults standardUserDefaults] stringForKey:@"InkDeviceName"];
    
    if (inkDeviceName != nil) {
        NSLog(@"connectDeviceCatch");
        [[PersisitentTool shared] connect];
    }
}

-(void)connectDefaultDeviceTask {

    [self connectDeviceCatch];
}

//>>>>>>> inkDevice_branch
@end
