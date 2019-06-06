//
//  OperateHeadCell.m
//  Boss
//
//  Created by lining on 16/5/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "OperateHeadCell.h"

@implementation OperateHeadCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
