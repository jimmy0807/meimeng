//
//  PadMemberAndCardViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/11/11.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadMemberAndCardViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "UIImage+Resizable.h"
#import "CBRotateNavigationController.h"
#import "PadMaskView.h"
#import "PadMemberCreateViewController.h"
#import "PadMemberTiYanCreateViewController.h"
#import "PadCardCreateViewController.h"
#import "PadCardOperateViewController.h"
#import "PadRepaymentViewController.h"
#import "PadReturnItemViewController.h"
#import "PadRefundViewController.h"
//#import "PadReplacementViewController.h"
#import "PadAdjustCardItemViewController.h"
#import "PadMergerViewController.h"
#import "PadActiveViewController.h"
#import "PadWeCardActiveCodeViewController.h"
#import "PadLostViewController.h"
#import "PadUpgradeViewController.h"
#import "PadTurnStoreViewController.h"
#import "PadRedeemViewController.h"
#import "PadMemberInfoViewController.h"
#import "PadInputItemViewController.h"
#import "PadBindViewController.h"

@interface PadMemberAndCardViewController ()

@property (nonatomic, assign) kPadMemberAndCardViewType viewType;
@property (nonatomic, strong) PadMaskView *maskView;
@property (nonatomic, strong) CBRotateNavigationController *navi;
@property (nonatomic, strong) PadCardOperateView *cardOperateView;
@property (nonatomic, strong) UIImageView *infoBackground;
@property (nonatomic, strong) CBRotateNavigationController *infoNavi;
@property (nonatomic, strong) PadMemberInfoViewController *infoViewController;
@property (nonatomic, strong) NSString *createdCardNumber;

@end

@implementation PadMemberAndCardViewController

- (id)initWithViewType:(kPadMemberAndCardViewType)viewType
{
    self = [super initWithNibName:@"PadMemberAndCardViewController" bundle:nil];
    if (self)
    {
        self.viewType = viewType;
        
        self.member = nil;
        self.memberCard = nil;
        self.couponCard = nil;
    }
    
    return self;
}

