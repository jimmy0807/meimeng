//
//  GestureUnlockViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/3/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "GestureUnlockViewController.h"
#import "CBRotateNavigationController.h"
#import "CBMessageView.h"
#import "LoginViewController.h"
#import "SettingViewController.h"

@interface GestureUnlockViewController ()

@end

@implementation GestureUnlockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = LS(@"SetGestureLockPassword");
    
    [self forbidSwipGesture];
    
    GestureUnlockView *gestureUnlockView = [[GestureUnlockView alloc] initWithGestureUnlockType:self.type];
    gestureUnlockView.delegate = self;
    [self.view addSubview:gestureUnlockView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didItemBackButtonPressed:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(passStep:)])
    {
        [self.delegate passStep:self];
    }
    
    if (self.type == GestureUnlockType_SetPW_First || self.type == GestureUnlockType_SetPW_Second)
    {
        for (UIViewController *viewController in [self.navigationController viewControllers])
        {
            if ([viewController isKindOfClass:[SettingViewController class]])
            {
                SettingViewController *settingVC = (SettingViewController *)viewController;
//                [settingVC.settingTableView reloadData];
                [self.navigationController popToViewController:settingVC animated:YES];
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didBackButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(passStep:)])
    {
        [self.delegate passStep:self];
    }
    
    if (self.type == GestureUnlockType_SetPW_First || self.type == GestureUnlockType_SetPW_Second)
    {
        for (UIViewController *viewController in [self.navigationController viewControllers])
        {
            if ([viewController isKindOfClass:[SettingViewController class]])
            {
                SettingViewController *settingVC = (SettingViewController *)viewController;
//                [settingVC.settingTableView reloadData];
                [self.navigationController popToViewController:settingVC animated:YES];
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark GestureUnlockViewDelegate Methods

- (void)gestureUnlockCancel:(GestureUnlockView *)gestureUnlockView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(passStep:)])
    {
        [self.delegate passStep:self];
    }
    
    if (self.type == GestureUnlockType_SetPW_First || self.type == GestureUnlockType_SetPW_Second)
    {
        for (UIViewController *viewController in [self.navigationController viewControllers])
        {
            if ([viewController isKindOfClass:[SettingViewController class]])
            {
                SettingViewController *settingVC = (SettingViewController *)viewController;
//                [settingVC.settingTableView reloadData];
                [self.navigationController popToViewController:settingVC animated:YES];
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)gestureUnlockPassStep:(GestureUnlockView *)gestureUnlockView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(passStep:)])
    {
        [self.delegate passStep:self];
    }
}

- (void)gestureUnlockAddSuccess:(GestureUnlockView *)gestureUnlockView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addGestureSuccess:)])
    {
        [self.delegate addGestureSuccess:self];
    }
}

- (void)gestureUnlockSetSuccess:(GestureUnlockView *)gestureUnlockView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setGestureSuccess:)])
    {
        [self.delegate setGestureSuccess:self];
    }
    
    if (gestureUnlockView.type == GestureUnlockType_SetPW_Second)
    {
        for (UIViewController *viewController in [self.navigationController viewControllers])
        {
            if ([viewController isKindOfClass:[LoginViewController class]])
            {
                LoginViewController *loginViewController = (LoginViewController *)viewController;
                [self.navigationController popToViewController:loginViewController animated:YES];
                CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:LS(@"ChangePwSucceed")];
                [messageView show];
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
