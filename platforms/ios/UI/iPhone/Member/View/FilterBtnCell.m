//
//  FilterBtnCell.m
//  Boss
//
//  Created by lining on 16/5/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FilterBtnCell.h"

@implementation FilterBtnCell

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

    // Configure the view for the selected state
}

- (IBAction)cancelBtnPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didCancelBtnPressed:)]) {
        [self.delegate didCancelBtnPressed:sender];
    }
}

- (IBAction)sureBtnPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSureBtnPressed:)]) {
        [self.delegate didSureBtnPressed:sender];
    }
}

@end