- (id)initWithMember:(CDMember *)member memberCard:(CDMemberCard *)memberCard couponCard:(CDCouponCard *)couponCard
{
    self = [super initWithNibName:@"PadMemberAndCardViewController" bundle:nil];
    if (self)
    {
        self.viewType = kPadMemberAndCardSelect;
        
        self.member = member;
        self.memberCard = memberCard;
        self.couponCard = couponCard;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self forbidSwipGesture];
    self.view.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kPadEditMemberNotification];
    [self registerNofitificationForMainThread:kPadSelectMemberFinish];
    [self registerNofitificationForMainThread:kPadEditMemberFinish];
    [self registerNofitificationForMainThread:kPadSelectMemberCardFinish];
    [self registerNofitificationForMainThread:kPadSelectCouponCardFinish];
    [self registerNofitificationForMainThread:kPadCreateMemberFinish];
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardDetailResponse];
    
    self.infoBackground = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMemberAndCardViewWidth + kPadCardIntervalWidth - 3.0, 0.0, kPadMemberAndCardInfoWidth + 2 * 3.0, IC_SCREEN_HEIGHT)];
    self.infoBackground.backgroundColor = [UIColor clearColor];
    self.infoBackground.image = [[UIImage imageNamed:@"pad_member_and_card_info"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    self.infoBackground.userInteractionEnabled = YES;
    [self.view addSubview:self.infoBackground];
    
    // 点击左侧会员一览 打开的右侧会员详情界面
    self.infoViewController = [[PadMemberInfoViewController alloc] init];
    self.infoViewController.parentVC = self;
    self.infoNavi = [[CBRotateNavigationController alloc] initWithRootViewController:self.infoViewController];
    self.infoNavi.navigationBarHidden = YES;
    self.infoNavi.view.frame = CGRectMake(3.0, 0.0, kPadMemberAndCardInfoWidth, IC_SCREEN_HEIGHT);
    [self.infoBackground addSubview:self.infoNavi.view];
    
    self.cardOperateView = [[PadCardOperateView alloc] init];
    self.cardOperateView.hidden = YES;
    self.cardOperateView.delegate = self;
    [self.view addSubview:self.cardOperateView];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadProjectSideViewWidth + 3.0, IC_SCREEN_HEIGHT)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_left_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    background.userInteractionEnabled = YES;
    [self.view addSubview:background];
    
    PadMemberSelectViewController *viewController = [[PadMemberSelectViewController alloc] initWithViewType:self.viewType];
    viewController.delegate = self;
    viewController.keyword = self.keyword;
    self.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    self.navi.navigationBarHidden = YES;
    self.navi.view.frame = CGRectMake(0.0, 0.0, kPadMemberAndCardViewWidth, IC_SCREEN_HEIGHT);
    [self.view addSubview:self.navi.view];
    
    if (self.member && !self.member.isDefaultCustomer.boolValue)
    {
        self.infoBackground.hidden = NO;
        self.cardOperateView.hidden = NO;
        self.cardOperateView.memberCard = self.memberCard;
        self.infoViewController.member = self.member;
        self.infoViewController.memberCard = self.memberCard;
        
        PadCardSelectViewController *viewController = [[PadCardSelectViewController alloc] initWithMember:self.member memberCard:self.memberCard couponCard:self.couponCard];
        viewController.rootNavigationVC = self.rootNaviationVC;
        viewController.delegate = self;
        viewController.isMemberSelected = YES;
        [self.navi pushViewController:viewController animated:NO];
    }
    else
    {
        self.infoBackground.hidden = YES;
        self.cardOperateView.hidden = YES;
    }
    
    self.maskView = [[PadMaskView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.maskView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kPadSelectMemberFinish] || [notification.name isEqualToString:kPadCreateMemberFinish])
    {
        self.member = (CDMember *)notification.object;
        if (self.member)
        {
            self.infoBackground.hidden = NO;
            self.cardOperateView.hidden = NO;
        }
        self.cardOperateView.memberCard = nil;
        self.infoViewController.member = self.member;
        self.infoViewController.memberCard = nil;
        self.infoViewController.couponCard = nil;
        [self.infoViewController.navigationController popToRootViewControllerAnimated:YES];
        
        PadCardSelectViewController *viewController = [[PadCardSelectViewController alloc] initWithMember:self.member viewType:self.viewType];
        viewController.rootNavigationVC = self.rootNaviationVC;
        viewController.delegate = self;
        if (notification.userInfo && [[notification.userInfo objectForKey:@"CreateCard"] boolValue])
        {
            [self performSelector:@selector(didMemberCardCreate) withObject:nil afterDelay:0.2];
        }
        [self.navi pushViewController:viewController animated:YES];
        self.infoBackground.hidden = NO;
    }
    else if ( [notification.name isEqualToString:kPadEditMemberFinish] )
    {
        [self.infoViewController clearMember];
        self.infoViewController.member = self.member;
    }
    else if ([notification.name isEqualToString:kPadSelectMemberCardFinish])
    {
        self.memberCard = (CDMemberCard *)notification.object;
        self.cardOperateView.memberCard = self.memberCard;
        self.infoViewController.memberCard = self.memberCard;
    }
    else if ([notification.name isEqualToString:kPadSelectCouponCardFinish])
    {
        self.couponCard = (CDCouponCard *)notification.object;
        self.infoViewController.couponCard = self.couponCard;
    }
    else if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            NSNumber *cardID = [notification.object objectForKey:@"card_id"];
            NSString *cardNumber = [notification.object objectForKey:@"card_no"];
            if (cardID.integerValue != 0)
            {
                self.memberCard = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:cardID forKey:@"cardID"];
                if (!self.memberCard)
                {
                    self.memberCard = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCard"];
                    self.memberCard.cardID = cardID;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberCardFinish object:self.memberCard userInfo:nil];
            }
            else
            {
                if (cardNumber.length != 0)
                {
                    self.createdCardNumber = cardNumber;
                }
            }
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            if (self.createdCardNumber)
            {
                self.memberCard = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.createdCardNumber forKey:@"cardNumber"];
                self.cardOperateView.memberCard = self.memberCard;
                self.infoViewController.memberCard = self.memberCard;
                [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberCardFinish object:self.memberCard userInfo:nil];
                self.createdCardNumber = nil;
            }
            else
            {
                [self.infoViewController reloadData];
            }
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardDetailResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.cardOperateView.memberCard = self.memberCard;
            self.infoViewController.memberCard = self.memberCard;
        }
    }
    if ( [notification.name isEqualToString:kPadEditMemberNotification] )
    {
        PadMemberCreateViewController *viewController = [[PadMemberCreateViewController alloc] initWithMember:notification.object];
        viewController.maskView = self.maskView;
        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        self.maskView.navi.navigationBarHidden = YES;
        self.maskView.navi.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
        [self.maskView addSubview:self.maskView.navi.view];
        [self.maskView show];
    }
}

