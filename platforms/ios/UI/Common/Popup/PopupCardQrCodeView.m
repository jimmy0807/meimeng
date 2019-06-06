//
//  PopupCardQrCodeView.m
//  Boss
//
//  Created by jimmy on 16/5/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PopupCardQrCodeView.h"
#import "WXCardBindingRequest.h"
#import "QRCodeGenerator.h"

@interface PopupCardQrCodeView ()
@property(nonatomic, weak)IBOutlet UIImageView* qrCodeImageView;
@property(nonatomic, strong)CDMemberCard* card;
@end

@implementation PopupCardQrCodeView

+ (instancetype)showWithMemberCard:(CDMemberCard*)card
{
    PopupCardQrCodeView* v = [[[NSBundle mainBundle] loadNibNamed:@"PopupCardQrCodeView" owner:self options:nil] objectAtIndex:0];
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    
    v.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        v.alpha = 1;
    }];
    
    [v registerNofitificationForMainThread:kWeixinCardBindingResponse];
    
    v.card = card;
    
    WXCardBindingRequest* request = [[WXCardBindingRequest alloc] initWithMemberCard:card];
    [request execute];
    
    return v;
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)didBlankButtonPressed:(id)sender
{
    [self hide];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kWeixinCardBindingResponse])
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
                    NSString* url = params[@"url"];
                    self.qrCodeImageView.image = [QRCodeGenerator qrImageForString:url imageSize:400];
                }
            }
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
