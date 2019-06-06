//
//  PadPosLeftViewController.m
//  Boss
//
//  Created by lining on 15/10/15.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadPosLeftViewController.h"
#import "POSDetailLeftView.h"
#import "PadPosViewController.h"

@interface PadPosLeftViewController ()<POSDetailLeftViewDelegate>
@property(nonatomic, strong) POSDetailLeftView *leftView;
@end

@implementation PadPosLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftView = [POSDetailLeftView createView];
    self.leftView.operate = self.operate;
    self.leftView.autoresizingMask = 0;
    self.leftView.delegate = self;
    self.leftView.titleLabel.text = self.operate.name;
    [self.view addSubview:self.leftView];
    self.navigationController.navigationBarHidden = true;
    
    self.noKeyboardNotification = true;
//    [self registerNofitificationForMainThread:kFetchPosOperateProductResponse];
//    [self registerNofitificationForMainThread:kFetchPosConsumeProductResponse];
    
    [self registerNofitificationForMainThread:kReloadPadPOSViewResponse];
    
}

- (void)setOperate:(CDPosOperate *)operate
{
    if (_operate != operate) {
        _operate = operate;
        self.leftView.operate = operate;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - reload view
- (void)reloadView
{
    [self.leftView reloadLeftView];
}

#pragma mark - receiced notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kFetchPosOperateProductResponse])
    {
        [self.leftView reloadLeftView];
    }
    else if ([notification.name isEqualToString:kFetchPosConsumeProductResponse])
    {
        [self.leftView reloadLeftView];
    }
    else if ([notification.name isEqualToString:kReloadPadPOSViewResponse])
    {
        [self reloadView];
    }
}

#pragma mark - POSDetailLeftViewDelegate
- (void) didBackBtnPressed
{
    if ([self.delegate respondsToSelector:@selector(backBtnPressed)])
    {
        [self.delegate backBtnPressed];
    }
}

- (void) didPrintBtnPressed
{
    NSLog(@"printBtnPressed");
    if ([self.delegate respondsToSelector:@selector(printBtnPressed)]) {
        [self.delegate printBtnPressed];
    }
}

- (void) didGiveBtnPressed
{
    NSLog(@"giveBtnPressed");
    if ([self.delegate respondsToSelector:@selector(giveBtnPressed)]) {
        [self.delegate giveBtnPressed];
    }
}

- (void) didEditPosOperateBtnPressed
{
    NSLog(@"giveBtnPressed");
    if ([self.delegate respondsToSelector:@selector(didEditPosOperateBtnPressed)]) {
        [self.delegate didEditPosOperateBtnPressed];
    }
}

- (void) didSelectedOperate:(CDPosOperate *)operate
{
    if ([self.delegate respondsToSelector:@selector(selectedOperate:)]) {
        [self.delegate selectedOperate:operate];
    }
}

- (void) didSelectedPosProduct:(CDPosProduct *)posProduct
{
    if ([self.delegate respondsToSelector:@selector(selectedPosProduct:)]) {
        [self.delegate selectedPosProduct:posProduct];
    }
}

#pragma mark - Memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

@end
