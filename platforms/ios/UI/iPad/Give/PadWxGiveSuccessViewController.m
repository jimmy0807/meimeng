//
//  PadWxGiveSuccessViewController.m
//  Boss
//
//  Created by jimmy on 16/6/2.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadWxGiveSuccessViewController.h"
#import "UIImage+Resizable.h"
#import "QRCodeGenerator.h"

@interface PadWxGiveSuccessViewController ()
@property(nonatomic, weak)IBOutlet UIView* tipsView;
@property(nonatomic, weak)IBOutlet UIView* successView;
@property(nonatomic, weak)IBOutlet UILabel* successCardCountLabel;
@property(nonatomic, weak)IBOutlet UIView* qrCodeView;
@property(nonatomic, weak)IBOutlet UIImageView* qrCodeImageView;
@property(nonatomic, weak)IBOutlet UIImageView* buttonBgImageView;
@property(nonatomic, weak)IBOutlet UIButton* yejiButton;
@property(nonatomic, weak)IBOutlet UIButton* giveButton;
@end

@implementation PadWxGiveSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.buttonBgImageView.image = [[UIImage imageNamed:@"pad_keyboard_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    
    [self.yejiButton setBackgroundImage:[[UIImage imageNamed:@"pad_card_allot_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)] forState:UIControlStateNormal];
    [self.yejiButton setBackgroundImage:[[UIImage imageNamed:@"pad_card_allot_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)] forState:UIControlStateHighlighted];
    [self.giveButton setBackgroundImage:[[UIImage imageNamed:@"pad_card_allot_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)] forState:UIControlStateNormal];
    [self.giveButton setBackgroundImage:[[UIImage imageNamed:@"pad_card_allot_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)] forState:UIControlStateHighlighted];
    
    if ( self.successType == PadWxGiveSuccessType_BornGiftCard )
    {
        self.qrCodeView.hidden = YES;
        self.successView.hidden = NO;
        self.tipsView.hidden = YES;
        self.successCardCountLabel.text = @"优惠券：1张";
    }
    else if ( self.successType == PadWxGiveSuccessType_WxGiftCard )
    {
        self.qrCodeView.hidden = NO;
        self.successView.hidden = YES;
        self.tipsView.hidden = YES;
        if ( self.wxQrCodeUrl.length > 0 )
        {
           self.qrCodeImageView.image = [QRCodeGenerator qrImageForString:self.wxQrCodeUrl imageSize:175];
        }
    }
    else if ( self.successType == PadWxGiveSuccessType_WxPhoneNumber )
    {
        self.qrCodeView.hidden = YES;
        self.successView.hidden = NO;
        self.tipsView.hidden = NO;
        self.successCardCountLabel.text = [NSString stringWithFormat:@"优惠券：%d张",self.wxCardTemplates.count];
    }
    
    [self registerNofitificationForMainThread:kFetchWXCouponCardAddressUrlResponse];
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
                    self.qrCodeImageView.image = [QRCodeGenerator qrImageForString:self.wxQrCodeUrl imageSize:175];
                }
            }
        }
    }
}

- (IBAction)didBackHomeButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)didYejiButtonPressed:(id)sender
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
}

- (IBAction)didGiveButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
