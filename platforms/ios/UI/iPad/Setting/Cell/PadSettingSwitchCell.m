//
//  PadSettingSwitchCell.m
//  Boss
//
//  Created by XiaXianBing on 15/12/1.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadSettingSwitchCell.h"
#import "UIImage+Resizable.h"
#import "PadSettingConstant.h"

#define kPadSettingSwitchCellWidth      (kPadSettingRightSideViewWidth - 2 * 32.0)
#define kPadSettingSwitchCellHeight     60.0
#define kPadSettingSwitchWidth          52.0
#define kPadSettingSwitchHeight         34.0

@implementation PadSettingSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *normalImageView = [[UIImageView alloc] init];
        normalImageView.backgroundColor = [UIColor clearColor];
        normalImageView.image = [[UIImage imageNamed:@"pad_setting_cell_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        self.backgroundView = normalImageView;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, (kPadSettingSwitchCellHeight - 20.0)/2.0, kPadSettingSwitchCellWidth - 2 * 20.0 - kPadSettingSwitchWidth, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel];
        
        self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.switchButton.frame = CGRectMake(kPadSettingSwitchCellWidth - 20.0 - kPadSettingSwitchWidth, (kPadSettingSwitchCellHeight - kPadSettingSwitchHeight)/2.0, kPadSettingSwitchWidth, kPadSettingSwitchHeight);
        self.switchButton.backgroundColor = [UIColor clearColor];
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"pad_switch_off"] forState:UIControlStateNormal];
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"pad_switch_off"] forState:UIControlStateHighlighted];
        [self.switchButton addTarget:self action:@selector(didSwitchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.switchButton];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadSettingSwitchButtonClick:)])
    {
        [self.delegate didPadSettingSwitchButtonClick:self];
    }
}


@end
