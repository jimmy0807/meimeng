//
//  PadTableSeatCell.m
//  Boss
//
//  Created by XiaXianBing on 16-2-25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadTableSeatCell.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"

@implementation PadTableSeatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat originY = 28.0;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, originY, kPadTableSeatCellWidth - 2 * 20.0, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.titleLabel];
        originY += 20.0 + 12.0;
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, originY, kPadTableSeatCellWidth - 2 * 20.0, 60.0)];
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
        
        self.numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(72.0, 0.0, background.frame.size.width - 2 * 72.0, background.frame.size.height)];
        self.numberTextField.backgroundColor = [UIColor clearColor];
        self.numberTextField.delegate = self;
        self.numberTextField.font = [UIFont systemFontOfSize:16.0];
        self.numberTextField.textAlignment = NSTextAlignmentCenter;
        self.numberTextField.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [background addSubview:self.numberTextField];
    }
    
    return self;
}


- (void)didMinusButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTableSeatsMinus)])
    {
        [self.delegate didTableSeatsMinus];
    }
}

- (void)didPlusButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTableSeatsPlus)])
    {
        [self.delegate didTableSeatsPlus];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( textField.text.length > 0 )
    {
        [self.delegate didTableSeatsCountChanged:[textField.text integerValue]];
    }
}

@end
