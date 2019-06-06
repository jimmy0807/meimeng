//
//  PadMaskView.m
//  Boss
//
//  Created by XiaXianBing on 15/10/22.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadMaskView.h"

#define kPadMaskViewBackgroundTag   999

@interface PadMaskView ()
{
    BOOL isAnimation;
}

@end

@implementation PadMaskView

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT)];
    if (self)
    {
        self.alpha = 0.0;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *background = [UIButton buttonWithType:UIButtonTypeCustom];
        background.frame = self.bounds;
        background.backgroundColor = [UIColor blackColor];
        background.alpha = 0.5;
        background.tag = kPadMaskViewBackgroundTag;
        [background addTarget:self action:@selector(didBackgroundClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:background];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.alpha = 0.0;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *background = [UIButton buttonWithType:UIButtonTypeCustom];
        background.frame = self.bounds;
        background.backgroundColor = [UIColor blackColor];
        background.alpha = 0.5;
        background.tag = kPadMaskViewBackgroundTag;
        [background addTarget:self action:@selector(didBackgroundClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:background];
    }
    
    return self;
}

- (void)didBackgroundClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadMaskViewBackgroundClick:)])
    {
        [self.delegate didPadMaskViewBackgroundClick:self];
    }
}

- (void)show
{
    if (isAnimation)
    {
        return;
    }
    
    isAnimation = YES;
    self.navi.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.navi.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 1.0;
        self.navi.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        isAnimation = NO;
    }];
}

- (void)hidden
{
    if (isAnimation)
    {
        return;
    }
    
    isAnimation = YES;
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        isAnimation = NO;
        [self removeSubviews];
    }];
}

- (void)removeSubviews
{
    for (UIView *subview in self.subviews)
    {
        if (subview.tag != kPadMaskViewBackgroundTag)
        {
            [subview removeFromSuperview];
        }
    }
    
    self.navi = nil;
}

@end
