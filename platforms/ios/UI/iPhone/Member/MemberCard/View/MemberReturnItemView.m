//
//  MemberReturnItemView.m
//  Boss
//
//  Created by lining on 16/6/16.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberReturnItemView.h"

@interface MemberReturnItemView ()<UITextFieldDelegate>
@property (assign, nonatomic) NSInteger maxCount;
@property (assign, nonatomic) NSInteger minCount;
@property (assign, nonatomic) NSInteger count;
@end

@implementation MemberReturnItemView


+ (instancetype)createViewAddInSuperView:(UIView *)view
{
    MemberReturnItemView *itemView = [self loadFromNib];
    
    [view addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    [itemView initView];
    return itemView;
}

- (void)initView
{
    self.alpha = 0.0;
    self.bgBtn.alpha = 0.0;
    [self removeConstraint:self.bottomConstraint];
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
    }];
    self.moneyTextField.delegate = self;
    self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)setReturnItem:(BSReturnItem *)returnItem
{
    _returnItem = returnItem;
    self.nameLabel.text = returnItem.cardProject.projectName;
    
    self.moneyTextField.text = [NSString stringWithFormat:@"%.2f",returnItem.returnAmount];
    self.priceLabel.text = [NSString stringWithFormat:@"单价:￥%.2f",self.returnItem.cardProject.projectPriceUnit.doubleValue];

    self.minCount = 0;
    self.maxCount = returnItem.cardProject.remainQty.integerValue;
    
    self.count = returnItem.returnCount;
}

- (void)setMaxCount:(NSInteger)maxCount
{
    _maxCount = maxCount;
    self.maxCountLabel.text = [NSString stringWithFormat:@"您最多可退数量为%d个",maxCount];
}

- (void)setCount:(NSInteger)count
{
    _count = count;
    
    if (count <= self.minCount) {
        self.reduceBtn.enabled = false;
        _count = self.minCount;
    }
    else
    {
        self.reduceBtn.enabled = true;
    }
    
    if (count >= self.maxCount) {
        self.addBtn.enabled = false;
        count = self.maxCount;
    }
    else
    {
        self.addBtn.enabled = true;
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%d",count];
    
    CGFloat money = self.returnItem.cardProject.projectPriceUnit.doubleValue * count;
    
    self.moneyTextField.text = [NSString stringWithFormat:@"%.2f",money];
}

#pragma mark - show & hide
- (void)show
{
    self.alpha = 1;
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        [self layoutIfNeeded];
        self.bgBtn.alpha = 0.6;
    }];
}

- (void)hide
{
    [[UIApplication sharedApplication].keyWindow endEditing:true];
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        self.bgBtn.alpha = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.alpha = 0.0;
    }];
}

#pragma mark - action
- (IBAction)bgBtnPressed:(id)sender {
    if ([self.moneyTextField isFirstResponder]) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        return;
    }
    [self hide];
    if ([self.delegate respondsToSelector:@selector(didFinishChanged)]) {
        [self.delegate didFinishChanged];
    }
}

- (IBAction)reduceBtnPressed:(id)sender {
    self.count --;
}

- (IBAction)addBtnPressed:(id)sender {
    self.count ++;
}

- (IBAction)cancelBtnPressed:(id)sender {
    [self hide];
    if ([self.delegate respondsToSelector:@selector(didFinishChanged)]) {
        [self.delegate didFinishChanged];
    }
}

- (IBAction)deleteBtnPressed:(id)sender {
    self.returnItem.returnCount = 0;
    self.returnItem.returnAmount = 0.0;
    [self hide];
    if ([self.delegate respondsToSelector:@selector(didFinishChanged)]) {
        [self.delegate didFinishChanged];
    }
}

- (IBAction)sureBtnPressed:(id)sender {
    [self hide];
    
    self.returnItem.returnCount = self.count;
    self.returnItem.returnAmount = self.moneyTextField.text.floatValue;
    if ([self.delegate respondsToSelector:@selector(didFinishChanged)]) {
        [self.delegate didFinishChanged];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
}

@end
