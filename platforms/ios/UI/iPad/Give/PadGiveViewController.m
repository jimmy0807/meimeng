//
//  PadGiveViewController.m
//  Boss
//
//  Created by lining on 15/10/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadGiveViewController.h"
#import "GiveLeftViewController.h"
#import "GiveRightViewController.h"
#import "UIView+Frame.h"
#import "GiveCardViewController.h"
#import "GiveTicketViewController.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "PadCardOperateViewController.h"
#import "PadMaskView.h"
#import "PadOperateSuccessViewController.h"
#import "BSFetchCardTemplateRequest.h"
#import "GiveTemplateViewController.h"
#import "GiveWXTemplateViewController.h"

#define kLeftWidth 512


@interface PadGiveViewController ()<GiveLeftVCDelegate,GiveRightVCDelegate>
@property(nonatomic, strong) UINavigationController *leftNav;
@property(nonatomic, strong) UINavigationController *rightNav;
@property(nonatomic, strong) PadMaskView *maskView;
@property (strong, nonatomic) GivePeople *givePeople;
@property (strong, nonatomic)GiveLeftViewController *leftVC;
@end

@implementation PadGiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initMaskView];
    [self forbidSwipGesture];
    [self initLeftView];
    [self initRightView];
    
    [self  registerNofitificationForMainThread:kBSGiveCardResponse];
    [self registerNofitificationForMainThread:kBSGiveTicketResponse];
    [self registerNofitificationForMainThread:kFetchPosCardOperateResponse];
    
    if (!self.givePeople) {
        [[CBLoadingView shareLoadingView] show];
    }
    
}

- (void)setOpereate:(CDPosOperate *)opereate
{
    _opereate = opereate;
    self.givePeople = [[GivePeople alloc] init];
    self.givePeople.member_id = opereate.member_id;
    self.givePeople.member_name = opereate.member_name;
    self.givePeople.shop_id = opereate.operate_shop_id;
    self.givePeople.mobile = opereate.member_mobile;
}

- (void)setMember:(CDMember *)member
{
    _member = member;
    self.givePeople = [[GivePeople alloc] init];
    self.givePeople.member_id = member.memberID;
    self.givePeople.member_name = member.memberName;
    self.givePeople.shop_id = member.storeID;
    self.givePeople.mobile = member.mobile;
}


