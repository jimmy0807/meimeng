//
//  LeftTopCell.m
//  Boss
//
//  Created by lining on 15/10/15.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "POSLeftTopCell.h"

@implementation POSLeftTopCell

+ (instancetype)createCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"POSLeftTopCell" owner:self options:nil] objectAtIndex:0];
}

- (void)setOperate:(CDPosOperate *)operate
{
    _operate = operate;
    self.dateLabel.text = operate.operate_date;
    self.typeLabel.text = operate.type;
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[operate.amount floatValue]];
    self.customerLabel.text = [NSString stringWithFormat:@"客户: %@",operate.member_name];
    self.operatorLabel.text = [NSString stringWithFormat:@"操作人: %@",operate.operate_user_name];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
