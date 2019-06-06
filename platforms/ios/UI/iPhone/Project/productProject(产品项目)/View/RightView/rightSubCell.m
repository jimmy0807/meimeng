//
//  rightSubCell.m
//  Boss
//
//  Created by jiangfei on 16/6/16.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "rightSubCell.h"

@implementation rightSubCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    // Initialization code
    
    UIColor *color = [UIColor colorWithRed:11/255.0 green:169/255.0 blue:250/255.0 alpha:1];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"project_sub_category_cell_h"]];
    self.selectedBackgroundView = backView;
    self.textLabel.highlightedTextColor = color;
    self.detailTextLabel.highlightedTextColor = color;
}
-(void)setCellModel:(CDProjectCategory *)cellModel
{
    _cellModel = cellModel;
    
    self.textLabel.text = cellModel.categoryName;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@",cellModel.itemCount];
    NSLog(@"itemCount-----%@",cellModel.itemCount);
}


@end
