//
//  GivePopupInputPhoneNumber.m
//  Boss
//
//  Created by jimmy on 16/6/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GivePopupInputPhoneNumber.h"
#import "UIImage+Resizable.h"
#import "PadWxGiveSuccessViewController.h"
#import "FetchWXCouponCardQrUrlRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"

@interface GivePopupInputPhoneNumber ()
@property(nonatomic, weak)IBOutlet UIImageView* textFieldBgImageView;
@property(nonatomic, weak)IBOutlet UIButton* confirmButton;
@property(nonatomic, weak)IBOutlet UITextField* phoneNumberTextField;
@end

@implementation GivePopupInputPhoneNumber

+ (instancetype)createView
{
    GivePopupInputPhoneNumber* v = [[[NSBundle mainBundle] loadNibNamed:@"GivePopupInputPhoneNumber" owner:self options:nil] objectAtIndex:0];
    
    [v registerNofitificationForMainThread:kFetchWXCouponCardQrUrlResponse];
    
    return v;
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kFetchWXCouponCardQrUrlResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        
        NSDictionary* retDict = notification.userInfo;
        if ([retDict isKindOfClass:[NSDictionary class]])
        {
            NSNumber *errorRet = [retDict numberValueForKey:@"errcode"];
            if (errorRet.integerValue == 0)
            {
                NSDictionary* params = retDict[@"data"];
                if ( [params isKindOfClass:[NSDictionary class]] )
                {
                    NSString* url = params[@"url"];
                    if ( url.length > 0 )
                    {
                        PadWxGiveSuccessViewController* vc = [[PadWxGiveSuccessViewController alloc] initWithNibName:@"PadWxGiveSuccessViewController" bundle:nil];
                        vc.wxCardTemplates = self.wxCardTemplates;
                        vc.successType = PadWxGiveSuccessType_WxPhoneNumber;
                        [self.outNavigationController pushViewController:vc animated:YES];
                        [self performSelector:@selector(deleayToHideMaskView) withObject:nil afterDelay:0.5];
                        
                        return;
                    }
                }
            }
            
            NSString* message = [retDict numberValueForKey:@"errmsg"];
            if ( message.length == 0 )
            {
                message = @"未知错误";
            }
            CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:message];
            [msgView show];
        }
    }
}

- (void)setMember:(CDMember *)member
{
    _member = member;
    
    self.phoneNumberTextField.text = member.mobile;
    self.confirmButton.enabled = YES;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textFieldBgImageView.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    [self.phoneNumberTextField becomeFirstResponder];
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self.maskView.navi popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.confirmButton.enabled = NO;
    
    if ( textField.text.length == 11 && ![string isEqualToString:@""] )
    {
        self.confirmButton.enabled = YES;
        return NO;
    }
    else if (range.location == 0 && ![string isEqualToString:@""])
    {
        return YES;
    }
    else if ( textField.text.length == 10 && string.length > 0 )
    {
        self.confirmButton.enabled = YES;
        [self performSelector:@selector(hideKeyBoard:) withObject:textField afterDelay:0.1];
        return YES;
    }
    
    return YES;
}

- (void)hideKeyBoard:(UITextField*)textField
{
    [textField resignFirstResponder];
}

- (IBAction)didConfirmButtonPressed:(id)sender
{
    FetchWXCouponCardQrUrlRequest* request = [[FetchWXCouponCardQrUrlRequest alloc] initWithWxCardTemplates:self.wxCardTemplates phoneNumber:self.phoneNumberTextField.text];
    [request execute];
    
    [[CBLoadingView shareLoadingView] show];
}

- (void)deleayToHideMaskView
{
    [UIView animateWithDuration:0.15 animations:^{
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
