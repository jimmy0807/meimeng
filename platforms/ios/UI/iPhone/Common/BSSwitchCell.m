//
//  BSSwitchCell.m
//  Boss
//
//  Created by XiaXianBing on 15/8/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSSwitchCell.h"

#define kBSSwitchCellHeight             50.0
#define kBSSwitchCellMargin             16.0
#define kBSSwitchCellSwitchWidth        53
#define kBSSwitchCellSwitchHeight       36


@interface BSSwitchCell ()

@property (nonatomic, strong) UIImageView *lineImageView;

@end

@implementation BSSwitchCell

@synthesize isSwitchOn = _isSwitchOn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.autoresizingMask = 0xff;
        self.contentView.autoresizingMask = 0xff;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bs_common_cell_n"]];
        self.backgroundView.autoresizingMask = 0xff;
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bs_common_cell_h"]];
        self.selectedBackgroundView.autoresizingMask = 0xff;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, (kBSSwitchCellHeight - 20.0)/2.0, IC_SCREEN_WIDTH - 2 * 16.0 - kBSSwitchCellSwitchWidth, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.titleLabel];
        
        self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.switchButton.frame = CGRectMake(IC_SCREEN_WIDTH - 16.0 - kBSSwitchCellSwitchWidth + 4.0, (kBSSwitchCellHeight - kBSSwitchCellSwitchHeight)/2.0 + 1, kBSSwitchCellSwitchWidth, kBSSwitchCellSwitchHeight);
        self.switchButton.backgroundColor = [UIColor clearColor];
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"switch_blue_off.png"] forState:UIControlStateNormal];
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"switch_blue_off.png"] forState:UIControlStateHighlighted];
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
        
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"switch_blue_on.png"] forState:UIControlStateNormal];
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"switch_blue_on.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"switch_blue_off.png"] forState:UIControlStateNormal];
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"switch_blue_off.png"] forState:UIControlStateHighlighted];
    }
}


- (void)didSwitchButtonClick:(id)sender
{
    self.isSwitchOn = !self.isSwitchOn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSwitchCellSwitchButtonClick:)])
    {
        [self.delegate didSwitchCellSwitchButtonClick:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ( self.lineImageView == nil )
    {
        self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.contentView.frame.size.height - 0.5, IC_SCREEN_WIDTH, 0.5)];
        self.lineImageView.backgroundColor = [UIColor clearColor];
        self.lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [self.contentView addSubview:self.lineImageView];
    }
}

@end
