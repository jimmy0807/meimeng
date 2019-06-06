//
//  PadPaymentDetailViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/11/3.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadPaymentDetailViewController.h"
#import "PadProjectConstant.h"
#import "UIImage+Resizable.h"

@interface PadPaymentDetailViewController ()

@property (nonatomic, strong) NSMutableArray *payments;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, assign) kPadPaymentDetailType type;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UITextField *amountTextField;

@end

@implementation PadPaymentDetailViewController

- (id)initWithPayments:(NSMutableArray *)payments index:(NSInteger)index totalAmount:(CGFloat)totalAmount
{
    self = [super initWithNibName:@"PadPaymentDetailViewController" bundle:nil];
    if (self)
    {
        self.payments = payments;
        self.index = index;
        self.totalAmount = totalAmount;
        self.amount = [[[self.payments objectAtIndex:index] objectForKey:@"amount"] floatValue];
        self.type = kPadPaymentDetailPayment;
    }
    
    return self;
}

- (id)initWithPayments:(NSMutableArray *)payments index:(NSInteger)index operateType:(kPadPaymentDetailType)type
{
    self = [super initWithNibName:@"PadPaymentDetailViewController" bundle:nil];
    if (self)
    {
        self.payments = payments;
        self.index = index;
        self.amount = [[[self.payments objectAtIndex:index] objectForKey:@"amount"] floatValue];
        self.type = type;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    [self initContentScrollView];
    
    UIImage *naviImage = [UIImage imageNamed:@"pad_navi_background"];
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, naviImage.size.height)];
    navi.backgroundColor = [UIColor clearColor];
    navi.image = naviImage;
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    closeButton.backgroundColor = [UIColor clearColor];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_n"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_h"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(didCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:closeButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, 0.0, navi.frame.size.width - kPadNaviHeight - kPadNaviHeight, kPadNaviHeight)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [navi addSubview:self.titleLabel];
    
    [self reloadNaviTitle];
}

- (void)initContentScrollView
{
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, self.view.frame.size.height - kPadNaviHeight - 32.0 - 60.0 - 32.0)];
    self.contentScrollView.backgroundColor = [UIColor clearColor];
    self.contentScrollView.scrollEnabled = YES;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height + 4.0);
    [self.view addSubview:self.contentScrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - kPadInputFieldWidth)/2.0, 60.0, 540.0, 60.0)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [[UIImage imageNamed:@"pad_input_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    imageView.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:imageView];
    if (imageView.frame.origin.y + imageView.frame.size.height + 32.0 > self.contentScrollView.frame.size.height)
    {
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, imageView.frame.origin.y + imageView.frame.size.height + 32.0);
    }
    
    UIImage *confirmImage = [UIImage imageNamed:@"pad_confirm_n"];
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = [UIColor clearColor];
    confirmButton.frame = CGRectMake(imageView.frame.size.width - 12.0 - confirmImage.size.width, (imageView.frame.size.height - confirmImage.size.height)/2.0, 60.0, confirmImage.size.height);
    [confirmButton setBackgroundImage:confirmImage forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:confirmButton];
    
    UILabel *paymodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (imageView.frame.size.height - 24.0)/2.0, (imageView.frame.size.width - confirmButton.frame.size.width - 24.0) - 120.0, 24.0)];
    paymodeLabel.backgroundColor = [UIColor clearColor];
    paymodeLabel.textAlignment = NSTextAlignmentLeft;
    paymodeLabel.font = [UIFont systemFontOfSize:16.0];
    paymodeLabel.textColor = COLOR(48.0, 47.0, 48.0, 1.0);
    [imageView addSubview:paymodeLabel];
    
    self.amountTextField = [[UITextField alloc] initWithFrame:CGRectMake(paymodeLabel.frame.origin.x + paymodeLabel.frame.size.width, (imageView.frame.size.height - 24.0)/2.0, 120.0, 24.0)];
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
    [imageView addSubview:self.amountTextField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Required Methods

- (void)reloadNaviTitle
{
    CGFloat mAmount = 0.0;
    for (NSInteger i = 0; i < self.payments.count; i++)
    {
        if (i != self.index)
        {
            NSDictionary *dict = [self.payments objectAtIndex:i];
            mAmount += [[dict objectForKey:@"amount"] floatValue];
        }
        else
        {
            mAmount += self.amount;
        }
    }
    
    if (self.type == kPadPaymentDetailPayment)
    {
        if (self.totalAmount >= mAmount)
        {
            self.titleLabel.text = [NSString stringWithFormat:LS(@"PadUnPaidMoney"), self.totalAmount - mAmount];
        }
        else
        {
            self.titleLabel.text = [NSString stringWithFormat:LS(@"PadChangeMoney"), mAmount - self.totalAmount];
        }
    }
    else if (self.type == kPadPaymentDetailCreate || self.type == kPadPaymentDetailRecharge)
    {
        self.titleLabel.text = [NSString stringWithFormat:LS(@"PadCardPrePaidAmount"), mAmount];
    }
    else if (self.type == kPadPaymentDetailRecharge)
    {
        if (self.totalAmount == 0.0)
        {
            self.titleLabel.text = [NSString stringWithFormat:LS(@"PadCardPaymentSelectPayMode")];
            if(self.type == kPadPaymentDetailRepayment)
            {
                self.titleLabel.text = [NSString stringWithFormat:LS(@"PadCardRepaymentSelectPayMode")];
            }
        }
        else
        {
            self.titleLabel.text = [NSString stringWithFormat:LS(@"PadCardPrePaidAmount"), self.totalAmount];
        }
    }
    else if (self.type == kPadPaymentDetailRepayment)
    {
        self.titleLabel.text = [NSString stringWithFormat:LS(@"PadCardPreRepaymentAmount"), mAmount];
    }
}

- (void)didCloseButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didConfirmButtonClick:(id)sender
{
    [self.amountTextField resignFirstResponder];
    
    NSMutableDictionary *dict = [self.payments objectAtIndex:self.index];
    CGFloat oldAmount = [[dict objectForKey:@"amount"] floatValue];
    if (self.amount != 0 && self.amount != oldAmount)
    {
        [dict setObject:@(self.amount) forKey:@"amount"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPaymentDetailEditFinish)])
        {
            [self.delegate didPaymentDetailEditFinish];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.text.floatValue == 0.0)
    {
        textField.text = @"";
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
    self.amount = self.amountTextField.text.floatValue;
    self.amountTextField.text = [NSString stringWithFormat:@"%.2f", self.amount];
    [self reloadNaviTitle];
}

@end
