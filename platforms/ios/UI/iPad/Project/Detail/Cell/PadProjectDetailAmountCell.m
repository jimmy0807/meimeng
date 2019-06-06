//
//  PadProjectDetailAmountCell.m
//  Boss
//
//  Created by XiaXianBing on 16/1/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadProjectDetailAmountCell.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "PadMaskViewConstant.h"

@implementation PadProjectDetailAmountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat originY = 28.0;
        self.quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewHalfContentWidth, 20.0)];
        self.quantityLabel.backgroundColor = [UIColor clearColor];
        self.quantityLabel.textAlignment = NSTextAlignmentLeft;
        self.quantityLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        self.quantityLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.quantityLabel];
        originY += 20.0 + 12.0;
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewHalfContentWidth, 60.0)];
        background.backgroundColor = [UIColor clearColor];
        background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        background.userInteractionEnabled = YES;
        [self.contentView addSubview:background];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(64.0, 0.0, 1.0, background.frame.size.height)];
        lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
        [background addSubview:lineImageView];
        
        lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(background.frame.size.width - 64.0, 0.0, 1.0, background.frame.size.height)];
        lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
        [background addSubview:lineImageView];
        
        UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        minusButton.backgroundColor = [UIColor clearColor];
        minusButton.frame = CGRectMake(0.0, 0.0, 64.0, background.frame.size.height);
        [minusButton setImage:[UIImage imageNamed:@"pad_minus_button_n"] forState:UIControlStateNormal];
        [minusButton setImage:[UIImage imageNamed:@"pad_minus_button_n"] forState:UIControlStateHighlighted];
        [minusButton addTarget:self action:@selector(didMinusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [background addSubview:minusButton];
        
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        plusButton.backgroundColor = [UIColor clearColor];
        plusButton.frame = CGRectMake(background.frame.size.width - 64.0, 0.0, 64.0, background.frame.size.height);
        [plusButton setImage:[UIImage imageNamed:@"pad_plus_button_n"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageNamed:@"pad_plus_button_n"] forState:UIControlStateHighlighted];
        [plusButton addTarget:self action:@selector(didPlusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [background addSubview:plusButton];
        
        self.quantityTextField = [[UITextField alloc] initWithFrame:CGRectMake(72.0, 0.0, background.frame.size.width - 2 * 72.0, background.frame.size.height)];
        self.quantityTextField.backgroundColor = [UIColor clearColor];
        self.quantityTextField.font = [UIFont systemFontOfSize:16.0];
        self.quantityTextField.textAlignment = NSTextAlignmentCenter;
        self.quantityTextField.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.quantityTextField.enabled = NO;
        [background addSubview:self.quantityTextField];
        
        self.discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskViewWidth - kPadMaskLeftRightMarginWidth - kPadMaskViewHalfContentWidth, originY - 12.0 - 20.0, kPadMaskViewHalfContentWidth, 20.0)];
        self.discountLabel.backgroundColor = [UIColor clearColor];
        self.discountLabel.textAlignment = NSTextAlignmentLeft;
        self.discountLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        self.discountLabel.font = [UIFont systemFontOfSize:16.0];
        //[self.contentView addSubview:self.discountLabel];
        
        background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskViewWidth - kPadMaskLeftRightMarginWidth - kPadMaskViewHalfContentWidth, originY, kPadMaskViewHalfContentWidth, 60.0)];
        background.backgroundColor = [UIColor clearColor];
        background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        background.userInteractionEnabled = YES;
        //[self.contentView addSubview:background];
        
        self.discountTextField = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 0, background.frame.size.width - 2 * 8.0, background.frame.size.height)];
        self.discountTextField.backgroundColor = [UIColor clearColor];
        self.discountTextField.font = [UIFont systemFontOfSize:16.0];
        self.discountTextField.textAlignment = NSTextAlignmentCenter;
        self.discountTextField.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.discountTextField.clearsOnBeginEditing = YES;
        self.discountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        //[background addSubview:self.discountTextField];
    }
    
    return self;
}


- (void)didMinusButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didQuantityMinus)])
    {
        [self.delegate didQuantityMinus];
    }
}

- (void)didPlusButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didQuantityPlus)])
    {
        [self.delegate didQuantityPlus];
    }
}

@end
