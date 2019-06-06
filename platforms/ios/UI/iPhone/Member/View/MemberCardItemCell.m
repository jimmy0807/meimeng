//
//  MemberCardItemCell.m
//  Boss
//
//  Created by mac on 15/7/28.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "MemberCardItemCell.h"

@implementation MemberCardItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.numberOfLines = 2;
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.countLabel.font = [UIFont systemFontOfSize:14];
    self.priceLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

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
