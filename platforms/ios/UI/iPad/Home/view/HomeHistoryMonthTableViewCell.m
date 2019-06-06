//
//  HomeHistoryMonthTableViewCell.m
//  Boss
//
//  Created by jimmy on 15/10/23.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "HomeHistoryMonthTableViewCell.h"

@interface HomeHistoryMonthTableViewCell ()
@property(nonatomic, weak)IBOutlet UILabel* monthLabel;
@property(nonatomic, weak)IBOutlet UILabel* detailLabel;
@property(nonatomic, weak)IBOutlet UILabel* dateLabel;
@property(nonatomic, weak)IBOutlet UIButton* bgButton;
@property(nonatomic, strong)UIView* topleftLineView;
@end

@implementation HomeHistoryMonthTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_N"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateNormal];
    [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_H"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateHighlighted];
    
    self.topleftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 0.5)];
    self.topleftLineView.backgroundColor = COLOR(157, 178, 178, 1);
    [self.contentView addSubview:self.topleftLineView];
}

- (void)setInCome:(CDPosMonthIncome *)inCome
{
    _inCome = inCome;
    self.monthLabel.text = [NSString stringWithFormat:@"%@月",inCome.month];
    self.detailLabel.text = [NSString stringWithFormat:@"营业总额(%@): ¥%.02f",inCome.storeName, [inCome.money floatValue]];
}

- (void)showDate:(NSString*)dateString
{
    self.topleftLineView.hidden = NO;
    self.dateLabel.text = dateString;
}

- (void)hideDate
{
    self.topleftLineView.hidden = YES;
    self.dateLabel.text = @"";
}

- (IBAction)didBgButtonPressed:(id)sender
{
    [self.delegate didHomeHistoryPosTableViewYearCellPresssed:self inCome:self.inCome];
}

@end
