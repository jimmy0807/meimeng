//
//  HomeHistoryPosTableViewCell.m
//  Boss
//
//  Created by jimmy on 15/10/20.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "HomeHistoryPosTableViewCell.h"

@interface HomeHistoryPosTableViewCell ()
@property(nonatomic, weak)IBOutlet UIButton* bgButton;
@property(nonatomic, weak)IBOutlet UILabel* operateTypeLabel;
@property(nonatomic, weak)IBOutlet UILabel* operateUserLabel;
@property(nonatomic, weak)IBOutlet UILabel* timeLabel;
@property(nonatomic, weak)IBOutlet UILabel* moneyLabel;
@property(nonatomic, weak)IBOutlet UIImageView* yejiImageView;
@property(nonatomic, weak)IBOutlet UILabel* yejiLabel;
@property(nonatomic, strong)UIView* topleftLineView;
@property(nonatomic, weak)IBOutlet UILabel* dateLabel;
@property(nonatomic, weak)IBOutlet UIImageView* tagImageView;
@end

@implementation HomeHistoryPosTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_historyPos_cellBg_N"] stretchableImageWithLeftCapWidth:270 topCapHeight:5] forState:UIControlStateNormal];
    [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_historyPos_cellBg_H"] stretchableImageWithLeftCapWidth:270 topCapHeight:5] forState:UIControlStateHighlighted];
    
    self.topleftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 0.5)];
    self.topleftLineView.backgroundColor = COLOR(157, 178, 178, 1);
    [self.contentView addSubview:self.topleftLineView];
    
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        self.yejiLabel.hidden = YES;
    }
}

- (void)setOperate:(CDPosOperate *)operate
{
    _operate = operate;
    
    self.operateTypeLabel.text = [NSString stringWithFormat:@"%@ - %@",operate.name,operate.type];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.02f",[operate.amount doubleValue]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date = [dateFormat dateFromString:operate.operate_date];
    dateFormat.dateFormat = @"HH:mm";
    self.timeLabel.text = [dateFormat stringFromDate:date];
    
    self.operateUserLabel.text = operate.member_name;
    
    if ( operate.commission_ids.length > 0 )
    {
        self.yejiImageView.hidden = YES;
        self.yejiLabel.hidden = YES;
    }
    else
    {
        self.yejiImageView.hidden = NO;
        self.yejiLabel.hidden = NO;
    }
    
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        self.yejiImageView.hidden = YES;
    }
    
    if ( [self.operate.state isEqualToString:@"cancel"] )
    {
        self.tagImageView.hidden = NO;
    }
    else
    {
        self.tagImageView.hidden = YES;
    }
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
    [self.delegate didHomeHistoryPosTableViewCellPresssed:self];
}

@end
