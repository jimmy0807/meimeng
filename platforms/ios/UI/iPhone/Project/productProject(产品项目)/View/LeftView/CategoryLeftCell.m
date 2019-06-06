//
//  leftCell.m
//  Boss
//
//  Created by jiangfei on 16/5/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "CategoryLeftCell.h"
#import "CDProjectCategory+CoreDataClass.h"
#import "rightModel.h"


@interface CategoryLeftCell ()

@end

@implementation CategoryLeftCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = backView;
    self.titleNameView.font = projectContentFont;
    self.titleCountView.font = projectSmallFont;
    self.titleCountView.textColor = projectTextFieldColor;
}

//赋值
-(void)setCategory:(CDProjectCategory *)category
{
    _category = category;
    //title
    self.titleNameView.text = category.categoryName;
    //数量
    self.titleCountView.text = [NSString stringWithFormat:@"%@",category.itemCount];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
