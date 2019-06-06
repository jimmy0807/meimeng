//
//  SpecificationBaseAttributeValueCell.m
//  Boss
//
//  Created by jiangfei on 16/7/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "SpecificationBaseAttributeValueCell.h"

@implementation SpecificationBaseAttributeValueCell

-(void)setLine:(CDProjectAttributeLine *)line
{
    for (UIButton *btn in self.contentView.subviews) {
        [btn removeFromSuperview];
    }
    NSArray *arr = line.attributeValues.array;
    NSInteger count = arr.count;
    NSInteger col = 0;
    NSInteger row = 0;
    CGFloat marginX = 15;
    CGFloat marginY = 10;
    CGFloat  btnW = (IC_SCREEN_WIDTH - marginX*4)/3;
    CGFloat  btnH = 30;
    for (int i=0; i<count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CDProjectAttributeValue *value = line.attributeValues[i];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor redColor].CGColor;
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;

        //order_rect_red@2x
        [btn setTitle:value.attributeValueName forState:UIControlStateNormal];
        [btn setTitleColor:specificationColor forState:UIControlStateNormal];
        btn.titleLabel.font = projectSmallFont;
        row = i / 3;
        col = i % 3;
        CGFloat  btnX = marginX + col*(marginX+btnW);
        CGFloat  btnY = marginY + row*(marginY+btnH);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [self.contentView addSubview:btn];
    }
}
@end
