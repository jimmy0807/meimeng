//
//  PadProjectDetailItemCell.m
//  Boss
//
//  Created by XiaXianBing on 16/1/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadProjectDetailItemCell.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "PadMaskViewConstant.h"

@implementation PadProjectDetailItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat originY = 28.0;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.titleLabel];
        originY += 20.0 + 12.0;
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
        background.backgroundColor = [UIColor clearColor];
        background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        background.userInteractionEnabled = YES;
        [self.contentView addSubview:background];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, kPadMaskViewHalfContentWidth + 120.0 - 8.0, background.frame.size.height)];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
        self.detailLabel.font = [UIFont systemFontOfSize:16.0];
        self.detailLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [background addSubview:self.detailLabel];
        
        self.priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(background.frame.size.width - 20.0 - kPadMaskViewHalfContentWidth + 120.0, 0.0, kPadMaskViewHalfContentWidth - 120.0, background.frame.size.height)];
        self.priceTextField.backgroundColor = [UIColor clearColor];
        self.priceTextField.font = [UIFont systemFontOfSize:16.0];
        self.priceTextField.textAlignment = NSTextAlignmentRight;
        self.priceTextField.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.priceTextField.clearsOnBeginEditing = YES;
        self.priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
        
        UILabel *symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 12.0, self.priceTextField.frame.size.height - 2.0)];
        symbolLabel.backgroundColor = [UIColor clearColor];
        symbolLabel.textAlignment = NSTextAlignmentLeft;
        symbolLabel.font = [UIFont systemFontOfSize:16.0];
        symbolLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        symbolLabel.text = LS(@"PadMoneySymbol");
        self.priceTextField.leftView = symbolLabel;
        self.priceTextField.leftViewMode = UITextFieldViewModeAlways;
        [background addSubview:self.priceTextField];
        originY += 60.0 + 28.0;
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 0.5)];
        lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
        [self.contentView addSubview:lineImageView];
    }
    
    return self;
}

@end
