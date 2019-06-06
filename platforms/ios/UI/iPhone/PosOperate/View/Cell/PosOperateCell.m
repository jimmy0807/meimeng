//
//  OperateCell.m
//  Boss
//
//  Created by lining on 16/8/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateCell.h"
#import "NSDate+Formatter.h"

@implementation PosOperateCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)setOperate:(CDPosOperate *)operate
{
    _operate = operate;
    self.titleLabel.text = [NSString stringWithFormat:@"%@-%@",operate.name,operate.type];
    self.memberNameLabel.text = [NSString stringWithFormat:@"会员：%@",operate.member_name];
    self.dateLabel.text = [NSString stringWithFormat:@"时间：%@",[[NSDate dateFromString:operate.operate_date] dateStringWithFormatter:@"HH:mm"]];
    
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.02f",[operate.amount floatValue]];
    if (operate.commission_ids.length > 0 || operate.commissions.count > 0 ) {
        self.notAssignTag.hidden = true;
    }
    else
    {
        self.notAssignTag.hidden = false;
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
