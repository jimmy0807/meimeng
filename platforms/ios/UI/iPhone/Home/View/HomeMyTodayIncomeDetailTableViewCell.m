//
//  HomeMyTodayIncomeDetailTableViewCell.m
//  Boss
//
//  Created by jimmy on 15/7/28.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "HomeMyTodayIncomeDetailTableViewCell.h"

@interface HomeMyTodayIncomeDetailTableViewCell ()
@property(nonatomic, weak)IBOutlet UILabel* typeTitleLabel;
@property(nonatomic, weak)IBOutlet UILabel* timeTitleLabel;
@property(nonatomic, weak)IBOutlet UILabel* danjuTitleLabel;
@property(nonatomic, weak)IBOutlet UILabel* totalMoneyTitleLabel;
@property(nonatomic, weak)IBOutlet UILabel* tiChengfanganLabel;
@property(nonatomic, weak)IBOutlet UILabel* yejiLabel;
@property(nonatomic, weak)IBOutlet UILabel* yejidianLabel;
@property(nonatomic, weak)IBOutlet UILabel* totalMoneyDetailLabel;
@property(nonatomic, weak)IBOutlet UILabel* tichengMoneyLabel;
@property(nonatomic, weak)IBOutlet UILabel* shoudongMoneyLabel;
@property(nonatomic, weak)IBOutlet UILabel* projectItemLabel;
@property(nonatomic, weak)IBOutlet UILabel* storeLabel;
@property(nonatomic, weak)IBOutlet UIImageView* lineImageView;
@property(nonatomic, weak)IBOutlet UIButton* arrowButton;
@property(nonatomic, weak)IBOutlet UIView* detailView;
@end

@implementation HomeMyTodayIncomeDetailTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setItemInfo:(CDMyTodayInComeItem*)item
{
    self.typeTitleLabel.text = item.type;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date = [dateFormat dateFromString:item.create_date];
    dateFormat.dateFormat = @"HH:mm";
    NSString* time = [dateFormat stringFromDate:date];
    self.timeTitleLabel.text = [NSString stringWithFormat:@"(%@)",time];
    
    self.danjuTitleLabel.text = [NSString stringWithFormat:@"%@",item.name];
    
    self.totalMoneyTitleLabel.text = item.totalMoney;
    self.totalMoneyDetailLabel.text = [NSString stringWithFormat:@"总       额:  %@",item.totalMoney];
    self.tiChengfanganLabel.text = [NSString stringWithFormat:@"提成方案:  %@",item.tichengfangan];
    
    self.yejiLabel.text = [NSString stringWithFormat:@"业       绩:  %@",item.yejiMoney];
    self.yejidianLabel.text = [NSString stringWithFormat:@"业  绩  点:  %@",item.yejidian];
    
    self.tichengMoneyLabel.text = [NSString stringWithFormat:@"提成金额:  %@",item.tichengMoney];
    self.shoudongMoneyLabel.text = [NSString stringWithFormat:@"手动金额:  %@",item.shoudongMoney];
    self.projectItemLabel.text = [NSString stringWithFormat:@"产       品:  %@",item.shoudongMoney];
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
