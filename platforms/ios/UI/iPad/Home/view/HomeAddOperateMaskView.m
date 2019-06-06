//
//  HomeAddOperateMaskView.m
//  Boss
//
//  Created by jimmy on 15/12/10.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "HomeAddOperateMaskView.h"

@interface HomeAddOperateMaskView ()
@property(nonatomic, weak)IBOutlet NSLayoutConstraint* topConstraint;
@end

@implementation HomeAddOperateMaskView

- (void)setTopY:(CGFloat)posY
{
    self.topConstraint.constant = posY;
}

- (void)show
{
    self.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    }];
}

- (IBAction)didBookedPosOperatePressed:(id)sender
{
    [self.delegate didBookedPosOperatePressed];
}

- (IBAction)didUnBookedPosOperatePressed:(id)sender
{
    [self.delegate didUnBookedPosOperatePressed];
}

- (IBAction)didEmptyButtonPressed:(id)sender
{
    [self hide];
}

@end
