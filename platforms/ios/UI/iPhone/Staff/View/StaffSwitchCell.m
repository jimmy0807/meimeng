//
//  StaffSwitchCell.m
//  Boss
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "StaffSwitchCell.h"
#define kBSEditCellHeight           49
#define kBSEditCellMargin           16.0
#define kBSEditCellArrowSize        16.0
#define kBSEditCellTitleWidth       96.0
#define kBSEditCellContentWidth   (IC_SCREEN_WIDTH - 2*kBSEditCellMargin - kBSEditCellTitleWidth - kBSEditCellArrowSize - 4.0)
@implementation StaffSwitchCell
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
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBSEditCellMargin, kBSEditCellMargin, kBSEditCellTitleWidth, kBSEditCellHeight-2*kBSEditCellMargin)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.titleLabel];
        
        self.cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kBSEditCellMargin - kBSEditCellArrowSize - 44, 10.0, 40, 20)];
        [self.cellSwitch addTarget:self action:@selector(cellSwitchClicked) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.cellSwitch];
        
    }
    
    return self;
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
        
        CGFloat origin = IC_SCREEN_WIDTH - kBSEditCellMargin - kBSEditCellContentWidth;
        if (!self.arrowImageView.hidden)
        {
            origin -= kBSEditCellArrowSize + 4.0;
        }
        //self.contentField.frame = CGRectMake(origin, self.contentField.frame.origin.y, self.contentField.frame.size.width, self.contentField.frame.size.height);
    }
}


+ (CGFloat)cellHeight
{
    return kBSEditCellHeight;
}

- (void)cellSwitchClicked
{
    if(self.delegate!=nil&&[self.delegate respondsToSelector:@selector(switchValueChanged:)])
    {
        [self.delegate switchValueChanged:self.cellSwitch.on];
    }
}
@end
