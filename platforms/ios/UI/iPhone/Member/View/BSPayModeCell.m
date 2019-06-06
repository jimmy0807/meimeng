//
//  BSPayModeCell.m
//  Boss
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSPayModeCell.h"

@interface BSPayModeCell()<UITextFieldDelegate>

@end
@implementation BSPayModeCell

-(void)setMemberPay:(MemberPay *)memberPay
{
    _memberPay = memberPay;
    self.titleLabel.text = memberPay.payName;
    self.contentField.placeholder = @"";
    self.contentField.enabled = YES;
    self.contentField.delegate = self;
    self.contentField.placeholder = [NSString stringWithFormat:@"%@",memberPay.payMoney==nil?@(0):memberPay.payMoney];
    self.contentField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( string.length == 0 )
    {
        if ( textField.text.length > 0 )
        {
            self.memberPay.payMoney = [textField.text substringToIndex:textField.text.length - 1];
        }
        else
        {
            self.memberPay.payMoney = @"0";
        }
    }
    else
    {
        self.memberPay.payMoney = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    
    [self setMemberPay:self.memberPay];
    if( [self.delegate respondsToSelector:@selector(cellDidEdit:)] )
    {
        [self.delegate cellDidEdit:self];
    }
    
    textField.placeholder = textField.text;
    
    return TRUE;
}

@end
