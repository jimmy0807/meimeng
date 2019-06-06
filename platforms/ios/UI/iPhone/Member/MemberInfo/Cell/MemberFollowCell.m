//
//  MemberFollowCell.m
//  Boss
//
//  Created by lining on 16/5/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFollowCell.h"

@implementation MemberFollowCell

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

    // Configure the view for the selected state
}

- (void)setFollow:(CDMemberFollow *)follow
{
    _follow = follow;
    self.nameLabel.text = follow.member_name;
    self.moenyLabel.text = [NSString stringWithFormat:@"￥%.2f",[follow.cource_amount floatValue]];
    self.countLabel.text = [NSString stringWithFormat:@"共到店%@次,最后到店日:%@号",follow.last_month_come_count,follow.last_month_come_day];
    self.dateLabel.text = [NSString stringWithFormat:@"截止时间:%@",follow.follow_date];
    
    self.monthLabel.text = [NSString stringWithFormat:@"  %@月",follow.month];
}


@end
