//
//  GivePopupSelectWXGiveType.m
//  Boss
//
//  Created by jimmy on 16/6/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GivePopupSelectWXGiveType.h"
#import "UIImage+Resizable.h"
#import "GivePopupInputPhoneNumber.h"
#import "PadMaskView.h"
#import "PadWxGiveSuccessViewController.h"
#import "FetchWXCouponCardAddressUrlRequest.h"

@interface GivePopupSelectWXGiveType ()
@property(nonatomic, weak)IBOutlet UIButton* generateQrCodeButton;
@property(nonatomic, weak)IBOutlet UIButton* directGiveButton;
@property(nonatomic, weak)UINavigationController* outNavigationController;
@property(nonatomic, weak)PadMaskView *maskView;
@property(nonatomic, weak)CDMember* member;
@property(nonatomic, weak)NSArray* wxCardTemplates;
@property(nonatomic, strong)NSString* wxQrCodeUrl;
@end

@implementation GivePopupSelectWXGiveType

+ (instancetype)showWithNavigationController:(UINavigationController*)navigationController member:(CDMember*)member wxCardTemplates:(NSArray*)wxCardTemplates
{
    UIViewController *viewController = [[UIViewController alloc] init];
    
    GivePopupSelectWXGiveType* v = [[[NSBundle mainBundle] loadNibNamed:@"GivePopupSelectWXGiveType" owner:self options:nil] objectAtIndex:0];
    viewController.view.frame = CGRectMake(149, 0.0, 725, IC_SCREEN_HEIGHT);
    [viewController.view addSubview:v];
    
    PadMaskView* maskView = [[PadMaskView alloc] init];
    v.maskView = maskView;
    
    v.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
    v.maskView.navi.navigationBarHidden = YES;
    v.maskView.navi.view.frame = CGRectMake(149, 0.0, 725, IC_SCREEN_HEIGHT);
    [v.maskView addSubview:v.maskView.navi.view];
    [v.maskView show];
    
    [navigationController.topViewController.view addSubview:v.maskView];
    //[[UIApplication sharedApplication].keyWindow addSubview:v.maskView];

    v.outNavigationController = navigationController;
    v.member = member;
    v.wxCardTemplates = wxCardTemplates;
    
    [v registerNofitificationForMainThread:kFetchWXCouponCardAddressUrlResponse];
    
    FetchWXCouponCardAddressUrlRequest* request = [[FetchWXCouponCardAddressUrlRequest alloc] initWithWxCardTemplates:v.wxCardTemplates phoneNumber:v.member.mobile];
    [request execute];
    
    return v;
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kFetchWXCouponCardAddressUrlResponse])
    {
        NSDictionary* retDict = notification.userInfo;
        if ([retDict isKindOfClass:[NSDictionary class]])
        {
            NSNumber *errorRet = [retDict numberValueForKey:@"errcode"];
            if (errorRet.integerValue == 0)
            {
                NSDictionary* params = retDict[@"data"];
                if ( [params isKindOfClass:[NSDictionary class]] )
                {
                    self.wxQrCodeUrl = params[@"url"];
                }
            }
        }
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.generateQrCodeButton setBackgroundImage:[[UIImage imageNamed:@"pad_payment_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateNormal];
    [self.directGiveButton setBackgroundImage:[[UIImage imageNamed:@"pad_payment_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateNormal];
}

- (void)hide
{
    [UIView animateWithDuration:0.15 animations:^{
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        //self.maskView = nil;
    }];
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self hide];
}

- (IBAction)didGenerateQrCodeButtonPressed:(id)sender
{
    PadWxGiveSuccessViewController* vc = [[PadWxGiveSuccessViewController alloc] initWithNibName:@"PadWxGiveSuccessViewController" bundle:nil];
    vc.wxCardTemplates = self.wxCardTemplates;
    vc.successType = PadWxGiveSuccessType_WxGiftCard;
    vc.wxQrCodeUrl = self.wxQrCodeUrl;
    [self.outNavigationController pushViewController:vc animated:YES];
    
    [self performSelector:@selector(deleayToHideMaskView) withObject:nil afterDelay:0.5];
}

- (void)deleayToHideMaskView
{
    [self hide];
}

- (IBAction)didDirectGiveButtonPressed:(id)sender
{
    GivePopupInputPhoneNumber* v = [GivePopupInputPhoneNumber createView];
    UIViewController* tempVc = [[UIViewController alloc] init];
    tempVc.view.backgroundColor = [UIColor whiteColor];
    tempVc.view.frame = CGRectMake(149, 0.0, 725, IC_SCREEN_HEIGHT);
    [tempVc.view addSubview:v];
    
    v.outNavigationController = self.outNavigationController;
    v.member = self.member;
    v.wxCardTemplates = self.wxCardTemplates;
    v.maskView = self.maskView;
    
    [self.maskView.navi pushViewController:tempVc animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
