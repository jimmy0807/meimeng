//
//  BSItemAddCell.m
//  Boss
//
//  Created by XiaXianBing on 15/8/18.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSItemAddCell.h"

#define kBSItemAddCellMargin    16.0
#define kBSItemAddImageSize     32.0

@interface BSItemAddCell ()
@property(nonatomic, strong) UIImageView *lineImageView;
@end


@implementation BSItemAddCell

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
        
        self.addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kBSItemAddCellMargin, (kBSItemAddCellHeight - kBSItemAddImageSize)/2.0, kBSItemAddImageSize, kBSItemAddImageSize)];
        self.addImageView.backgroundColor = [UIColor clearColor];
        self.addImageView.image = [UIImage imageNamed:@"navi_add_h"];
        [self.contentView addSubview:self.addImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((IC_SCREEN_WIDTH - self.addImageView.frame.size.width)/2.0, (kBSItemAddCellHeight - 20.0)/2.0, IC_SCREEN_WIDTH - self.addImageView.frame.size.width , 20.0)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
        self.titleLabel.tag = 102;
        [self.contentView addSubview:self.titleLabel];
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

- (void)setTitle:(NSString *)title addImageViewHidden:(BOOL)hidden
{
    self.titleLabel.text = title;
    if (hidden)
    {
        self.addImageView.hidden = YES;
        self.titleLabel.frame = CGRectMake(0.0, (kBSItemAddCellHeight - 20.0)/2.0, IC_SCREEN_WIDTH, 20.0);
    }
    else
    {
        self.addImageView.hidden = NO;
        CGSize minSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font forWidth:IC_SCREEN_WIDTH lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat origin = (IC_SCREEN_WIDTH - self.addImageView.frame.size.width - minSize.width)/2.0;
        self.addImageView.frame = CGRectMake(origin, self.addImageView.frame.origin.y, self.addImageView.frame.size.width, self.addImageView.frame.size.height);
        self.titleLabel.frame = CGRectMake(self.addImageView.frame.origin.x + self.addImageView.frame.size.width, (kBSItemAddCellHeight - 20.0)/2.0, minSize.width, 20.0);
    }
}

@end
