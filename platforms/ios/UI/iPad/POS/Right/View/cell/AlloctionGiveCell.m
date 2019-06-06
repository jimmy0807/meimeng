//
//  AlloctionGiveCell.m
//  Boss
//
//  Created by lining on 15/10/22.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "AlloctionGiveCell.h"
#import "UIView+LoadNib.h"

@implementation AlloctionGiveCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.imgView.highlighted = isSelected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
