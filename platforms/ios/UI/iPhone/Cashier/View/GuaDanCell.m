//
//  GuaDanCell.m
//  Boss
//
//  Created by lining on 16/7/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GuaDanCell.h"

@implementation GuaDanCell

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
