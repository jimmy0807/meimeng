//
//  PadTextInputViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/10/27.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadTextInputViewController.h"
#import "PadProjectConstant.h"
#import "UIImage+Resizable.h"

@interface PadTextInputViewController ()


@property (nonatomic, assign) kPadTextInputType inputType;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation PadTextInputViewController

- (id)initWithType:(kPadTextInputType)inputType
{
    self = [super initWithNibName:@"PadTextInputViewController" bundle:nil];
    if (self)
    {
        self.inputType = inputType;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
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
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(96.0, 0.0, self.view.frame.size.width - 2 * 96.0, kPadNaviHeight)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [navi addSubview:self.titleLabel];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = [UIColor clearColor];
    self.confirmButton.frame = CGRectMake(self.view.frame.size.width - 90.0, 0.0, 90.0, kPadNaviHeight);
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    [self.confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.enabled = NO;
    [navi addSubview:self.confirmButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - kPadInputFieldWidth)/2.0, kPadNaviHeight + 120.0, 540.0, 60.0)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [[UIImage imageNamed:@"pad_input_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, imageView.frame.size.width - 2 * 12.0, imageView.frame.size.height)];
    self.inputField.backgroundColor = [UIColor clearColor];
    self.inputField.font = [UIFont systemFontOfSize:16.0];
    self.inputField.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.inputField.textAlignment = NSTextAlignmentCenter;
    self.inputField.delegate = self;
    self.inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.inputField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [imageView addSubview:self.inputField];
    
    [self reloadViewWithType:self.inputType];
    
    [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.2];
}

- (void)showKeyboard
{
    [self.inputField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)reloadViewWithType:(kPadTextInputType)type
{
    self.inputType = type;
    if (type == kPadTextInputHandNum)
    {
        self.titleLabel.text = LS(@"PadAddHandGrade");
        self.inputField.placeholder = LS(@"PadPleaseScanOrInputHandNum");
    }
    else if (type == kPadTextInputCouponNum)
    {
        self.titleLabel.text = LS(@"PadSelectGiftCardVouchers");
        self.inputField.placeholder = LS(@"PadPleaseScanOrInputCouponNum");
    }
    else if (type == kPadTextInputRestaurant || type == kPadTextInputBookedRestaurant )
    {
        self.inputField.keyboardType = UIKeyboardTypeNumberPad;
        self.titleLabel.text = LS(@"请输入顾客人数");
        self.inputField.placeholder = @"人数";
    }
}

- (void)didCloseButtonClick:(id)sender
{
    [self.inputField resignFirstResponder];
    [self.maskView hidden];
}

- (void)didConfirmButtonClick:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.inputField resignFirstResponder];
    } completion:^(BOOL finished) {
        if ( self.memberCard || self.couponCard )
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didTextInputFinishedWithType:inputText:memberCard:)])
            {
                [self.delegate didTextInputFinishedWithType:self.inputType inputText:self.inputField.text memberCard:self.memberCard couponCard:self.couponCard];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didTextInputFinishedWithType:inputText:)])
            {
                [self.delegate didTextInputFinishedWithType:self.inputType inputText:self.inputField.text];
            }
        }
        
        [self.maskView hidden];
    }];
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length - range.length + string.length == 0)
    {
        self.confirmButton.enabled = NO;
    }
    else
    {
        self.confirmButton.enabled = YES;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
        self.confirmButton.enabled = NO;
    }
    else
    {
        self.confirmButton.enabled = YES;
    }
}

@end
