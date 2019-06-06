//
//  PadSettingViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadSettingViewController.h"
#import "UIImage+Resizable.h"
#import "CBRotateNavigationController.h"
#import "UIViewController+MMDrawerController.h"
#import "PadMaskView.h"
#import "PadSettingInfoViewController.h"
#import "PadLoginViewController.h"
#import "PadHandWriteBookVC.h"
@interface PadSettingViewController ()

@property (nonatomic, assign) kPadSettingViewType viewType;
@property (nonatomic, strong) CBRotateNavigationController *leftNavi;
@property (nonatomic, strong) CBRotateNavigationController *rightNavi;

@property (nonatomic, strong) PadSettingLeftViewController *leftViewController;
@property (nonatomic, strong) PadSettingRightViewController *rightViewController;
@property (nonatomic, strong) PadHandWriteBookVC *handWriteBookVC;

@property (nonatomic, strong) PadMaskView *maskView;

@end

@implementation PadSettingViewController

- (id)initWithViewType:(kPadSettingViewType)type
{
    self = [super initWithNibName:@"PadSettingViewController" bundle:nil];
    if (self)
    {
        self.viewType = type;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.view.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    self.rightViewController = [[PadSettingRightViewController alloc] initWithDelegate:self];
    self.rightNavi = [[CBRotateNavigationController alloc] initWithRootViewController:self.rightViewController];
    self.rightNavi.navigationBarHidden = YES;
    self.rightNavi.view.frame = CGRectMake(kPadSettingLeftSideViewWidth, 0.0, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, IC_SCREEN_HEIGHT);
    [self.view addSubview:self.rightNavi.view];
    
    UIImageView *leftBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadSettingLeftSideViewWidth + 3.0, IC_SCREEN_HEIGHT)];
    leftBackground.backgroundColor = [UIColor clearColor];
    leftBackground.image = [[UIImage imageNamed:@"pad_setting_left"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    leftBackground.userInteractionEnabled = YES;
    [self.view addSubview:leftBackground];
    
    self.leftViewController = [[PadSettingLeftViewController alloc] initWithDelegate:self];
    self.leftViewController.viewType = self.viewType;
    self.leftNavi = [[CBRotateNavigationController alloc] initWithRootViewController:self.leftViewController];
    self.leftNavi.navigationBarHidden = YES;
    self.leftNavi.view.frame = CGRectMake(0.0, 0.0, kPadSettingLeftSideViewWidth, IC_SCREEN_HEIGHT);
    [self.view addSubview:self.leftNavi.view];
    
    self.maskView = [[PadMaskView alloc] init];
    [self.view addSubview:self.maskView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark init Methods



#pragma mark -
#pragma mark PadSettingLeftViewControllerDelegate Methods

- (void)backPaymentView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backHomeLeftSideBar
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)reloadSettingDetailWithType:(kPadSettingDetailType)type
{
    [self.rightViewController reloadWithType:type];
}

-(void)showHandWriteBookVC{
    [self.rightViewController showHandWriteBookViewController];

}


#pragma mark -
#pragma mark PadSettingRightViewControllerDelegate Methods

- (void)didPadSettingInfoWithType:(kPadSettingDetailType)type
{
    PadSettingInfoViewController *viewController = [[PadSettingInfoViewController alloc] initWithType:type];
    viewController.view.backgroundColor = [UIColor whiteColor];
    viewController.maskView = self.maskView;
    self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    self.maskView.navi.navigationBarHidden = YES;
    self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    //self.maskView.backgroundColor = [UIColor orangeColor];
    [self.maskView addSubview:self.maskView.navi.view];
    [self.maskView show];
}

@end
