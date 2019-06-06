//
//  BSMessageCell.m
//  Boss
//
//  Created by XiaXianBing on 15/9/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSMessageCell.h"

#define kBSMessageCellMargin        16.0

@interface BSMessageCell ()
@property(nonatomic, strong) UIImageView *lineImageView;
@end


@implementation BSMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.autoresizingMask = 0xff;
        self.contentView.autoresizingMask = 0xff;
        self.backgroundColor = COLOR(255.0, 255.0, 255.0, 1.0);
        self.selectedBackgroundView.autoresizingMask = 0xff;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBSMessageCellMargin, 12.0, IC_SCREEN_WIDTH - 2 * kBSMessageCellMargin - 120.0, 20.0)];
        self.titleLabel.highlighted = NO;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        self.titleLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBSMessageCellMargin, 32.0, IC_SCREEN_WIDTH - 2 * kBSMessageCellMargin, 40.0)];
        self.detailLabel.highlighted = NO;
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize:14.0];
        self.detailLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        self.detailLabel.numberOfLines = 2;
        [self.contentView addSubview:self.detailLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kBSMessageCellMargin - 120.0, self.titleLabel.frame.origin.y, 120.0, 20.0)];
        self.timeLabel.highlighted = NO;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont systemFontOfSize:13.0];
        self.timeLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [self.contentView addSubview:self.timeLabel];
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
