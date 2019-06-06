//
//  PosOperateItemCell.m
//  Boss
//
//  Created by lining on 16/8/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateItemCell.h"

@implementation PosOperateItemCell

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
}


@end
