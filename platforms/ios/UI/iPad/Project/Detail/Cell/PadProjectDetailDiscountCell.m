//
//  PadProjectDetailDiscountCell.m
//  meim
//
//  Created by 波恩公司 on 2017/11/8.
//

#import "PadProjectDetailDiscountCell.h"
#import "UIImage+Resizable.h"
#import "PadProjectConstant.h"
#import "PadMaskViewConstant.h"

@implementation PadProjectDetailDiscountCell

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
        
        self.discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskViewWidth - 200 - kPadMaskLeftRightMarginWidth, originY, 200, 20)];
        self.discountLabel.backgroundColor = [UIColor clearColor];
        self.discountLabel.textAlignment = NSTextAlignmentRight;
        self.discountLabel.font = [UIFont systemFontOfSize:14.0];
        self.discountLabel.textColor = COLOR(237.0, 70.0, 70.0, 1.0);
        [self.contentView addSubview:self.discountLabel];
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
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 0.5)];
        lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
        //[self.contentView addSubview:lineImageView];
    }
    
    return self;
}

- (void)reloadView
{
    [self refreshDiscountLabel];
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
//            self.discountLabel.text = [NSString stringWithFormat:@"抵%@%.2f",LS(@"PadMoneySymbol"),self.maxDiscountPoint*self.pointsChangeMoney];
//            self.discountTextField.text = [NSString stringWithFormat:@"%d",self.maxDiscountPoint];
        }
        else
        {
            NSLog(@"%@", self.discountTextField.text);
            NSLog(@"%fX%f=%f", self.discountTextField.text.floatValue, self.pointsChangeMoney,self.discountTextField.text.floatValue*self.pointsChangeMoney);
            self.discountLabel.text = [NSString stringWithFormat:@"抵%@%.2f",LS(@"PadMoneySymbol"),self.discountTextField.text.floatValue*self.pointsChangeMoney];
        }
    }
}

@end

