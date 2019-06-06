//
//  HomeTodayIncomeDetailTableViewCell.m
//  Boss
//
//  Created by jimmy on 15/7/22.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "HomeTodayIncomeDetailTableViewCell.h"

@interface HomeTodayIncomeDetailTableViewCell ()
@property(nonatomic, weak)IBOutlet UILabel* danjuLabel;
@property(nonatomic, weak)IBOutlet UILabel* typeTitleLabel;
@property(nonatomic, weak)IBOutlet UILabel* typeDetailLabel;
@property(nonatomic, weak)IBOutlet UILabel* timeTitleLabel;
@property(nonatomic, weak)IBOutlet UILabel* timeDetailLabel;
@property(nonatomic, weak)IBOutlet UILabel* totalMoneyTitleLabel;
@property(nonatomic, weak)IBOutlet UILabel* totalMoneyDetailLabel;
@property(nonatomic, weak)IBOutlet UILabel* memberLabel;
@property(nonatomic, weak)IBOutlet UILabel* chuzhibiandongLabel;
@property(nonatomic, weak)IBOutlet UILabel* productConsumeLabel;
@property(nonatomic, weak)IBOutlet UILabel* chanpinxiaoshouLabel;
@property(nonatomic, weak)IBOutlet UILabel* operaterUserLabel;
@property(nonatomic, weak)IBOutlet UILabel* storeLabel;
@property(nonatomic, weak)IBOutlet UIImageView* lineImageView;
@property(nonatomic, weak)IBOutlet UIButton* arrowButton;
@property(nonatomic, weak)IBOutlet UIView* detailView;
@end

@implementation HomeTodayIncomeDetailTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setItemInfo:(CDTodayIncomeItem*)item
{
    NSString * type = [NSString stringWithFormat:@"home_%@",item.type];
    self.typeTitleLabel.text = LS(type);
    self.typeDetailLabel.text = [NSString stringWithFormat:@"类       型:  %@",LS(type)];
    self.danjuLabel.text = item.name;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date = [dateFormat dateFromString:item.create_date];
    dateFormat.dateFormat = @"HH:mm";
    NSString* time = [dateFormat stringFromDate:date];
    self.timeTitleLabel.text = [NSString stringWithFormat:@"(%@)",time];
    dateFormat.dateFormat = @"MM-dd HH:mm";
    time = [dateFormat stringFromDate:date];
    self.timeDetailLabel.text = [NSString stringWithFormat:@"操作时间:  %@",time];
    
    self.totalMoneyTitleLabel.text = item.totalAmount;
    self.totalMoneyDetailLabel.text = [NSString stringWithFormat:@"总       额:  %@",item.totalAmount];
    
    self.memberLabel.text = [NSString stringWithFormat:@"会       员:  %@",item.memberName];
    self.chuzhibiandongLabel.text = [NSString stringWithFormat:@"储值变动:  %@",item.now_card_amount];
    self.productConsumeLabel.text = [NSString stringWithFormat:@"项目消耗:  %@",item.product_conusme_amount];
    self.chanpinxiaoshouLabel.text = [NSString stringWithFormat:@"产品销售:  %@",item.product_buy_amount];
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
