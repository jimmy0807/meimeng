//
//  GiveProjectCell.m
//  Boss
//
//  Created by lining on 15/10/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "GiveProjectCell.h"
#import "UIView+LoadNib.h"

@implementation GiveProjectCell

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
