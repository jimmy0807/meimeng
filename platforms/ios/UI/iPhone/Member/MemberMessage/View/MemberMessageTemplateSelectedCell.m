//
//  MemberMessageTemplateSelectedCell.m
//  Boss
//
//  Created by lining on 16/6/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberMessageTemplateSelectedCell.h"

@implementation MemberMessageTemplateSelectedCell
+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
