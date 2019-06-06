//
//  PadCardOperateView.m
//  Boss
//
//  Created by XiaXianBing on 15/11/11.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadCardOperateView.h"
#import "PersonalProfile.h"
#import "PadProjectConstant.h"

@interface PadCardOperateView ()

@end

@implementation PadCardOperateView

- (id)init
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(IC_SCREEN_WIDTH - kPadCardOperateButtonWidth, 0.0, kPadCardOperateButtonWidth, IC_SCREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.contentSize = CGSizeMake(kPadCardOperateButtonWidth, kPadCardOperateButtonHeight * kPadMemberCardOperateCashier);
        [self addSubview:scrollView];
        
        for (int i = kPadMemberCardOperateCreate; i < kPadMemberCardOperateCashier; i++)
        {
            UIButton *operateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            operateButton.backgroundColor = [UIColor clearColor];
            operateButton.frame = CGRectMake(0.0, i * kPadCardOperateButtonHeight, kPadCardOperateButtonWidth, kPadCardOperateButtonHeight);
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_card_operate_%d", i]];
            [operateButton setBackgroundImage:image forState:UIControlStateNormal];
            [operateButton setBackgroundImage:image forState:UIControlStateHighlighted];
            [operateButton addTarget:self action:@selector(didOperateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            operateButton.tag = 1000 + i;
            [scrollView addSubview:operateButton];
        }
    }
    
    return self;
}


#pragma mark -
#pragma mark Required Methods

- (void)setMemberCard:(CDMemberCard *)memberCard
{
    if (memberCard.cardID.integerValue != _memberCard.cardID.integerValue || ![memberCard.cardNumber isEqualToString:_memberCard.cardNumber])
    {
        _memberCard = memberCard;
    }
    
    [self refreshOperateButton];
}

- (void)refreshOperateButton
{
    for (int i = kPadMemberCardOperateRecharge; i < kPadMemberCardOperateCashier; i++)
    {
        UIButton *button = (UIButton *)[self viewWithTag:1000 + i];
        UIImage *image = nil;
        if (self.memberCard)
        {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_card_operate_%d", i]];
            if (self.memberCard.state.integerValue == kPadMemberCardStateActive )
            {
                PersonalProfile *profile = [PersonalProfile currentProfile];
                if (i == kPadMemberCardOperateExchange && !profile.isAllowItem)
                {
                    image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_card_operate_invalid_%d", i]];
                }
                else if (i == kPadMemberCardOperateRepayment && (!profile.isAllowArrears || self.memberCard.arrearsAmount.floatValue + self.memberCard.courseArrearsAmount.floatValue <= 0))
                {
                    image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_card_operate_invalid_%d", i]];
                }
                else if (self.memberCard.amount.floatValue <= 0 && i == kPadMemberCardOperateRefund)
                {
                    image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_card_operate_%d", i]];
                }
            }
            else
            {
                image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_card_operate_invalid_%d", i]];
                if ( ( self.memberCard.state.integerValue == kPadMemberCardStateLost || self.memberCard.state.integerValue == kPadMemberCardStateDraft ) && i == kPadMemberCardOperateActive)
                {
                    image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_card_operate_%d", i]];
                }
            }
        }
        else
        {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_card_operate_invalid_%d", i]];
        }
        
        if ( [[PersonalProfile currentProfile].posID integerValue] == 0 )
        //if ( [PersonalProfile currentProfile].roleOption !=  4 )
        {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_card_operate_invalid_%d", i]];
        }
        
        if ([self.memberCard.is_share boolValue]) {
            if (i > 2) {
                image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_card_operate_invalid_%d", i]];
            }
        }
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    
    if ( [[PersonalProfile currentProfile].posID integerValue] == 0 )
    //if ( [PersonalProfile currentProfile].roleOption !=  4 )
    {
        UIButton *button = (UIButton *)[self viewWithTag:1000];
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_card_operate_invalid_%d", 0]];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
    }
}

- (void)didOperateButtonClick:(id)sender
{
    if ( [[PersonalProfile currentProfile].posID integerValue] == 0 )
    //if ( [PersonalProfile currentProfile].roleOption !=  4 )
    {
        return;
    }
    
    UIButton *operateButton = (id)sender;
    if (operateButton.tag - 1000 == kPadMemberCardOperateCreate)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didMemberCardOperateWithType:)])
        {
            [self.delegate didMemberCardOperateWithType:operateButton.tag - 1000];
        }
        
        return;
    }
    if ([self.memberCard.is_share boolValue]) {
        if (operateButton.tag - 1000 > 2) {
            return;
        }
    }
    if ([self.memberCard.member.isDefaultCustomer boolValue])
    {
        return;
    }
    
    if (self.memberCard)
    {
        if (self.memberCard.state.integerValue == kPadMemberCardStateActive )
        {
            PersonalProfile *profile = [PersonalProfile currentProfile];
            if (operateButton.tag - 1000 == kPadMemberCardOperateExchange && !profile.isAllowItem)
            {
                return;
            }
            else if (operateButton.tag - 1000 == kPadMemberCardOperateRepayment && (!profile.isAllowArrears || self.memberCard.arrearsAmount.floatValue + self.memberCard.courseArrearsAmount.floatValue <= 0))
            {
                return;
            }
            else if (self.memberCard.amount.floatValue <= 0 && operateButton.tag - 1000 == kPadMemberCardOperateRefund)
            {
                //return;
            }
            else if (operateButton.tag - 1000 == kPadMemberCardOperateRedeem && self.memberCard.points.integerValue == 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:LS(@"PadMemberCardPointsIsNuLL")
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
        }
        else
        {
            if (!(self.memberCard.state.integerValue == kPadMemberCardStateLost && operateButton.tag - 1000 == kPadMemberCardOperateActive))
            {
                return;
            }
        }
    }
    else
    {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didMemberCardOperateWithType:)])
    {
        [self.delegate didMemberCardOperateWithType:operateButton.tag - 1000];
    }
}

@end