#pragma mark - init view & data
- (void)initMaskView
{
    self.maskView = [[PadMaskView alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _leftVC.btn.selected = YES;
    [self didLeftBtnPressed:_leftVC.btn];
    
}

- (void)initLeftView
{
    _leftVC = [[GiveLeftViewController alloc] init];
    _leftVC.delegate = self;
    self.leftNav = [[UINavigationController alloc] initWithRootViewController:_leftVC];
    self.leftNav.navigationBarHidden = true;
    self.leftNav.view.width = kLeftWidth;
    self.leftNav.view.autoresizingMask = 0;
    [self.view addSubview:self.leftNav.view];
    
    
    
    
}

- (void)initRightView
{
    
    /// 赠送礼券修改
    //礼品券
    GiveTemplateViewController *templateVC = [[GiveTemplateViewController alloc] init];
    templateVC.type = kTemplateType_coupon;
    templateVC.givePeople = self.givePeople;
    //[self.rightNav pushViewController:templateVC animated:NO];
    
    
    //    GiveRightViewController *rightVC = [[GiveRightViewController alloc] init];
    //    rightVC.delegate = self;
    self.rightNav = [[UINavigationController alloc] initWithRootViewController:templateVC];
    self.rightNav.navigationBarHidden = true;
    self.rightNav.view.x = kLeftWidth;
    self.rightNav.view.autoresizingMask = 0;
    [self.view addSubview:self.rightNav.view];
}

#pragma mark - view controller delegate
- (void) didBackBtnPressed:(UIButton *)btn
{
    if (self.operateID) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didLeftBtnPressed:(UIButton *)btn
{
    if (btn.selected) {
        NSLog(@"选中");
        
        
        //礼品券
        GiveTemplateViewController *templateVC = [[GiveTemplateViewController alloc] init];
        templateVC.type = kTemplateType_coupon;
        templateVC.givePeople = self.givePeople;
        [self.rightNav pushViewController:templateVC animated:NO];
        
    }
    else
    {
        NSLog(@"没选中");
        [self.rightNav popToRootViewControllerAnimated:NO];
    }
}

- (void)didRightBtnPressed:(UIButton *)btn
{
    if (btn.selected) {
        NSLog(@"选中");
        //        GiveCardViewController *giveCardVC = [[GiveCardViewController alloc] init];
        //        giveCardVC.operate = self.opereate;
        //        [self.leftNav pushViewController:giveCardVC animated:YES];
        //礼品卡
        GiveWXTemplateViewController *templateVC = [[GiveWXTemplateViewController alloc] init];
        templateVC.member = self.member;
        templateVC.rootNavigationVC = self.navigationController;
        //        templateVC.type = kTemplateType_card;
        //        templateVC.operate = self.opereate;
        [self.leftNav pushViewController:templateVC animated:YES];
    }
    else
    {
        NSLog(@"没选中");
        [self.leftNav popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [[CBLoadingView shareLoadingView] hide];
    NSDictionary *dict = notification.userInfo;
    NSInteger ret = [[dict numberValueForKey:@"rc"] integerValue];
    if ([notification.name isEqualToString:kBSGiveTicketResponse] || [notification.name isEqualToString:kBSGiveCardResponse]) {
        if (ret == 0) {
            if ([notification.name isEqualToString:kBSGiveTicketResponse]) {
                [[[CBMessageView alloc] initWithTitle:@"礼品券赠送成功"] show];
            }
            else
            {
                [[[CBMessageView alloc] initWithTitle:@"礼品卡赠送成功"] show];
            }
            GiveLeftViewController *leftVC = [self.leftNav.viewControllers firstObject];
            [leftVC leftBtnPressed:nil];
            
            PadOperateSuccessViewController *viewController = [[PadOperateSuccessViewController alloc] initWithOperateType:kPadGiveGiftCardSuccess detail:notification.object amount:0];
            viewController.maskView = self.maskView;
            self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
            self.maskView.navi.navigationBarHidden = YES;
            self.maskView.navi.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
            [self.maskView addSubview:self.maskView.navi.view];
            [self.maskView show];
        }
        else
        {
            if ([notification.name isEqualToString:kBSGiveTicketResponse]) {
                [[[CBMessageView alloc] initWithTitle:@"礼品券赠送失败,请稍后重试"] show];
            }
            else
            {
                [[[CBMessageView alloc] initWithTitle:@"礼品卡赠送失败,请稍后重试"] show];
            }
        }
    }
    else if ([notification.name isEqualToString:kBSGiveCardResponse])
    {
        if (ret == 0) {
            [[[CBMessageView alloc] initWithTitle:@"礼品卡赠送成功"] show];
            GiveRightViewController *rightVC = [self.rightNav.viewControllers firstObject];
            [rightVC rightBtnPressed:nil];
            PadOperateSuccessViewController *viewController = [[PadOperateSuccessViewController alloc] initWithOperateType:kPadGiveGiftCardSuccess detail:notification.object amount:0];
            viewController.maskView = self.maskView;
            self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
            self.maskView.navi.navigationBarHidden = YES;
            self.maskView.navi.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
            [self.maskView addSubview:self.maskView.navi.view];
            [self.maskView show];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:@"礼品卡赠送失败,请稍后重试"] show];
        }
    }
    else if ([notification.name isEqualToString:kFetchPosCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        self.opereate = [[BSCoreDataManager currentManager] findEntity:@"CDPosOperate" withValue:self.operateID forKey:@"operate_id"];
        if (!self.opereate) {
            
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"单据获取失败"];
            [messageView show];
        }
    }
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

