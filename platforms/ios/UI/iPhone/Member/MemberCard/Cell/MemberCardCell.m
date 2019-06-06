//
//  MemberCardCell.m
//  Boss
//
//  Created by lining on 16/3/25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardCell.h"

@interface MemberCardCell ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowImgLeaingConstraint;

@end

@implementation MemberCardCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
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



@end