- (void)didMemberCardCreate
{
    [self didMemberCardOperateWithType:kPadMemberCardOperateCreate];
}


#pragma mark -
#pragma mark PadMemberSelectViewControllerDelegate Methods

- (void)didMemberSelectCancel
{
    if (self.viewType == kPadMemberAndCardDefault)
    {
        if ( self.keyword.length > 0 )
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }
    }
    else if (self.viewType == kPadMemberAndCardSelect)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didMemberCreateButtonClick:(BOOL)isTiyan
{
    if ( isTiyan )
    {
        PadMemberTiYanCreateViewController *viewController = [[PadMemberTiYanCreateViewController alloc] init];
        viewController.maskView = self.maskView;
        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        self.maskView.navi.navigationBarHidden = YES;
        self.maskView.navi.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
        [self.maskView addSubview:self.maskView.navi.view];
        [self.maskView show];
    }
    else
    {
        PadMemberCreateViewController *viewController = [[PadMemberCreateViewController alloc] init];
        viewController.maskView = self.maskView;
        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        self.maskView.navi.navigationBarHidden = YES;
        self.maskView.navi.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
        [self.maskView addSubview:self.maskView.navi.view];
        [self.maskView show];
    }
}


#pragma mark -
#pragma mark PadCardSelectViewControllerDelegate Methods

- (void)didCardSelectCancel:(BOOL)isMemberSelected
{
    self.infoBackground.hidden = YES;
    self.cardOperateView.hidden = YES;
    if (isMemberSelected)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.viewType == kPadMemberAndCardBook) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kMemberNavigationBackToBook object:self.member];
    }
}

