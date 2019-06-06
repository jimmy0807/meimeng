//
//  BSSuccessViewController.m
//  Boss
//
//  Created by lining on 16/9/27.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSSuccessViewController.h"
#import "PosOperateDetailViewController.h"
#import "PhoneGiveViewController.h"
#import "CBMessageView.h"
#import "ProductProjectMainController.h"

@interface BSSuccessViewController ()<BSSuccessBtnViewDelegate>
@property (nonatomic, strong) BSSuccessBtnView *successView;

@end

@implementation BSSuccessViewController

+ (instancetype)createViewControllerWithQRUrl:(NSString *)url
{
    BSSuccessViewController *successVC = [[BSSuccessViewController alloc] init];
    successVC.successView = [BSSuccessBtnView createQRViewWithUrl:url];
    
    
    return successVC;
}

+ (instancetype)createViewControllerWithTopTip:(NSString *)topTip contentTitle:(NSString *)title detailTitle:(NSString *)detailTitle
{
    BSSuccessViewController *successVC = [[BSSuccessViewController alloc] init];
    successVC.successView = [BSSuccessBtnView createViewWithTopTip:topTip contentTitle:title detailTitle:detailTitle];
    
    return successVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = true;
    [self forbidSwipGesture];
    self.successView.delegate = self;
    [self.view addSubview:self.successView];
    [self.successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    
    
}

- (void)setStyle:(ViewShowStyle)style
{
    _style = style;
    if (style == ViewShowStyle_Give) {
        self.title = @"赠送成功";
    }
    else if (style == ViewShowStyle_Assign)
    {
        self.title = @"业绩分配成功";
    }
    else if (style == ViewShowStyle_Cashier)
    {
        self.title = @"收银成功";
    }
}

#pragma mark - BSSuccessBtnViewDelegate
- (void)didCashierBtnPressed
{
//    if ([self.delegate respondsToSelector:@selector(didCashierBtnPressed)]) {
//        [self.delegate didCashierBtnPressed];
//    }
//    }
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    ProductProjectMainController *projectMainVC = [[ProductProjectMainController alloc] init];
    projectMainVC.isFromSuccessView = true;
    projectMainVC.controllerType = ProductControllerType_Sale;
    [self.navigationController pushViewController:projectMainVC animated:YES];
}

- (void)didAssignBtnPressed
{
//    if ([self.delegate respondsToSelector:@selector(didAssignBtnPressed)]) {
//        [self.delegate didAssignBtnPressed];
//    }
    
    if (self.operate == nil && self.operateID == nil) {
        CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"亲，没有可分配业绩的单子"];
        [messageView show];
        return;
    }
    
    BOOL hasOperateDetailVC;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[PosOperateDetailViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            hasOperateDetailVC = true;
            return;
        }
    }
//    if (!hasOperateDetailVC) {
//        PosOperateDetailViewController *operateDetailVC = [[PosOperateDetailViewController alloc] init];
//        operateDetailVC.operate = self.operate;
//        operateDetailVC.operateID = self.operateID;
//        operateDetailVC.isFromSuccessView = true;
//        [self.navigationController pushViewController:operateDetailVC animated:YES];
//    }
    PosOperateDetailViewController *operateDetailVC = [[PosOperateDetailViewController alloc] init];
    operateDetailVC.operate = self.operate;
    operateDetailVC.operateID = self.operateID;
    operateDetailVC.isFromSuccessView = true;
    [self.navigationController pushViewController:operateDetailVC animated:YES];
}

- (void)didSendBtnPressed
{
//    if ([self.delegate respondsToSelector:@selector(didSendBtnPressed)]) {
//        [self.delegate didSendBtnPressed];
//    }
    BOOL hasPhoneGiveVC;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[PhoneGiveViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            hasPhoneGiveVC = true;
//            break;
            return;
        }
    }
//    if(!hasPhoneGiveVC)
//    {
//        PhoneGiveViewController *giveVC = [[PhoneGiveViewController alloc] init];
//        giveVC.operate = self.operate;
//        giveVC.operateID = self.operateID;
//        giveVC.member = self.member;
//        giveVC.isFromSuccessView = true;
//        [self.navigationController pushViewController:giveVC animated:YES];
//    }
    PhoneGiveViewController *giveVC = [[PhoneGiveViewController alloc] init];
    giveVC.operate = self.operate;
    giveVC.operateID = self.operateID;
    giveVC.member = self.member;
    giveVC.isFromSuccessView = true;
    [self.navigationController pushViewController:giveVC animated:YES];
    
   
}

- (void)didBackBtnPressed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
