//
//  BNSelectCell.m
//  Boss
//
//  Created by XiaXianBing on 15/6/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSSelectCell.h"

#define kBSSelectCellHeight         44.0
#define kBSSelectCellMargin         16.0
#define kBSSelectCellArrowSize      32.0

@interface BSSelectCell ()
@property(nonatomic, strong) UIImageView *lineImageView;
@end

@implementation BSSelectCell

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
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBSSelectCellMargin, 0.0, IC_SCREEN_WIDTH - 2 * kBSSelectCellMargin - kBSSelectCellArrowSize, kBSSelectCellHeight)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.titleLabel];
        
        self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kBSSelectCellMargin - kBSSelectCellArrowSize, (kBSSelectCellHeight - kBSSelectCellArrowSize)/2.0, kBSSelectCellArrowSize, kBSSelectCellArrowSize)];
        self.selectImageView.backgroundColor = [UIColor clearColor];
        self.selectImageView.image = [UIImage imageNamed:@"option_selected"];
        self.selectImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.selectImageView.hidden = YES;
        [self.contentView addSubview:self.selectImageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.lineImageView == nil)
    {
        self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.contentView.frame.size.height - 0.5, IC_SCREEN_WIDTH, 0.5)];
        self.lineImageView.backgroundColor = [UIColor clearColor];
        self.lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [self.contentView addSubview:self.lineImageView];
    }
}

@end
