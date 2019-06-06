//
//  PadProjectDetailCashDiscountCell.m
//  meim
//
//  Created by 波恩公司 on 2017/11/8.
//

#import "PadProjectDetailCashDiscountCell.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "PadMaskViewConstant.h"

@interface PadProjectDetailCashDiscountCell ()
@end

@implementation PadProjectDetailCashDiscountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userInteractionEnabled = YES;
        CGFloat originY = 28.0;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.titleLabel];
        
        self.discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskViewWidth - 200 - kPadMaskLeftRightMarginWidth, originY, 200, 20)];
        self.discountLabel.backgroundColor = [UIColor clearColor];
        self.discountLabel.textAlignment = NSTextAlignmentRight;
        self.discountLabel.font = [UIFont systemFontOfSize:14.0];
        self.discountLabel.textColor = COLOR(237.0, 70.0, 70.0, 1.0);
        [self.contentView addSubview:self.discountLabel];
        originY += 20.0 + 12.0;
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
        background.backgroundColor = [UIColor whiteColor];
        background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        background.userInteractionEnabled = YES;
        [self.contentView addSubview:background];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, kPadMaskViewHalfContentWidth + 120.0 - 8.0, background.frame.size.height)];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
        self.detailLabel.font = [UIFont systemFontOfSize:16.0];
        self.detailLabel.textColor = COLOR(153.0, 153.0, 153.0, 1.0);
        [background addSubview:self.detailLabel];
        
        self.discountTextField = [[UITextField alloc] initWithFrame:CGRectMake(background.frame.size.width - 20.0 - kPadMaskViewHalfContentWidth + 120.0, 0.0, kPadMaskViewHalfContentWidth - 120.0, background.frame.size.height)];
        self.discountTextField.backgroundColor = [UIColor clearColor];
        self.discountTextField.font = [UIFont systemFontOfSize:16.0];
        self.discountTextField.textAlignment = NSTextAlignmentRight;
        self.discountTextField.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.discountTextField.clearsOnBeginEditing = YES;
        self.discountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [self.discountTextField addTarget:self action:@selector(refreshDiscountLabel) forControlEvents:UIControlEventEditingDidEnd];
        
        self.symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 12.0, self.discountTextField.frame.size.height - 2.0)];
        self.symbolLabel.backgroundColor = [UIColor clearColor];
        self.symbolLabel.textAlignment = NSTextAlignmentLeft;
        self.symbolLabel.font = [UIFont systemFontOfSize:16.0];
        self.symbolLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.symbolLabel.text = LS(@"PadMoneySymbol");
        self.discountTextField.leftView = self.symbolLabel;
        self.discountTextField.leftViewMode = UITextFieldViewModeAlways;
        [background addSubview:self.discountTextField];
        originY += 60.0 + 28.0;
        
        self.chooseButton = [[UIButton alloc] initWithFrame:background.frame];
        [self.chooseButton setTitle:@"请选择" forState:UIControlStateNormal];
        [self.chooseButton setTitleColor:COLOR(48.0, 48.0, 48.0, 1.0) forState:UIControlStateNormal];
        [self.chooseButton addTarget:self action:@selector(chooseCashDiscount) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.chooseButton];
        
        if (self.isChosen)
        {
            self.chooseButton.hidden = YES;
            self.discountTextField.hidden = NO;
            self.detailLabel.hidden = NO;
        }
        else
        {
            self.chooseButton.hidden = NO;
            self.discountTextField.hidden = YES;
            self.detailLabel.hidden = YES;
        }
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 0.5)];
        lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
        //[self.contentView addSubview:lineImageView];
    }
    
    return self;
}

- (void)reloadView
{
    if (self.isChosen)
    {
        [self refreshDiscountLabel];
        self.chooseButton.hidden = YES;
        self.discountTextField.hidden = NO;
        self.detailLabel.hidden = NO;
    }
    else
    {
        self.chooseButton.hidden = NO;
        self.discountTextField.hidden = YES;
        self.detailLabel.hidden = YES;
    }
}

- (void)refreshDiscountLabel
{
    if ([self.discountTextField.text isEqualToString:@""] || self.discountTextField.text.floatValue == 0 || self.maxDiscountPoint == 0)
    {
        self.discountLabel.text = @"";
        self.discountTextField.text = @"0";
    }
    else
    {
        if(self.discountTextField.text.floatValue > self.maxDiscountPoint)
        {
            self.discountLabel.text = [NSString stringWithFormat:@"抵%@%.2f",LS(@"PadMoneySymbol"),self.maxDiscountPoint];
            self.discountTextField.text = [NSString stringWithFormat:@"%.2f",self.maxDiscountPoint];
        }
        else
        {
            self.discountLabel.text = [NSString stringWithFormat:@"抵%@%.2f",LS(@"PadMoneySymbol"),self.discountTextField.text.floatValue];
        }
    }
}

- (void)chooseCashDiscount
{
    if (self.shouldShowMember)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showMemberSelect" object:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"请在会员中心页面选择现金抵用券"
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end