- (void)didCardSelectMemberCard:(CDMemberCard *)memberCard couponCard:(CDCouponCard *)couponCard toOrder:(BOOL)toOrder
{
    //self.infoBackground.hidden = YES;
    //self.cardOperateView.hidden = YES;
    self.member = memberCard.member;
    self.memberCard = memberCard;
    self.couponCard = couponCard;
    if ( self.member == nil )
    {
        self.member = couponCard.member;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.member, @"member", nil];
    if (self.memberCard != nil)
    {
        [params setObject:self.memberCard forKey:@"card"];
    }
    if (self.couponCard != nil)
    {
        [params setObject:self.couponCard forKey:@"coupon"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberAndCardFinish object:@(toOrder) userInfo:params];
    if ( !toOrder )
    {
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    
}


#pragma mark -
#pragma mark PadCardOperateViewDelegate Methods

- (void)didMemberCardOperateWithType:(NSInteger)type
{
    UIViewController *viewController = nil;
    switch (type)
    {
        case kPadMemberCardOperateCreate:
        {
            PadCardCreateViewController *cardCreateVC = [[PadCardCreateViewController alloc] initWithMember:self.member];
            cardCreateVC.maskView = self.maskView;
            viewController = (UIViewController *)cardCreateVC;
        }
            break;
            
        case kPadMemberCardOperateRecharge:
        {
            PadCardOperateViewController *operateViewController = [[PadCardOperateViewController alloc] initWithMember:self.member memberCard:self.memberCard operateType:type];
            operateViewController.maskView = self.maskView;
            viewController = (UIViewController *)operateViewController;
        }
            break;
          
        case kPadMemberCardOperateInputItem:
        {
            PadInputItemViewController *returnItemViewController = [[PadInputItemViewController alloc] initWithMemberCard:self.memberCard couponCard:self.couponCard];
            returnItemViewController.maskView = self.maskView;
            viewController = (UIViewController *)returnItemViewController;
        }
            break;
            
        case kPadMemberCardOperateRepayment:
        {
            PadRepaymentViewController *repaymentViewController = [[PadRepaymentViewController alloc] initWithMemberCard:self.memberCard];
            repaymentViewController.maskView = self.maskView;
            viewController = (UIViewController *)repaymentViewController;
        }
            break;
            
        case kPadMemberCardOperateExchange:
        {
            PadReturnItemViewController *returnItemViewController = [[PadReturnItemViewController alloc] initWithMemberCard:self.memberCard];
            returnItemViewController.maskView = self.maskView;
            viewController = (UIViewController *)returnItemViewController;
        }
            break;
            
        case kPadMemberCardOperateRefund:
        {
            PadRefundViewController *refundViewController = [[PadRefundViewController alloc] initWithMemberCard:self.memberCard];
            refundViewController.maskView = self.maskView;
            viewController = (UIViewController *)refundViewController;
        }
            break;
            
        case kPadMemberCardOperateReplacement:
        {
            PadAdjustCardItemViewController *itemViewController = [[PadAdjustCardItemViewController alloc] initWithNibName:@"PadAdjustCardItemViewController" bundle:nil];
            itemViewController.maskView = self.maskView;
            itemViewController.memberCard = self.memberCard;
            viewController = (UIViewController *)itemViewController;
        }
            break;
            
        case kPadMemberCardOperateBind:
        {
            PadBindViewController *bindViewController = [[PadBindViewController alloc] initWithMemberCard:self.memberCard];
            bindViewController.maskView = self.maskView;
            viewController = (UIViewController *)bindViewController;
        }
            break;
            
        case kPadMemberCardOperateMerger:
        {
            PadMergerViewController *mergerViewController = [[PadMergerViewController alloc] initWithMemberCard:self.memberCard];
            mergerViewController.maskView = self.maskView;
            viewController = (UIViewController *)mergerViewController;
        }
            break;
            
        case kPadMemberCardOperateActive:
        {
            if (self.memberCard.state.integerValue == kPadMemberCardStateActive)
            {
                PadWeCardActiveCodeViewController *codeViewController = [[PadWeCardActiveCodeViewController alloc] initWithMemberCard:self.memberCard];
                codeViewController.maskView = self.maskView;
                viewController = (UIViewController *)codeViewController;
            }
            else if (self.memberCard.state.integerValue == kPadMemberCardStateLost)
            {
                PadActiveViewController *activeViewController = [[PadActiveViewController alloc] initWithMemberCard:self.memberCard];
                activeViewController.maskView = self.maskView;
                viewController = (UIViewController *)activeViewController;
            }
        }
            break;
            
        case kPadMemberCardOperateLost:
        {
            PadLostViewController *lostViewController = [[PadLostViewController alloc] initWithMemberCard:self.memberCard];
            lostViewController.maskView = self.maskView;
            viewController = (UIViewController *)lostViewController;
        }
            break;
            
        case kPadMemberCardOperateUpgrade:
        {
            PadUpgradeViewController *upgradeViewController = [[PadUpgradeViewController alloc] initWithMemberCard:self.memberCard];
            upgradeViewController.maskView = self.maskView;
            viewController = (UIViewController *)upgradeViewController;
        }
            break;
            
        case kPadMemberCardOperateTurnStore:
        {
            PadTurnStoreViewController *trunStoreViewController = [[PadTurnStoreViewController alloc] initWithMemberCard:self.memberCard];
            trunStoreViewController.maskView = self.maskView;
            viewController = (UIViewController *)trunStoreViewController;
        }
            break;
            
        case kPadMemberCardOperateRedeem:
        {
            PadRedeemViewController *redeemViewController = [[PadRedeemViewController alloc] initWithMemberCard:self.memberCard];
            redeemViewController.maskView = self.maskView;
            viewController = (UIViewController *)redeemViewController;
        }
            break;
            
        default:
            break;
    }
    
    
    if (viewController)
    {
        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        self.maskView.navi.navigationBarHidden = YES;
        self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
        [self.maskView addSubview:self.maskView.navi.view];
        [self.maskView show];
    }
}


#pragma mark -
#pragma mark PadNumberKeyboardDelegate Methods

- (void)didPadNumberKeyboardDonePressed:(UITextField*)textField
{
    [self didTextFieldEditDone:textField];
}

- (void)didTextFieldEditDone:(UITextField *)textField
{
    UIViewController *viewController = [self.maskView.navi.viewControllers lastObject];
    if ([viewController isKindOfClass:[PadCardOperateViewController class]])
    {
        PadCardOperateViewController *cardOperateViewController = (PadCardOperateViewController *)viewController;
        [cardOperateViewController didTextFieldEditDone:textField];
    }
    else if ([viewController isKindOfClass:[PadRefundViewController class]])
    {
        PadRefundViewController *refundViewController = (PadRefundViewController *)viewController;
        [refundViewController didTextFieldEditDone:textField];
    }
}

@end
