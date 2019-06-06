//
//  PayModeCell.m
//  Boss
//
//  Created by lining on 16/6/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PayModeCell.h"

@implementation PayModeCell

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

- (void)setPayMode:(CDPOSPayMode *)payMode
{
    _payMode = payMode;
    [self.payBtn setTitle:payMode.payName forState:UIControlStateNormal];
}

- (IBAction)payBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didPayModeBtnPressed:)]) {
        [self.delegate didPayModeBtnPressed:self.payMode];
    }
}



@end
