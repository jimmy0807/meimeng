//
//  TemplateCell.m
//  Boss
//
//  Created by lining on 16/4/15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "TemplateCell.h"

@implementation TemplateCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
