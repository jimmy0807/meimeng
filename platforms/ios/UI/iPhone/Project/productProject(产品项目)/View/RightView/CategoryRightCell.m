//
//  rightCell.m
//  Boss
//
//  Created by jiangfei on 16/5/25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "CategoryRightCell.h"
#import "rightModel.h"
@interface CategoryRightCell ()

@end

@implementation CategoryRightCell

- (void)awakeFromNib
{
    [super awakeFromNib];
   
    self.rightView.hidden = YES;
    self.titleLabel.font = projectContentFont;
    self.countLabel.font = projectSmallFont;
    self.countLabel.textColor = projectTextFieldColor;
}

@end
