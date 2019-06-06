//
//  ItemArrowCell.m
//  Boss
//
//  Created by lining on 16/9/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ItemArrowCell.h"

@interface ItemArrowCell ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineTailingConstraint;
@end

@implementation ItemArrowCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLineLeadingConstant:(CGFloat)lineLeadingConstant
{
    self.lineLeadingConstraint.constant = lineLeadingConstant;
}

- (void)setLineTailingConstant:(CGFloat)lineTailingConstant
{
    self.lineTailingConstraint.constant = lineTailingConstant;
}

@end
