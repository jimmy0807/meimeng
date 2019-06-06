//
//  CardProjectCell.m
//  Boss
//
//  Created by lining on 16/3/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "CardProjectCell.h"

@implementation CardProjectCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    // Initialization code
}

- (void)setArrowImgHidden:(BOOL)arrowImgHidden
{
    if (self.arrowImg.hidden == arrowImgHidden) {
        return;
    }
    _arrowImgHidden = arrowImgHidden;
    self.arrowImg.hidden = arrowImgHidden;
    if (arrowImgHidden) {
        [self.contentView removeConstraint:self.arrowImgLeadingConstraint];
    }
    else
    {
        [self.contentView addConstraint:self.arrowImgLeadingConstraint];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
