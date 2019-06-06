//
//  BSCommonCell.m
//  Boss
//
//  Created by XiaXianBing on 15/6/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSCommonCell.h"

#define kBSCommonCellHeight         44.0
#define kBSCommonCellMargin         16.0
#define kBSCommonCellArrowSize      16.0

@interface BSCommonCell ()
@property(nonatomic, strong) UIImageView *lineImageView;
@end

@implementation BSCommonCell

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
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBSCommonCellMargin, kBSCommonCellHeight/2.0 - 20.0 + 1.0, IC_SCREEN_WIDTH - 2 * kBSCommonCellMargin - kBSCommonCellArrowSize - 64.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        self.titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBSCommonCellMargin, kBSCommonCellHeight/2.0 + 2.0, IC_SCREEN_WIDTH - 2 * kBSCommonCellMargin - kBSCommonCellArrowSize - 64.0, 20.0)];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.detailLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        self.detailLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.detailLabel];
        
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kBSCommonCellMargin - kBSCommonCellArrowSize - 64.0, (kBSCommonCellHeight - 20.0)/2.0, 64.0, 20.0)];
        self.valueLabel.backgroundColor = [UIColor clearColor];
        self.valueLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.valueLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.valueLabel];
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kBSCommonCellMargin - kBSCommonCellArrowSize, (kBSCommonCellHeight - kBSCommonCellArrowSize)/2.0, kBSCommonCellArrowSize, kBSCommonCellArrowSize)];
        self.arrowImageView.backgroundColor = [UIColor clearColor];
        self.arrowImageView.image = [UIImage imageNamed:@"bs_common_arrow"];
        self.arrowImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:self.arrowImageView];
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
        
        CGFloat titleWidth = IC_SCREEN_WIDTH - 2 * kBSCommonCellMargin;
        if (!self.arrowImageView.hidden)
        {
            titleWidth -= kBSCommonCellArrowSize;
        }
        if (!self.valueLabel.hidden)
        {
            titleWidth -= 64.0;
            self.valueLabel.frame = CGRectMake(titleWidth + kBSCommonCellMargin, self.valueLabel.frame.origin.y, self.valueLabel.frame.size.width, self.valueLabel.frame.size.height);
        }
        
        self.titleLabel.frame = CGRectMake(kBSCommonCellMargin, self.titleLabel.frame.origin.y, titleWidth, self.titleLabel.frame.size.height);
        self.detailLabel.frame = CGRectMake(kBSCommonCellMargin, self.detailLabel.frame.origin.y, titleWidth, self.detailLabel.frame.size.height);
    }
}

@end
