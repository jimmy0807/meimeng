//
//  MessageContentCell.m
//  Boss
//
//  Created by lining on 16/6/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MessageContentCell.h"

@implementation MessageContentCell

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
