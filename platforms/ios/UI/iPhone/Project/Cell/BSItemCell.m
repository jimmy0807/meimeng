//
//  BSItemCell.m
//  Boss
//
//  Created by XiaXianBing on 15/6/1.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSItemCell.h"

#define kBSEditCellMargin       12.0
#define kBSItemCellImageWidth   48.0
#define kBSItemCellImageHeight  36.0
#define kBSEditCellArrowSize    16.0

@interface BSItemCell ()
@property(nonatomic, strong) UIImageView *lineImageView;
@end


@implementation BSItemCell

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
        
        self.itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kBSEditCellMargin, (kBSItemCellHeight - kBSItemCellImageHeight)/2.0, kBSItemCellImageWidth, kBSItemCellImageHeight)];
        self.itemImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.itemImageView];
        
//        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:self.itemImageView.bounds];
//        maskImageView.backgroundColor = [UIColor clearColor];
//        maskImageView.image = [UIImage imageNamed:@"item_image_n"];
//        maskImageView.highlightedImage = [UIImage imageNamed:@"item_image_h"];
//        [self.itemImageView addSubview:maskImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBSEditCellMargin + kBSItemCellImageWidth + 12.0, kBSItemCellHeight/2.0 - 20.0 + 2.0, IC_SCREEN_WIDTH - 2*kBSEditCellMargin - kBSItemCellImageWidth - 12.0 - kBSEditCellArrowSize, 20.0)];
        self.titleLabel.highlighted = NO;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBSEditCellMargin + kBSItemCellImageWidth + 12.0, kBSItemCellHeight/2.0 + 2.0, IC_SCREEN_WIDTH - 2*kBSEditCellMargin - kBSItemCellImageWidth - 12.0 - kBSEditCellArrowSize, 20.0)];
        self.detailLabel.highlighted = NO;
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize:13.0];
        self.detailLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [self.contentView addSubview:self.detailLabel];
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kBSEditCellMargin - kBSEditCellArrowSize, (kBSItemCellHeight - kBSEditCellArrowSize)/2.0, kBSEditCellArrowSize, kBSEditCellArrowSize)];
        self.arrowImageView.backgroundColor = [UIColor clearColor];
        self.arrowImageView.image = [UIImage imageNamed:@"project_item_arrow"];
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
    }
}


@end
