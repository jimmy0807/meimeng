//
//  CategoryCell.m
//  Boss
//
//  Created by jiangfei on 16/7/27.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected && selected) {
        selected = !selected;
    }
    [super setSelected:selected animated:animated];
   
}

@end
