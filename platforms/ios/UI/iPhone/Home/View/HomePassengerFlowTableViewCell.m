//
//  HomePassengerFlowTableViewCell.m
//  Boss
//
//  Created by jimmy on 15/7/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "HomePassengerFlowTableViewCell.h"

@interface HomePassengerFlowTableViewCell ()
@property(nonatomic, weak)IBOutlet UILabel* memberTitleLabel;
@property(nonatomic, weak)IBOutlet UILabel* memberDetailLabel;
@property(nonatomic, weak)IBOutlet UILabel* cardNoTitleLabel;
@property(nonatomic, weak)IBOutlet UILabel* cardNoDetailLabel;
@property(nonatomic, weak)IBOutlet UILabel* timeTitleLabel;
@property(nonatomic, weak)IBOutlet UILabel* timeDetailLabel;
@property(nonatomic, weak)IBOutlet UILabel* typeLabel;
@property(nonatomic, weak)IBOutlet UILabel* totalMoneyLabel;
@property(nonatomic, weak)IBOutlet UILabel* operaterUserLabel;
@property(nonatomic, weak)IBOutlet UILabel* danjuLabel;
@property(nonatomic, weak)IBOutlet UILabel* storeLabel;
@property(nonatomic, weak)IBOutlet UIImageView* lineImageView;
@property(nonatomic, weak)IBOutlet UIButton* arrowButton;
@property(nonatomic, weak)IBOutlet UIView* detailView;
@end

@implementation HomePassengerFlowTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setItemInfo:(CDPassengerFlow*)item
{
    NSString * type = [NSString stringWithFormat:@"home_%@",item.type];
    self.typeLabel.text = [NSString stringWithFormat:@"类       型:  %@",LS(type)];
    self.danjuLabel.text = [NSString stringWithFormat:@"单       据:  %@",item.name];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date = [dateFormat dateFromString:item.create_date];
    dateFormat.dateFormat = @"HH:mm";
    NSString* time = [dateFormat stringFromDate:date];
    self.timeTitleLabel.text = [NSString stringWithFormat:@"(%@)",time];
    dateFormat.dateFormat = @"MM-dd HH:mm";
    time = [dateFormat stringFromDate:date];
    self.timeDetailLabel.text = [NSString stringWithFormat:@"操作时间:  %@",time];
    
    self.memberTitleLabel.text = item.memberName;
    self.memberDetailLabel.text = [NSString stringWithFormat:@"会       员:  %@",item.memberName];
    
    self.cardNoTitleLabel.text = item.cardNo;
    self.cardNoDetailLabel.text = [NSString stringWithFormat:@"会员卡号:  %@",item.cardNo];
    
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"总       额:  %@",item.totalAmount];
    self.operaterUserLabel.text = [NSString stringWithFormat:@"操  作  人:  %@",item.operateUser];
    self.storeLabel.text = [NSString stringWithFormat:@"消费门店:  %@",item.shopName];
}

-(IBAction)didExpandButtonPressed:(UIButton*)sender
{
    [self.delegate didExpandPressedAtIndex:self.indexPath isExpand:!_isExpand];
}

- (void)didCellPressed
{
    [self didExpandButtonPressed:nil];
}

- (void)setIsExpand:(BOOL)isExpand
{
    _isExpand = isExpand;
    self.detailView.hidden = !isExpand;
    [self.arrowButton setBackgroundImage:(isExpand?[UIImage imageNamed:@"Home_arrow_up"]:[UIImage imageNamed:@"Home_arrow_down"]) forState:UIControlStateNormal];
}

@end
