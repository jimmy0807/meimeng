//
//  PadProjectUserSelectView.m
//  Boss
//
//  Created by XiaXianBing on 15/10/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectUserSelectView.h"

@interface PadProjectUserSelectView ()

@property (nonatomic, assign) BOOL isAnimation;

@end

@implementation PadProjectUserSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, 0.0, kPadProjectSideViewWidth, 60.0);
        [button setBackgroundImage:[UIImage imageNamed:@"pad_highlighted_button_n"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"pad_highlighted_button_h"] forState:UIControlStateHighlighted];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:LS(@"PadSelectMember") forState:UIControlStateNormal];
        button.tag = kProjectSelectMember;
        [button addTarget:self action:@selector(didUserSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 60.0 - 1.0, kPadProjectSideViewWidth, 1.0)];
        lineView.backgroundColor = COLOR(207.0, 230.0, 230.0, 1.0);
        [self addSubview:lineView];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, 60.0, kPadProjectSideViewWidth, 60.0);
        [button setBackgroundImage:[UIImage imageNamed:@"pad_highlighted_button_n"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"pad_highlighted_button_h"] forState:UIControlStateHighlighted];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:LS(@"PadAddHandGrade") forState:UIControlStateNormal];
        button.tag = kProjectAddHandGrade;
        [button addTarget:self action:@selector(didUserSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 2 * 60.0 - 1.0, kPadProjectSideViewWidth, 1.0)];
        lineView.backgroundColor = COLOR(207.0, 230.0, 230.0, 1.0);
        [self addSubview:lineView];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, 60.0 * 2, kPadProjectSideViewWidth, 60.0);
        [button setBackgroundImage:[UIImage imageNamed:@"pad_highlighted_button_n"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"pad_highlighted_button_h"] forState:UIControlStateHighlighted];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:LS(@"PadSelectGiftCardVouchers") forState:UIControlStateNormal];
        button.tag = kProjectAddGiftCardVouchers;
        [button addTarget:self action:@selector(didUserSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIButton *blankButton = [UIButton buttonWithType:UIButtonTypeCustom];
        blankButton.backgroundColor = [UIColor clearColor];
        blankButton.frame = CGRectMake(0.0, kUserSelectContentHeight, self.frame.size.width, IC_SCREEN_HEIGHT - kPadNaviHeight - kPadConfirmButtonHeight - kUserSelectContentHeight);
        [blankButton addTarget:self action:@selector(didBlankButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:blankButton];
    }
    
    return self;
}

- (void)didBlankButtonClick:(id)sender
{
    if (self.isAnimation)
    {
        return;
    }
    
    [self hide];
}

- (void)reloadWithMember:(CDMember *)member
{
    UIButton *button = [self viewWithTag:kProjectAddGiftCardVouchers];
    if (member == nil || member.isDefaultCustomer.boolValue || member.coupons.count == 0)
    {
        [button setTitle:LS(@"PadSelectGiftCardVouchers") forState:UIControlStateNormal];
    }
    else
    {
        [button setTitle:[NSString stringWithFormat:LS(@"PadSelectGiftCardNum"), member.coupons.count] forState:UIControlStateNormal];
    }
}

- (void)didUserSelectButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadProjectUserSelectButtonClick:)])
    {
        UIButton *button = (UIButton *)sender;
        [self.delegate didPadProjectUserSelectButtonClick:button.tag];
    }
    
    if (self.isAnimation)
    {
        return;
    }
    [self hide];
}

- (void)didUserSelectViewButtonClick
{
    if (self.isAnimation)
    {
        return;
    }
    
    if (self.frame.origin.y == kPadNaviHeight - kUserSelectContentHeight)
    {
        [self show];
    }
    else if (self.frame.origin.y == kPadNaviHeight)
    {
        [self hide];
    }
}

- (void)show
{
    self.isAnimation = YES;
    [UIView animateWithDuration:0.32 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, kPadNaviHeight, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.isAnimation = NO;
        self.frame = CGRectMake(self.frame.origin.x, kPadNaviHeight, self.frame.size.width, IC_SCREEN_HEIGHT - kPadNaviHeight - kPadConfirmButtonHeight);
    }];
}

- (void)hide
{
    self.isAnimation = YES;
    [UIView animateWithDuration:0.32 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, kPadNaviHeight - kUserSelectContentHeight, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.isAnimation = NO;
        self.frame = CGRectMake(self.frame.origin.x, kPadNaviHeight - kUserSelectContentHeight, self.frame.size.width, kUserSelectContentHeight);
    }];
}

@end
