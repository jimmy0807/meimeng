//
//  ShopCartCell.m
//  Boss
//
//  Created by lining on 16/7/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ShopCartCell.h"

@implementation ShopCartCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 50 - 12*2 -12;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
