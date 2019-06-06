//
//  MemberItemCell.m
//  Boss
//
//  Created by lining on 16/4/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberItemCell.h"

@implementation MemberItemCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)setArrowImgViewHidden:(BOOL)arrowImgViewHidden
{
    if (_arrowImgViewHidden == arrowImgViewHidden) {
        return;
    }
    _arrowImgViewHidden = arrowImgViewHidden;
    self.arrowImgView.hidden = arrowImgViewHidden;
    if (arrowImgViewHidden) {
        [self.contentView removeConstraint:self.arrowImgLeaingConstraint];
    }
    else
    {
        [self.contentView addConstraint:_arrowImgLeaingConstraint];
        
    }

}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
