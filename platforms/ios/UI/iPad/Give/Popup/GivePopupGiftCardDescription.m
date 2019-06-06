//
//  GivePopupGiftCardDescription.m
//  Boss
//
//  Created by jimmy on 16/6/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GivePopupGiftCardDescription.h"

@implementation GivePopupGiftCardDescription

+ (instancetype)show
{
    GivePopupGiftCardDescription* v = [[[NSBundle mainBundle] loadNibNamed:@"GivePopupGiftCardDescription" owner:self options:nil] objectAtIndex:0];
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    
    v.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        v.alpha = 1;
    }];
    
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

@end
