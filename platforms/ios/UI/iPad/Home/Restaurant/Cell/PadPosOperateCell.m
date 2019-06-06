//
//  PadPosOperateCell.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadPosOperateCell.h"

@implementation PadPosOperateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0, kPadPosOperateCellHeight/2.0 - 22.0, kPadPosOperateCellWidth - 2 * 24.0 - 64.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.font = IOS7FONT(16.0);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadPosOperateCellWidth - 24.0 - 64.0, kPadPosOperateCellHeight/2.0 - 22.0, 64.0, 20.0)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.numberOfLines = 1;
        self.timeLabel.font = IOS7FONT(16.0);
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.contentView addSubview:self.timeLabel];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0, kPadPosOperateCellHeight/2.0 + 2.0, kPadPosOperateCellWidth - 3 * 24.0 - 12.0 - 64.0, 20.0)];
        self.phoneLabel.backgroundColor = [UIColor clearColor];
        self.phoneLabel.numberOfLines = 1;
        self.phoneLabel.font = IOS7FONT(14.0);
        self.phoneLabel.textAlignment = NSTextAlignmentLeft;
        self.phoneLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.phoneLabel];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadPosOperateCellWidth - 24.0 - 64.0, kPadPosOperateCellHeight/2.0 + 2.0, 64.0, 20.0)];
        self.numberLabel.backgroundColor = [UIColor clearColor];
        self.numberLabel.numberOfLines = 1;
        self.numberLabel.font = IOS7FONT(14.0);
        self.numberLabel.textAlignment = NSTextAlignmentRight;
        self.numberLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self.contentView addSubview:self.numberLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadPosOperateCellHeight - 1.0, kPadPosOperateCellWidth, 1.0)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"pad_project_side_line"];
        [self.contentView addSubview:lineImageView];
    }
    
    return self;
}

@end
