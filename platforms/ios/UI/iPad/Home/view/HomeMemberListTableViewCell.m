//
//  HomeMemberListTableViewCell.m
//  Boss
//
//  Created by jimmy on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "HomeMemberListTableViewCell.h"

@interface HomeMemberListTableViewCell()<UIScrollViewDelegate>
{
    int moveDirection;
    CGFloat lastPosX;
}
@property(nonatomic, weak)IBOutlet UIButton* bgButton;
@property(nonatomic, weak)IBOutlet UILabel* phoneLabel;
@property(nonatomic, weak)IBOutlet UILabel* nameLabel;
@property(nonatomic, weak)IBOutlet UILabel* cardNoLabel;
@property(nonatomic, weak)IBOutlet UILabel* moneyLabel;
@property(nonatomic, weak)IBOutlet UIScrollView* scrollView;
@property(nonatomic, weak)IBOutlet UIButton* chongzhiButton;
@property(nonatomic, weak)IBOutlet UIImageView* avatarMaskView;
@end

@implementation HomeMemberListTableViewCell

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

- (IBAction)didChongzhiButtonPressed:(id)sender
{
    [self.delegate didHomeMemberListTableViewCellChongzhiPresssed:self];
    [self performSelector:@selector(delayToHideDeleteButton) withObject:nil afterDelay:0.2];
}

- (void)delayToHideDeleteButton
{
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.contentView sendSubviewToBack:self.chongzhiButton];
}

- (IBAction)didBgButtonPressed:(id)sender
{
    if ( self.isSelected )
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_current"];
    }
    else
    {
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask"];
    }
    
    [self.delegate didHomeHomeMemberListTableViewCellPresssed:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.contentView sendSubviewToBack:self.chongzhiButton];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ( scrollView.contentOffset.x == 75 )
    {
        [self.contentView bringSubviewToFront:self.chongzhiButton];
    }
    else
    {
        [self.contentView sendSubviewToBack:self.chongzhiButton];
    }
}

- (void)setCard:(CDMemberCard *)card indexPath:(NSIndexPath*)indexPath
{
    _card = card;
    _indexPath = indexPath;
    
    self.nameLabel.text = card.member.memberName;
    self.phoneLabel.text = card.member.mobile;
    
    self.cardNoLabel.text = [NSString stringWithFormat:@"%@ %@",card.cardNo,card.priceList.name];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.02f",[card.amount floatValue]];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.contentView sendSubviewToBack:self.chongzhiButton];
    
    self.scrollView.scrollEnabled = ![card.member.isDefaultCustomer boolValue];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if ( isSelected )
    {
        self.nameLabel.textColor = [UIColor whiteColor];
        self.phoneLabel.textColor = [UIColor whiteColor];
        self.moneyLabel.textColor = [UIColor whiteColor];
        self.cardNoLabel.textColor = [UIColor whiteColor];
        [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_C"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateNormal];
        [self.bgButton setBackgroundImage:nil forState:UIControlStateHighlighted];
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask_current"];
    }
    else
    {
        self.nameLabel.textColor = COLOR(48, 48, 48, 1);
        self.phoneLabel.textColor = COLOR(136, 136, 136, 1);
        self.moneyLabel.textColor = COLOR(173, 173, 173, 1);
        self.cardNoLabel.textColor = COLOR(0, 0, 0, 1);
        [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_N"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateNormal];
        [self.bgButton setBackgroundImage:[[UIImage imageNamed:@"Home_currentPos_cellBg_H"] stretchableImageWithLeftCapWidth:90 topCapHeight:5] forState:UIControlStateHighlighted];
        self.avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask"];
    }
}

@end
