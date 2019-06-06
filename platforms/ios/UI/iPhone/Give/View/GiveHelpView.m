//
//  GiveHelpView.m
//  Boss
//
//  Created by lining on 16/9/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GiveHelpView.h"
#import "UIImage+Resizable.h"

@interface GiveHelpView ()
@property (strong, nonatomic) IBOutlet UIButton *bgBtn;
@property (strong, nonatomic) IBOutlet UILabel *couponTipLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardTipLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation GiveHelpView
+ (instancetype)createView
{
    GiveHelpView *helpView = [self loadFromNib];
    [[UIApplication sharedApplication].keyWindow addSubview:helpView];
    helpView.backgroundColor = [UIColor clearColor];
    helpView.alpha = 0;
    [helpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    helpView.imgView.image = [[UIImage imageNamed:@"phone_give_help_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    helpView.couponTipLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 30 - 30;
    helpView.cardTipLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 30 - 30;
    return helpView;
}


- (void)show
{
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 0.0;
    }];
}
- (IBAction)hideBtnPressed:(id)sender {
    [self hide];
}

@end
