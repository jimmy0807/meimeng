//
//  HomeCurrentPosTableViewCell.m
//  Boss
//
//  Created by jimmy on 15/10/15.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "HomeReserveTableViewCell.h"

@interface HomeReserveTableViewCell()<UIScrollViewDelegate>
{
    int moveDirection;
    CGFloat lastPosX;
}
@property(nonatomic, weak)IBOutlet UIButton* bgButton;
@property(nonatomic, weak)IBOutlet UILabel* nameLabel;
@property(nonatomic, weak)IBOutlet UILabel* timeLabel;
@property(nonatomic, weak)IBOutlet UIImageView* timeIcon;
@property(nonatomic, weak)IBOutlet UILabel* moneyLabel;
@property(nonatomic, weak)IBOutlet UIScrollView* scrollView;
@property(nonatomic, weak)IBOutlet UIButton* deleteButton;
@property(nonatomic, weak)IBOutlet UIButton* modifyButton;
@property(nonatomic, weak)IBOutlet UIImageView* currentSelectImageView;
@property(nonatomic, weak)IBOutlet UIImageView* avatarMaskView;
@property(nonatomic, weak)IBOutlet UILabel* disableReasonLabel;
@end

@implementation HomeReserveTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_N"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateNormal];
    [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_H"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateHighlighted];

    [self.bgButton addTarget:self action:@selector(didHighlightState:) forControlEvents:UIControlEventTouchDown];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width + 147, self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
}

- (void)didHighlightState:(id)sender
{
    if ( self.isSelected )
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_current"];
    }
    else
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_H"];
    }
}

- (IBAction)didBgButtonTouchUpOutSide:(id)sender
{
    if ( self.isSelected )
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_current"];
    }
    else
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask"];
    }
}

- (IBAction)didDeleteButtonPressed:(id)sender
{
    [self.delegate didHomeReserveTableViewCellDeleteButtonPresssed:self];
    [self performSelector:@selector(delayToHideDeleteButton) withObject:nil afterDelay:0.2];
}

- (IBAction)didModifyButtonPressed:(id)sender
{
    [self.delegate didHomeReserveTableViewCellModifyButtonPresssed:self];
    [self performSelector:@selector(delayToHideDeleteButton) withObject:nil afterDelay:0.2];
}

- (void)delayToHideDeleteButton
{
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.contentView sendSubviewToBack:self.deleteButton];
    [self.contentView sendSubviewToBack:self.modifyButton];
}

- (IBAction)didBgButtonPressed:(id)sender
{
    if ( _book.director_employee_id && ![_book.is_consult_finished boolValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"现在还不能开单哦~该顾客正在咨询中" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ( self.isSelected )
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_current"];
    }
    else
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask"];
    }
    
    [self.delegate didHomeReserveTableViewCellPresssed:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.contentView sendSubviewToBack:self.deleteButton];
    [self.contentView sendSubviewToBack:self.modifyButton];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ( scrollView.contentOffset.x >= 75 )
    {
        [self.contentView bringSubviewToFront:self.deleteButton];
        if ( scrollView.contentOffset.x >= 147 )
        {
            [self.contentView bringSubviewToFront:self.modifyButton];
        }
    }
    else
    {
        [self.contentView sendSubviewToBack:self.deleteButton];
        [self.contentView sendSubviewToBack:self.modifyButton];
    }
}

- (void)setBook:(CDBook*)book indexPath:(NSIndexPath*)indexPath
{
    _book = book;
    _indexPath = indexPath;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    self.nameLabel.text = book.booker_name;
    if ( book.technician_name.length > 0 )
    {
        self.moneyLabel.text = [NSString stringWithFormat:@"%@",book.technician_name];
    }
    else
    {
        self.moneyLabel.text = @"";
    }
        
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date = [dateFormat dateFromString:book.start_date];
    
    NSString* now = [dateFormat stringFromDate:[NSDate date]];
    
    dateFormat.dateFormat = @"HH:mm";
    if ( [self.book.state isEqualToString:@"done"] )
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%@ (%@)",[dateFormat stringFromDate:date],@"已消费"];
    }
    else if ( [self.book.isUsed boolValue] )
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%@ (%@)",[dateFormat stringFromDate:date],@"已开单"];
    }
    else if ( [self.book.start_date compare:now] == NSOrderedAscending )
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%@ (%@)",[dateFormat stringFromDate:date],@"已逾时"];
    }
    else
    {
        self.timeLabel.text = [dateFormat stringFromDate:date];
    }
    if ( self.book.director_employee_id && ![self.book.is_consult_finished boolValue])
    {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(self.bgButton.frame.size.width - 61, 0, 60, 10)];
        bgView.backgroundColor = COLOR(180, 213, 218, 1);
        [self.bgButton addSubview:bgView];
        UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(self.bgButton.frame.size.width - 51, 0, 50, 22)];
        bgView2.backgroundColor = COLOR(180, 213, 218, 1);
        [self.bgButton addSubview:bgView2];
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bgButton.frame.size.width - 61, 0, 60, 22)];
        statusLabel.text = @"咨询中";
        statusLabel.font = [UIFont systemFontOfSize:13];
        statusLabel.textColor = [UIColor whiteColor];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.backgroundColor = COLOR(180, 213, 218, 1);
        statusLabel.layer.cornerRadius = 4;
        statusLabel.layer.masksToBounds = YES;
        [self.bgButton addSubview:statusLabel];
    }
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.contentView sendSubviewToBack:self.deleteButton];
    [self.contentView sendSubviewToBack:self.modifyButton];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if ( isSelected )
    {
        self.nameLabel.textColor = [UIColor whiteColor];
        self.numberLabel.textColor = [UIColor whiteColor];
        self.moneyLabel.textColor = [UIColor whiteColor];
        self.timeLabel.textColor = [UIColor whiteColor];
        [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_C"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateNormal];
        [self.bgButton setBackgroundImage:nil forState:UIControlStateHighlighted];
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_current"];
        self.timeIcon.image = [UIImage imageNamed:@"pad_time_current_icon"];
    }
    else
    {
        self.nameLabel.textColor = COLOR(92, 92, 92, 1);
        self.numberLabel.textColor = COLOR(39, 39, 39, 1);
        self.moneyLabel.textColor = COLOR(92, 92, 92, 1);
        self.timeLabel.textColor = COLOR(92, 92, 92, 1);
        
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask"];
        self.timeIcon.image = [UIImage imageNamed:@"pad_time_icon"];
#if 0  
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString* now = [dateFormat stringFromDate:[NSDate date]];

        if ( [self.book.state isEqualToString:@"approved"] && [self.book.start_date compare:now] != NSOrderedAscending && ![self.book.isUsed boolValue] )
        {
            [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_N"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateNormal];
            [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_H"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateHighlighted];
        }
        else
        {
            [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_H"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateNormal];
            [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_H"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateHighlighted];
            self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_H"];
        }
#else
        [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_N"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateNormal];
        [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_H"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateHighlighted];
#endif
    }
}

@end
