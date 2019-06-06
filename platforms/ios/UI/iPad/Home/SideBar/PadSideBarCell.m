//
//  PadSideBarCell.m
//  BornPOS
//
//  Created by XiaXianBing on 15/10/9.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadSideBarCell.h"
#import "UIImage+Resizable.h"

#define kPadSideBarCellMargin       36.0
#define kPadSideBarCellIconWidth    30.0
#define kPadSideBarCellIconHeight   30.0


@interface PadSideBarCell ()

@end

@implementation PadSideBarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        UIImageView *background = [[UIImageView alloc] init];
        background.backgroundColor = [UIColor clearColor];
        self.backgroundView = background;
        self.selectedBackgroundView = background;
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadSideBarCellMargin, (kPadSideBarCellHeight - kPadSideBarCellIconHeight)/2.0, kPadSideBarCellIconWidth, kPadSideBarCellIconHeight)];
        self.iconImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.iconImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * kPadSideBarCellMargin + kPadSideBarCellIconWidth, (kPadSideBarCellHeight - 32.0)/2.0, 72.0, 32.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.titleLabel.textColor = COLOR(175.0, 249.0, 250.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.remindImageView = [[UIImageView alloc] init];
        self.remindImageView.backgroundColor = [UIColor clearColor];
        self.remindImageView.image = [[UIImage imageNamed:@"pad_remind_dot"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        self.remindImageView.frame = CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 12.0, (kPadSideBarCellHeight - 20.0)/2.0, 20.0, 20.0);
        self.remindImageView.hidden = NO;
        [self.contentView addSubview:self.remindImageView];
        
        self.remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0, 0.0, 8.0, 20.0)];
        self.remindLabel.backgroundColor = [UIColor clearColor];
        self.remindLabel.textColor = [UIColor whiteColor];
        self.remindLabel.textAlignment = NSTextAlignmentCenter;
        self.remindLabel.font = [UIFont systemFontOfSize:14.0];
        [self.remindImageView addSubview:self.remindLabel];
    }
    
    return self;
}


@end
