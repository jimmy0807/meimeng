//
//  LoginViewController.m
//  Boss
//
//  Created by lining on 15/3/30.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "LoginViewController.h"
#import "CBBackButtonItem.h"
#import "BSLoginRequest.h"
#import "NSObject+MainThreadNotification.h"
#import "CBLoadingView.h"
#import "UIImage+Resizable.h"
#import "BSUserDefaultsManager.h"
#import "GestureUnlockViewController.h"
#import "CBWebViewController.h"
#import "BSCreateDeviceRequest.h"

@interface LoginViewController ()<CBWebViewControllerDelegate>
{
    BOOL isRememberPw;
}
@property(nonatomic,strong) CBLoadingView *loadingView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *backBtn = [[CBBackButtonItem alloc] initWithTitle:@""];
    backBtn.delegate = self;
    self.navigationItem.leftBarButtonItem = backBtn;
    
    isRememberPw  = [BSUserDefaultsManager sharedManager].rememberPassword;
    self.pwImgView.highlighted = isRememberPw;
    
    self.navigationItem.title = LS(@"login");
//    self.userTextField.text = @"13912345678"; //收银员:13522223333 //经理:13912345678
//    self.pswTextField.text = @"123456";
#ifdef BossTest
    self.userTextField.text = @"13700000001"; //收银员:13522223333  //经理:13912345678
    self.pswTextField.text = @"123456";
#endif
    self.userTextBg.image = [[UIImage imageNamed:@"login_userText"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 50, 10, 10)];
    self.pwTextBg.image = [[UIImage imageNamed:@"login_pwText.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 50, 10, 10)];
    
    self.view.backgroundColor = COLOR(237,237,243, 1);
    [self registerNofitificationForMainThread:kBSLoginResponse];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action

- (IBAction)loginBtnPressed:(id)sender
{
    if (self.userTextField.text == nil || self.pswTextField.text == nil)
    {
        return;
    }
    
    /*
     
     V9N00000060 http:// 
     V9N00000059 http://ds.mega.wang
     V9N00000080 http://ds.xyam999.com
     
     https://www.pgyer.com/xinzhuiguoji
     https://www.pgyer.com/mega
     https://www.pgyer.com/bornxyam
     
     */
    
    self.loadingView = [CBLoadingView shareLoadingView];
    [self.loadingView show];
//    BSLoginRequest *req = [[BSLoginRequest alloc] initWithUserName:self.userTextField.text password:self.pswTextField.text];
//    [req execute];
    PersonalProfile *profile = [[PersonalProfile alloc] init];
    profile.baseUrl = @"http://ds.mega.wang";
    profile.sql = @"V9N00000059";
    profile.born_uuid = @"born_uuid";
    [profile save];
    
    BSCreateDeviceRequest *request = [[BSCreateDeviceRequest alloc] initWithUserName:self.userTextField.text password:self.pswTextField.text];
    [request execute];
}

- (IBAction)registerBtnPressed:(id)sender
{
    CBWebViewController* webViewController = [[CBWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@%@",SERVER_IP,@"/site/register_mobile"]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)didObserveSchemeFind:(NSURLRequest*)request
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.view.window endEditing:YES];
}

- (IBAction)rememberPw:(id)sender {
    self.pwImgView.highlighted = !self.pwImgView.highlighted;
    isRememberPw = self.pwImgView.highlighted;
}

#pragma mark - received notification method

- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSLoginResponse]) {
        if (self.loadingView)
        {
            [self.loadingView hide];
        }
        
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            if (isRememberPw)
            {
                NSString *passwordKey = GestureUnlockPassword([[PersonalProfile currentProfile].userID stringValue]);
                NSString *keychainString = [ICKeyChainManager getPasswordForUsername:passwordKey];
                if (keychainString.length == 0)
                {
                    GestureUnlockViewController *gestureUnlockVC = [[GestureUnlockViewController alloc] initWithNibName:NIBCT(@"GestureUnlockViewController") bundle:nil];
                    gestureUnlockVC.type = GestureUnlockType_AddPW_First;
                    gestureUnlockVC.delegate = self;
                    [self.navigationController pushViewController:gestureUnlockVC animated:YES];
                }
                else
                {
                    [BSUserDefaultsManager sharedManager].rememberPassword = YES;
                    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
            else
            {
                [BSUserDefaultsManager sharedManager].rememberPassword = NO;
                self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else
        {
            NSString *message = [notification.userInfo objectForKey:@"rm"];
            UIAlertView* view = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [view show];
        }
    }
}

#pragma mark -
#pragma mark GestureUnlockViewControllerDelegate Methods

- (void)passStep:(GestureUnlockViewController *)gestureUnlockVC
{
    [BSUserDefaultsManager sharedManager].rememberPassword = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addGestureSuccess:(GestureUnlockViewController *)gestureUnlockVC
{
    [BSUserDefaultsManager sharedManager].rememberPassword = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
