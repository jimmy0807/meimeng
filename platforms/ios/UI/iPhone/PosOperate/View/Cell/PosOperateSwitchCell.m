//
//  PosOperateSwitchCell.m
//  Boss
//
//  Created by lining on 16/9/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateSwitchCell.h"

@interface PosOperateSwitchCell ()

@end

@implementation PosOperateSwitchCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(didSwitchValueChanged:)]) {
        [self.delegate didSwitchValueChanged:sender.isOn];
    }
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
