//
//  PadPosViewController.m
//  Boss
//
//  Created by lining on 15/10/16.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadPosViewController.h"

#import "POSDetailLeftView.h"
#import "POSDetailRightView.h"
#import "UIView+Frame.h"
#import "PadPosLeftViewController.h"
#import "PadPosRightViewController.h"
#import "CBRotateNavigationController.h"
#import "BSFetchPosOperateRequest.h"
#import "BSFetchPosProductRequest.h"
#import "BSFetchPosPayInfoRequest.h"
#import "PadGiveViewController.h"
#import "PosAlloctionViewController.h"
#import "BSFetchPosConsumProduct.h"
#import "BSFetchPosCommissionRequest.h"
#import "CBLoadingView.h"
#import "BSProjectRequest.h"
#import "CBMessageView.h"
#import "BSFetchPosCouponProduct.h"
#import "BSFetchPosCouponRequest.h"
#import "BSFetchStaffRequest.h"
#import "BSFetchCommissionRuleRequest.h"
#import "BSPrintPosOperateRequest.h"
#import "BSFetchMemberCardDetailRequest.h"
#import "PadProjectViewController.h"
#import "BSPrintPosOperateRequestNew.h"

#define kLeftViewWidth  420
#define kRightViewWidth 603

#define kTitleHeight 75

@interface PadPosViewController ()<PadPosLeftViewControllerDelegate>
{
    NSInteger requestCount;
    CDPosBaseProduct *posProduct;
    bool needUpdateRightView;
}
@property(nonatomic, strong) PadPosLeftViewController *leftVC;
@property(nonatomic, strong) PadPosRightViewController *rightVC;

@property(nonatomic, strong) UINavigationController *leftNav;
@property(nonatomic, strong) UINavigationController *rightNav;
@end

@implementation PadPosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(242, 245, 245, 1);
    [self initLeftView];
    [self initRightView];
    
    [self registerNofitificationForMainThread:kFetchPosCardOperateResponse];
    [self registerNofitificationForMainThread:kFetchPosOperateProductResponse];
    [self registerNofitificationForMainThread:kFetchPosPayInfoResponse];
    [self registerNofitificationForMainThread:kFetchPosConsumeProductResponse];
    [self registerNofitificationForMainThread:kFetchPosCommissionResponse];
    [self registerNofitificationForMainThread:kPosAssigncommissionResponse];
    [self registerNofitificationForMainThread:kPosCouponProductResponse];
    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self registerNofitificationForMainThread:kFetchCommissionRuleResponse];
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    [self registerNofitificationForMainThread:kBSDeleteOperateItemResponse];
    
    if (self.operate)
    {
        [self sendBaseRequest];
    }
    else
    {
        BSFetchPosOperateRequest* request = [[BSFetchPosOperateRequest alloc] init];
        request.operateID = self.operateID;
        [request execute];
    }

    [[CBLoadingView shareLoadingView] show];
   
}

- (void)sendBaseRequest
{
    //一般消费产品
    [[[BSFetchPosProductRequest alloc] initWithPosOperate:self.operate] execute];
    requestCount ++;
    
    
    //付款方式信息
    [[[BSFetchPosPayInfoRequest alloc] initWithPosOperate:self.operate
      ] execute];
    requestCount ++;
    
    //会员卡内消费项目
    [[[BSFetchPosConsumProduct alloc] initWithPosOperate:self.operate] execute];
    requestCount ++;
    
    
    //优惠券消费项目
    [[[BSFetchPosCouponRequest alloc] initWithPosOperate:self.operate] execute];
    requestCount ++;
    
    
    //业绩分配
    [[[BSFetchPosCommissionRequest alloc] initWithPosOperate:self.operate] execute];
    requestCount ++;

    
    //员工
//    BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
//    request.shopID = self.operate.operate_shop_id;
//    request.need_role_id = true;
//    [request execute];
//    requestCount++;
    
    //提成方案
    BSFetchCommissionRuleRequest *ruleReqest = [[BSFetchCommissionRuleRequest alloc] init];
    [ruleReqest execute];
   
    BSFetchMemberCardDetailRequest* request2 = [[BSFetchMemberCardDetailRequest alloc] initWithMemberCardID:self.operate.card_id];
    [request2 execute];
    
    [[CBLoadingView shareLoadingView] show];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - init View & Data


- (void)initLeftView
{
    self.leftVC = [[PadPosLeftViewController alloc] init];
    self.leftVC.delegate = self;
    self.leftVC.operate = self.operate;
    self.leftNav = [[UINavigationController alloc] initWithRootViewController:self.leftVC];
    self.leftNav.view.autoresizingMask = 0;
    self.leftNav.view.width = kLeftViewWidth;
    self.leftNav.navigationBarHidden = true;
    [self.view addSubview:self.leftNav.view];
}

- (void)initRightView
{
   
    self.rightVC = [[PadPosRightViewController alloc] init];
    self.rightVC.operate = self.operate;
    self.rightNav = [[UINavigationController alloc] initWithRootViewController:self.rightVC];

    self.rightNav.view.x = 421;
    self.rightNav.view.width = kRightViewWidth;
    self.rightNav.view.autoresizingMask = 0;
    self.rightNav.navigationBarHidden = true;
    [self.view addSubview:self.rightNav.view];
    
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{

    if ([notification.name isEqualToString:kPosAssigncommissionResponse])
    {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0)
        {
            [[[BSFetchPosCommissionRequest alloc] initWithPosOperate:self.operate] execute];
        }
        else
        {
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]];
            [messageView show];
            [[CBLoadingView shareLoadingView] hide];
        }
        
        return;
    }
    if ([notification.name isEqualToString:kFetchPosCardOperateResponse]) {
        self.operate = [[BSCoreDataManager currentManager] findEntity:@"CDPosOperate" withValue:self.operateID forKey:@"operate_id"];
        self.leftVC.operate = self.operate;
        self.rightVC.operate = self.operate;
        if (self.operate) {
             [self sendBaseRequest];
        }
        else
        {
            [[CBLoadingView shareLoadingView] hide];
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"单据获取失败"];
            [messageView show];
        }
       
        
        return;
    }
    else if ( [notification.name isEqualToString:kBSMemberCardOperateResponse] || [notification.name isEqualToString:kBSDeleteOperateItemResponse])
    {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0)
        {
            [self sendBaseRequest];
        }
        else
        {
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]];
            [messageView show];
            [[CBLoadingView shareLoadingView] hide];
        }
        
        return;
    }
    
    if ([notification.name isEqualToString:kFetchPosOperateProductResponse])
    {
         requestCount--;
    }
    else if ([notification.name isEqualToString:kFetchPosPayInfoResponse])
    {
         requestCount--;
    }
    else if ([notification.name isEqualToString:kFetchPosConsumeProductResponse])
    {
         requestCount--;
    }
    else if ([notification.name isEqualToString:kFetchPosCommissionResponse])
    {
         requestCount--;
    }
    else if ([notification.name isEqualToString:kPosCouponProductResponse])
    {
        requestCount--;
    }
    else if ([notification.name isEqualToString:kBSFetchStaffResponse])
    {
        requestCount--;
    }
    else if ([notification.name isEqualToString:kFetchCommissionRuleResponse])
    {
        requestCount--;
    }
    if (requestCount <= 0)
    {
        [[CBLoadingView shareLoadingView] hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadPadPOSViewResponse object:self.operate];
//        if (needUpdateRightView)
//        {
////            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"业绩分配成功"];
////            [messageView show];
//            [self selectedPosProduct:posProduct];
//            needUpdateRightView = false;
//        }
    }
}


