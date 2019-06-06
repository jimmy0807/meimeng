//
//  IndicatorCollectionViewCell.m
//  Boss
//
//  Created by lining on 16/9/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "IndicatorCollectionViewCell.h"

@implementation IndicatorCollectionViewCell

- (void)setIndicatorView:(UIView *)indicatorView
{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    _indicatorView = indicatorView;
    [self.contentView addSubview:indicatorView];
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
}

@end
