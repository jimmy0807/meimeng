//
//  HomeCurrentPosTableViewCell.m
//  Boss
//
//  Created by jimmy on 15/10/15.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "HomeCurrentPosTableViewCell.h"

@interface HomeCurrentPosTableViewCell()<UIScrollViewDelegate>
{
    int moveDirection;
    CGFloat lastPosX;
}
@property(nonatomic, weak)IBOutlet UIButton* bgButton;
@property(nonatomic, weak)IBOutlet UILabel* nameLabel;
@property(nonatomic, weak)IBOutlet UILabel* handNameLabel;
@property(nonatomic, weak)IBOutlet UILabel* handNoLabel;
@property(nonatomic, weak)IBOutlet UILabel* timeLabel;
@property(nonatomic, weak)IBOutlet UIImageView* timeIcon;
@property(nonatomic, weak)IBOutlet UILabel* moneyLabel;
@property(nonatomic, weak)IBOutlet UIScrollView* scrollView;
@property(nonatomic, weak)IBOutlet UIButton* deleteButton;
@property(nonatomic, weak)IBOutlet UIImageView* currentSelectImageView;
@property(nonatomic, weak)IBOutlet UIImageView* avatarMaskView;
@end

@implementation HomeCurrentPosTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_N"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateNormal];
    [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_H"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateHighlighted];
    [self.bgButton addTarget:self action:@selector(didHighlightState:) forControlEvents:UIControlEventTouchDown];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width + 75, self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
}

- (void)didHighlightState:(id)sender
{
    if ( self.isCurrentPos )
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_current"];
    }
    else
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_H"];
    }
}

- (IBAction)didDeleteButtonPressed:(id)sender
{
    [self.delegate didHomeCurrentPosTableViewCellDeleteButtonPresssed:self];
    [self performSelector:@selector(delayToHideDeleteButton) withObject:nil afterDelay:0.2];
}

- (void)delayToHideDeleteButton
{
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.contentView sendSubviewToBack:self.deleteButton];
}

- (IBAction)didBgButtonTouchUpOutSide:(id)sender
{
    if ( self.isCurrentPos )
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_current"];
    }
    else
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask"];
    }
}

- (IBAction)didBgButtonPressed:(id)sender
{
    if ( self.isCurrentPos )
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_current"];
    }
    else
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask"];
    }
    
    [self.delegate didHomeCurrentPosTableViewCellPresssed:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.contentView sendSubviewToBack:self.deleteButton];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ( scrollView.contentOffset.x == 75 )
    {
        [self.contentView bringSubviewToFront:self.deleteButton];
    }
    else
    {
        [self.contentView sendSubviewToBack:self.deleteButton];
    }
}

- (void)setPosOperate:(CDPosOperate*)posOperate indexPath:(NSIndexPath*)indexPath
{
    _posOperate = posOperate;
    self.numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    
    if ( [posOperate.handno integerValue] > 0 )
    {
        self.nameLabel.text = @"";
        self.handNameLabel.text = posOperate.member.memberName;
        self.handNoLabel.text = posOperate.handno;
    }
    else
    {
        self.nameLabel.text = posOperate.member.memberName;
        self.handNameLabel.text = @"";
        self.handNoLabel.text = @"";
    }
    
    
    if ( [posOperate.member.isDefaultCustomer boolValue] )
    {
        if ( posOperate.book.booker_name.length > 0 )
        {
            if ( [posOperate.handno integerValue] > 0 )
            {
                self.handNameLabel.text = [NSString stringWithFormat:LS(@"PadBookedCustomer"), posOperate.book.booker_name];
            }
            else
            {
                self.nameLabel.text = [NSString stringWithFormat:LS(@"PadBookedCustomer"), posOperate.book.booker_name];
            }
        }
    }
    
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.02f",[posOperate.amount doubleValue]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date = [dateFormat dateFromString:posOperate.operate_date];
    dateFormat.dateFormat = @"HH:mm";
    self.timeLabel.text = [dateFormat stringFromDate:date];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.contentView sendSubviewToBack:self.deleteButton];
}

- (void)setIsCurrentPos:(BOOL)isCurrentPos
{
    _isCurrentPos = isCurrentPos;
    
    if ( isCurrentPos )
    {
        self.numberLabel.textColor = [UIColor whiteColor];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.handNameLabel.textColor = [UIColor whiteColor];
        self.handNoLabel.textColor = [UIColor whiteColor];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.moneyLabel.textColor = [UIColor whiteColor];
        [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_C"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateNormal];
        [self.bgButton setBackgroundImage:nil forState:UIControlStateHighlighted];
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_current"];
        self.timeIcon.image = [UIImage imageNamed:@"pad_time_current_icon"];
        
        self.currentPosLabel.hidden = YES;
        
//        CGRect frame = self.scrollView.frame;
//        frame.origin.y = 23;
//        self.scrollView.frame = frame;
//        
//        frame = self.deleteButton.frame;
//        frame.origin.y = self.scrollView.frame.origin.y;
//        self.deleteButton.frame = frame;
    }
    else
    {
        self.numberLabel.textColor = COLOR(39, 39, 39, 1);
        self.nameLabel.textColor = COLOR(39, 39, 39, 1);
        self.handNameLabel.textColor = COLOR(39, 39, 39, 1);
        self.handNoLabel.textColor = COLOR(39, 39, 39, 1);
        self.timeLabel.textColor = COLOR(73, 73, 73, 1);
        self.moneyLabel.textColor = COLOR(67, 199, 199, 1);
        [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_N"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateNormal];
        [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_H"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateHighlighted];
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask"];
        self.timeIcon.image = [UIImage imageNamed:@"pad_time_icon"];
        
        self.currentPosLabel.hidden = YES;
        
//        CGRect frame = self.scrollView.frame;
//        frame.origin.y = 0;
//        self.scrollView.frame = frame;
//        
//        frame = self.deleteButton.frame;
//        frame.origin.y = 0;
//        self.deleteButton.frame = frame;
    }
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    if ( moveDirection > 0 )
//    {
//        *targetContentOffset = CGPointMake(0, (*targetContentOffset).y);
//    }
//    else
//    {
//        *targetContentOffset = CGPointMake(75, (*targetContentOffset).y);
//    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSInteger offsetX = scrollView.contentOffset.x;
//    
//    if ( scrollView.contentOffset.x > lastPosX )
//    {
//        moveDirection = -1;
//    }
//    else
//    {
//        moveDirection = 1;
//    }
//    
//    lastPosX = offsetX;
//}

@end