#pragma mark - relod view
- (void)reloadLeftView
{
    
}

- (void)reloadRightView
{
    
}

#pragma mark - PadPosLeftViewControllerDelegate
- (void)backBtnPressed
{
    if (self.operateID) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)printBtnPressed
{
    if ( [PersonalProfile currentProfile].printIP.length > 2 )
    {
        BSPrintPosOperateRequestNew* request = [[BSPrintPosOperateRequestNew alloc] init];
        request.operateID = self.operate.operate_id;
        request.openCashBox = FALSE;
        [request execute];
    }
    else
    {
        [[BSPrintPosOperateRequest alloc] printWithPosOperateID:self.operate.operate_id];
    }
}

- (void)giveBtnPressed
{
    if ( [self.operate.progre_status isEqualToString:@"done"] )
    {
        [[[CBMessageView alloc] initWithTitle:@"已完成的单据，无法进行赠送"] show];
        return;
    }
    
    if ([self.operate.member.isDefaultCustomer integerValue] == 1) {
//        [[[CBMessageView alloc] initWithTitle:@"客户还不是会员，无法进行赠送"] show];
//        return;
    }
    PadGiveViewController *padGiveVC = [[PadGiveViewController alloc] initWithNibName:@"PadGiveViewController" bundle:nil];
    padGiveVC.member = self.operate.member;
    padGiveVC.opereate = self.operate;
    [self.navigationController pushViewController:padGiveVC animated:YES];
}

- (void)didEditPosOperateBtnPressed
{
    if ( [self.operate.progre_status isEqualToString:@"done"] )
    {
        [[[CBMessageView alloc] initWithTitle:@"已完成的单据，无法添加项目"] show];
        return;
    }
    
    CDMemberCard* memberCard = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.operate.card_id forKey:@"cardID"];
    
    PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithMemberCard:memberCard couponCard:nil handno:@""];
    viewController.orignalOperateID = self.operate.operate_id;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)selectedPosProduct:(CDPosBaseProduct *)product
{
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        return;
    }
    
    NSLog(@"选中了 selectedPosProduct");
    posProduct = product;
    needUpdateRightView = true;
    
    PosAlloctionViewController *rightVC = [[PosAlloctionViewController alloc] init];
    rightVC.product = product;
    rightVC.operate = self.operate;
    if (self.rightNav) {
        [self.rightNav.view removeFromSuperview];
    }
    self.rightNav = [[UINavigationController alloc] initWithRootViewController:rightVC];
    
    self.rightNav.view.x = 421;
    self.rightNav.view.width = kRightViewWidth;
    self.rightNav.view.autoresizingMask = 0;
    self.rightNav.navigationBarHidden = true;
    [self.view addSubview:self.rightNav.view];
}

- (void)selectedOperate:(CDPosOperate *)operate
{
    if (self.rightNav) {
        [self.rightNav.view removeFromSuperview];
    }
    PadPosRightViewController *rightVC = [[PadPosRightViewController alloc] init];
    rightVC.operate = self.operate;
    self.rightNav = [[UINavigationController alloc] initWithRootViewController:rightVC];
    
    self.rightNav.view.x = 421;
    self.rightNav.view.width = kRightViewWidth;
    self.rightNav.view.autoresizingMask = 0;
    self.rightNav.navigationBarHidden = true;
    [self.view addSubview:self.rightNav.view];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
