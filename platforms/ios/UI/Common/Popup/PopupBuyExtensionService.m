//
//  PopupBuyExtensionService.m
//  Boss
//
//  Created by jimmy on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PopupBuyExtensionService.h"
#import "PadWebViewController.h"

@implementation PopupBuyExtensionService

+ (instancetype)show
{
    return [PopupBuyExtensionService showWithNavigationController:nil url:nil];
}

+ (instancetype)showWithNavigationController:(UINavigationController*)navigationController url:(NSString*)url
{
    PopupBuyExtensionService* v = [[[NSBundle mainBundle] loadNibNamed:@"PopupBuyExtensionService" owner:self options:nil] objectAtIndex:0];
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    
    v.alpha = 0;
    v.navigationController = navigationController;
    v.url = url;
    
    [UIView animateWithDuration:0.2 animations:^{
        v.alpha = 1;
    }];
    
    return v;
}

- (IBAction)didOKButtonPressed:(id)sender
{
    PadWebViewController* webViewController = [[PadWebViewController alloc] initWithUrl:self.url];
    webViewController.isCloseButton = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
    
    [self hide];
}

- (IBAction)didCancelButtonPressed:(id)sender
{
    [self hide];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
