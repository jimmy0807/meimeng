//
//  OperateMonthCell.m
//  Boss
//
//  Created by lining on 16/8/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateMonthCell.h"

@implementation PosOperateMonthCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)setIncome:(CDPosMonthIncome *)income
{
    _income = income;
    self.monthLabel.text = [NSString stringWithFormat:@"%d月",income.month.integerValue];
    self.shopLabel.text = [NSString stringWithFormat:@"营业总额(%@)",income.storeName];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",income.money.floatValue];
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
