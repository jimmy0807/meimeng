//
//  PadPayModeCell.m
//  Boss
//
//  Created by XiaXianBing on 15/10/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadPayModeCell.h"
#import "UIImage+Resizable.h"

#define kPadPayModeCellLeftMargin       88.0

@interface PadPayModeCell ()
{
    BOOL isAnimation;
}

@property (nonatomic, assign) CGFloat tempAmount;

@end

@implementation PadPayModeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.detailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadPayModeCellLeftMargin, 0.0, kPadPayModeCellWidth - 2 * kPadPayModeCellLeftMargin, kPadPayModeCellHeight - 32.0)];
        self.detailImageView.backgroundColor = [UIColor clearColor];
        self.detailImageView.image = [[UIImage imageNamed:@"pad_payment_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        self.detailImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.detailImageView];
        
        UIImage *deleteImage = [UIImage imageNamed:@"pad_delete_n"];
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.backgroundColor = [UIColor clearColor];
        deleteButton.frame = CGRectMake(0.0, 0.0, deleteImage.size.width + 2 * 16.0, self.detailImageView.frame.size.height);
        [deleteButton setImage:deleteImage forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"pad_delete_h"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(didDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.detailImageView addSubview:deleteButton];
        
        UIImage *confirmImage = [UIImage imageNamed:@"pad_confirm_n"];
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.backgroundColor = [UIColor clearColor];
        confirmButton.frame = CGRectMake(self.detailImageView.frame.size.width - 12.0 - confirmImage.size.width, (self.detailImageView.frame.size.height - confirmImage.size.height)/2.0, 60.0, confirmImage.size.height);
        [confirmButton setBackgroundImage:confirmImage forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.detailImageView addSubview:confirmButton];
        
        self.paymodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(deleteButton.frame.size.width, 0.0, (self.detailImageView.frame.size.width - deleteButton.frame.size.width - confirmButton.frame.size.width - 24.0) - 120.0, self.detailImageView.frame.size.height)];
        self.paymodeLabel.backgroundColor = [UIColor clearColor];
        self.paymodeLabel.textAlignment = NSTextAlignmentLeft;
        self.paymodeLabel.font = [UIFont systemFontOfSize:16.0];
        self.paymodeLabel.textColor = COLOR(48.0, 47.0, 48.0, 1.0);
        self.paymodeLabel.numberOfLines = 2;
        [self.detailImageView addSubview:self.paymodeLabel];
        
        self.amountTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.paymodeLabel.frame.origin.x + self.paymodeLabel.frame.size.width, (self.detailImageView.frame.size.height - 24.0)/2.0, 120.0, 24.0)];
        self.amountTextField.backgroundColor = [UIColor clearColor];
        self.amountTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.amountTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.amountTextField.textAlignment = NSTextAlignmentRight;
        self.amountTextField.font = [UIFont systemFontOfSize:16.0];
        self.amountTextField.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.amountTextField.placeholder = @"¥ 0.00";
        self.amountTextField.returnKeyType = UIReturnKeyDone;
        self.amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        self.amountTextField.delegate = self;
        [self.detailImageView addSubview:self.amountTextField];
        
        self.contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.contentButton.backgroundColor = [UIColor clearColor];
        self.contentButton.frame = CGRectMake(kPadPayModeCellLeftMargin, 0.0, kPadPayModeCellWidth - 2 * kPadPayModeCellLeftMargin, kPadPayModeCellHeight - 32.0);
        [self.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_payment_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateNormal];
        [self.contentButton setBackgroundImage:[[UIImage imageNamed:@"pad_payment_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateHighlighted];
        self.contentButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentButton setTitleColor:COLOR(48.0, 48.0, 48.0, 1.0) forState:UIControlStateNormal];
        [self.contentButton addTarget:self action:@selector(didContentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.contentButton.alpha = 1.0;
        [self.contentView addSubview:self.contentButton];
    }
    
    return self;
}

- (void)showInputViews
{
    if (isAnimation)
    {
        return;
    }
    
    isAnimation = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadPaymodeCellContentClick:)])
    {
        [self.delegate didPadPaymodeCellContentClick:self];
    }
    [UIView animateWithDuration:0.12 animations:^{
        self.contentButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        isAnimation = NO;
    }];
}

- (void)hideInputViews
{
    if (isAnimation)
    {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadPaymodeCellCancelButtonClick:)])
    {
        [self.delegate didPadPaymodeCellCancelButtonClick:self];
    }
    
    isAnimation = YES;
    [UIView animateWithDuration:0.12 animations:^{
        self.contentButton.alpha = 1.0;
        self.amountTextField.text = @"";
        [self.amountTextField resignFirstResponder];
    } completion:^(BOOL finished) {
        isAnimation = NO;
    }];
}

- (void)didContentButtonClick:(id)sender
{
    [self showInputViews];
}

- (void)didDeleteButtonClick:(id)sender
{
    [self hideInputViews];
}

- (void)didConfirmButtonClick:(id)sender
{
    [UIView animateWithDuration:0.32 animations:^{
        [self.amountTextField resignFirstResponder];
    } completion:^(BOOL finished) {
        BOOL shouldHide = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadPayModeCellConfirm:)])
        {
            shouldHide = [self.delegate didPadPayModeCellConfirm:self];
        }
        
        if (shouldHide)
        {
            [self hideInputViews];
        }
    }];
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAmountTextFieldBeginEditing:)])
    {
        [self.delegate didAmountTextFieldBeginEditing:self];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location == 0 && ![string isEqualToString:@""])
    {
        textField.text = [NSString stringWithFormat:@"¥ %@", string];
        return NO;
    }
    else if (range.location == 2 && [string isEqualToString:@""])
    {
        textField.text = @"";
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.amountTextField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAmountTextFieldEndEditing:)])
    {
        [self.delegate didAmountTextFieldEndEditing:self];
    }
}

@end
