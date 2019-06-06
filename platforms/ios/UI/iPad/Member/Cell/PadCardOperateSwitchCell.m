//
//  PadCardOperateSwitchCell.m
//  Boss
//
//  Created by XiaXianBing on 16/1/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadCardOperateSwitchCell.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "PadMaskViewConstant.h"

@implementation PadCardOperateSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, 0.0, kPadMaskViewContentWidth, 60.0)];
        background.backgroundColor = [UIColor clearColor];
        background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        background.userInteractionEnabled = YES;
        [self.contentView addSubview:background];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, kPadMaskViewHalfContentWidth + 120.0 - 8.0, background.frame.size.height)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [background addSubview:self.titleLabel];
        
        self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.switchButton.frame = CGRectMake(kPadMaskViewContentWidth - 20.0 - kPadCardOperateSwitchWidth, (kPadCardOperateSwitchCellHeight - kPadCardOperateSwitchHeight)/2.0, kPadCardOperateSwitchWidth, kPadCardOperateSwitchHeight);
        self.switchButton.backgroundColor = [UIColor clearColor];
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"pad_switch_off"] forState:UIControlStateNormal];
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"pad_switch_off"] forState:UIControlStateHighlighted];
        [self.switchButton addTarget:self action:@selector(didSwitchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [background addSubview:self.switchButton];
    }
    
    return self;
}

- (void)setIsSwitchOn:(BOOL)isSwitchOn
{
    _isSwitchOn = isSwitchOn;
    if (_isSwitchOn)
    {
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"pad_switch_on"] forState:UIControlStateNormal];
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"pad_switch_on"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"pad_switch_off"] forState:UIControlStateNormal];
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"pad_switch_off"] forState:UIControlStateHighlighted];
    }
}

- (void)didSwitchButtonClick:(id)sender
{
    self.isSwitchOn = !self.isSwitchOn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadCardOperateSwitchButtonClick:)])
    {
        [self.delegate didPadCardOperateSwitchButtonClick:self];
    }
}

@end
