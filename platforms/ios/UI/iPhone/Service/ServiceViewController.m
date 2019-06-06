
//
//  ServiceViewController.m
//  Boss
//
//  Created by jimmy on 15/5/21.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ServiceViewController.h"
#import "CBWebViewController.h"
#import "NSData+Additions.h"
#import "FetchCompanyUUIDRequest.h"

@interface ServiceViewController ()
@property(nonatomic, strong)CBWebViewController* webViewController;
@property(nonatomic, strong)NSString* targetUrl;
@end

@implementation ServiceViewController

- (void)viewDidLoad
{
    [self registerNofitificationForMainThread:kFetchCompanyUUIDResponse];
    [super viewDidLoad];
}

- (void)initWebView
{
    PersonalProfile* profile = [PersonalProfile currentProfile];
    
    if ( !self.targetUrl && profile.isLogin )
    {
        if (profile.companyUUID == nil)
        {
            NSLog(@"没有companyUUID");
            FetchCompanyUUIDRequest *req = [[FetchCompanyUUIDRequest alloc] init];
            [req execute];
        }
        else
        {

            self.targetUrl = [NSString stringWithFormat:@"%@/bornservice?born_uuid=%@&phone=%@",SERVER_IP,profile.companyUUID,profile.userName];
            
            self.webViewController = [[CBWebViewController alloc] initWithUrl:self.targetUrl];
            self.webViewController.tabbar = self;
            [self.view addSubview:self.webViewController.view];
            self.webViewController.view.frame = self.view.bounds;
        }
    }
    else if ( self.targetUrl && ![self.webViewController isLoadFinished])
    {
        [self.webViewController reload];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.navigationItem.title = @"服务";
    [self initWebView];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.webViewController refreshNaviLeftBarButton];
    [super viewDidAppear:animated];
}

#pragma mark - DidReceivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([[notification.userInfo stringValueForKey:@"rc"] integerValue] == 0)
    {
        PersonalProfile* profile = [PersonalProfile currentProfile];

        self.targetUrl = [NSString stringWithFormat:@"%@/bornservice?born_uuid=%@&phone=%@",SERVER_IP,profile.companyUUID,profile.userName];
        self.webViewController.url = self.targetUrl;
        [self.webViewController reload];
    }
}

@end
