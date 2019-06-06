//
//  OperateInfoCell.m
//  Boss
//
//  Created by lining on 16/8/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateInfoCell.h"

@implementation PosOperateInfoCell

+ (instancetype)createCell
{
    return [self loadFromNib];
}

- (void)setOperate:(CDPosOperate *)operate
{
    _operate = operate;
    self.typeLabel.text = operate.type;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",operate.amount.floatValue];
    self.nameLabel.text = operate.name;
    self.memberLabel.text = operate.member_name;
    self.operatorLabel.text = operate.operate_user_name;
    if ([operate.type isEqualToString:@"消费"]) {
        self.assignTag.hidden = true;
    }
    else
    {
        if (operate.commission_ids.length > 0 || operate.commissions.count > 0) {
            self.assignTag.hidden = true;
        }
        else
        {
            self.assignTag.hidden = false;
        }
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
