//
//  CardRepaymentCell.m
//  Boss
//
//  Created by lining on 16/6/17.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "CardRepaymentCell.h"

@implementation CardRepaymentCell

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

@end
