//
//  MemberPayAlertFieldView.m
//  Boss
//
//  Created by lining on 16/6/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberPayAlertFieldView.h"

#define kFloat  0.001

@interface MemberPayAlertFieldView ()
{
    BOOL isCancel;
}
@property (nonatomic, assign) CGFloat currentPayMoney;

@end

@implementation MemberPayAlertFieldView

+ (instancetype)createViewWithPayMode:(CDPOSPayMode *)payMode money:(CGFloat)money delegate:(id<MemberPayAlertFieldViewDelegate>)delegate
{
    MemberPayAlertFieldView *payAlertView = [self loadFromNib];
    payAlertView.payMode = payMode;
    payAlertView.payMoney = money;
    payAlertView.changeBtn.hidden = true;
   
    payAlertView.delegate = delegate;
    
    return payAlertView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 50 - 44;
    self.moneyTextFiled.delegate = self;
}


- (void)setPayMode:(CDPOSPayMode *)payMode
{
    _payMode = payMode;
    if (payMode == nil) {
        self.titleLabel.text = @"欠款支付";
        return;
    }
    if (payMode.mode.integerValue == kPadPayModeTypeCard) {
        self.titleLabel.text = @"会员卡支付";
    }
    else if (payMode.mode.integerValue == kPadPayModeTypeCash) {
        self.titleLabel.text = @"现金支付";
    }
    else if (payMode.mode.integerValue == kPadPayModeTypeBankCard) {
        self.titleLabel.text = @"银行卡支付";
    }
    else if (payMode.mode.integerValue == kPadPayModeTypeWeChat)
    {
        self.titleLabel.text = @"微信支付";
    }
    else if (payMode.mode.integerValue == kPadPayModeTypeAlipay) {
        self.titleLabel.text = @"支付宝支付";
    }
    else if (payMode.mode.integerValue == kPadPayModeTypeCoupon)
    {
        self.titleLabel.text = @"微卡优惠券支付";
    }
    else if (payMode.mode.integerValue == kPadPayModeTypeWeiXinCoupon)
    {
        self.titleLabel.text = @"微信优惠券支付";
    }
    else if (payMode.mode.integerValue == kPadPayModeTypeOtherCoupon) {
        self.titleLabel.text = @"第三方卡券支付";
    }
    else if (payMode.mode.integerValue == kPadPayModeTypePoint) {
        self.titleLabel.text = @"积分支付";
    }
    else if (payMode.mode.integerValue == kPadPayModeTypeArrears) {
        self.titleLabel.text = @"欠款支付";
    }
}

- (void)setPayMoney:(CGFloat)payMoney
{
    _payMoney = payMoney;
    if (payMoney - kFloat < 0) {
        self.moneyTextFiled.text = @"";
    }
    else
    {
       self.moneyTextFiled.text = [NSString stringWithFormat:@"%.2f",payMoney];
    }
    
}

- (void)setCard:(CDMemberCard *)card
{
    _card = card;
    self.changeBtn.hidden = false;
}

- (void)show
{
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view
{
    self.alpha = 0.0;
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self.moneyTextFiled becomeFirstResponder];
    }];
}

- (void)hide
{
    [self.moneyTextFiled resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - button action
- (IBAction)cancelBtnPressed:(id)sender {
    isCancel = true;
    [self hide];
}

- (IBAction)sureBtnPressed:(id)sender {
    isCancel = false;
    [self hide];
    
}

- (IBAction)bgBtnPressed:(id)sender {
//    [self hide];
}

- (IBAction)changeBtnPressed:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    if ([self.delegate respondsToSelector:@selector(didChangeBtnPressedWithPayMode:)]) {
        [self.delegate didChangeBtnPressedWithPayMode:self.payMode];
    }
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self hide];
    self.payMoney = [textField.text floatValue];
    textField.text = [NSString stringWithFormat:@"%.2f",self.payMoney];
    if (self.payMoney - kFloat < 0) {
        isCancel = false;
        return;
    }
    if (!isCancel) {
        if ([self.delegate respondsToSelector:@selector(didSureBtnPressedWithPayMode:money:)]) {
            [self.delegate didSureBtnPressedWithPayMode:self.payMode money:self.payMoney];
        }
        isCancel = false;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

@end
