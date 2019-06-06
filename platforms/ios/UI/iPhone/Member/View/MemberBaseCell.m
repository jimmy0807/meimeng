//
//  MemberBaseCell.m
//  Boss
//
//  Created by lining on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberBaseCell.h"
#import "Masonry.h"

@implementation MemberBaseCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIImageView *lineImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bs_table_view_cell_line.png"]];
    [self.contentView addSubview:lineImgView];
    
    UIView *superView = self.contentView;
    [lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(superView.mas_leading).offset(10);
        make.trailing.mas_equalTo(superView.mas_trailing);
        make.bottom.mas_equalTo(superView.mas_bottom);
        make.height.mas_equalTo(@0.5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
