//
//  TextFieldCell.m
//  Boss
//
//  Created by lining on 16/7/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "TextFieldCell.h"

@interface TextFieldCell ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineTailingConstraint;
@end

@implementation TextFieldCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.valueTextFiled.clearsOnBeginEditing = true;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setLineLeadingConstant:(CGFloat)lineLeadingConstant
{
    self.lineTailingConstraint.constant = lineLeadingConstant;
}

- (void)setLineTailingConstant:(CGFloat)lineTailingConstant
{
    self.lineTailingConstraint.constant = lineTailingConstant;
}



@end
