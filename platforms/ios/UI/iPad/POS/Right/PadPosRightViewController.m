//
//  PadPosRightViewController.m
//  Boss
//
//  Created by lining on 15/10/15.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadPosRightViewController.h"
#import "POSDetailRightView.h"
#import "PosAlloctionViewController.h"
#import "PadPosViewController.h"

@interface PadPosRightViewController ()<POSDetailRightViewDelegate>
@property(nonatomic, strong) POSDetailRightView *rightView;
@end

@implementation PadPosRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightView = [POSDetailRightView createView];
    self.rightView.delegate = self;
    self.rightView.operate = self.operate;
    [self.view addSubview:self.rightView];
    self.rightView.autoresizingMask = 0;
    self.navigationController.navigationBarHidden = true;
    
//    [self registerNofitificationForMainThread:kFetchPosPayInfoResponse];
//    [self registerNofitificationForMainThread:kFetchPosConsumeProductResponse];
    [self registerNofitificationForMainThread:kReloadPadPOSViewResponse];
     self.noKeyboardNotification = true;
}

- (void)setOperate:(CDPosOperate *)operate
{
    if (_operate != operate) {
        _operate = operate;
        self.rightView.operate = operate;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - reload view
- (void)reloadView
{
    [self.rightView reloadRightView];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kFetchPosPayInfoResponse]) {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            [self.rightView reloadRightView];
        }
    }
    else if ([notification.name isEqualToString:kFetchPosConsumeProductResponse])
    {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            [self.rightView reloadRightView];
        }
    }
    else if ([notification.name isEqualToString:kReloadPadPOSViewResponse])
    {
        [self reloadView];
    }
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UITableViewDelegate
-(void)didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    PosAlloctionViewController *viewController = [[PosAlloctionViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    return;
}

@end
