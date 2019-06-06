//
//  MenuOperateCell.m
//  Boss
//
//  Created by mac on 15/8/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "MenuOperateCell.h"

@implementation MenuOperateCell

- (void)awakeFromNib
{
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.contentView.frame.size.height - 0.5, IC_SCREEN_WIDTH, 0.5)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [self.contentView addSubview:lineImageView];
}

@end
