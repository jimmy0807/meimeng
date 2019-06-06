//
//  GiveProjectCountEditView.m
//  Boss
//
//  Created by lining on 16/9/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GiveProjectCountEditView.h"

@interface GiveProjectCountEditView ()
@property (assign, nonatomic) NSInteger minCount;
@property (assign, nonatomic) NSInteger maxCount;
@property (assign, nonatomic) NSInteger count;
@end

@implementation GiveProjectCountEditView

+ (instancetype)createViewAddInSuperView:(UIView *)view
{
    GiveProjectCountEditView *editView = [self loadFromNib];
    [view addSubview:editView];
    [editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    [editView initView];
    return editView;
}

- (void)initView
{
    self.alpha = 0.0;
    self.bgBtn.alpha = 0.0;
    [self removeConstraint:self.bottomConstraint];
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
    }];
}

- (void)setCouponProject:(CouponProject *)couponProject
{
    _couponProject = couponProject;
    self.nameLabel.text = couponProject.item.itemName;
    self.priceLabel.text = [NSString stringWithFormat:@"数量(单价:¥%.2f)",couponProject.item.totalPrice.floatValue];
    self.countLabel.text = [NSString stringWithFormat:@"%d",couponProject.count];
    self.maxCount = INTMAX_MAX;
    self.minCount = 1;
    self.count = couponProject.count;
    
    
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
    
    CGFloat money = self.couponProject.item.totalPrice.floatValue * count;
    
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",money];
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
    
    [self hide];
    
}

- (IBAction)reduceBtnPressed:(id)sender {
    self.count --;
}

- (IBAction)addBtnPressed:(id)sender {
    self.count ++;
}

- (IBAction)cancelBtnPressed:(id)sender {
    [self hide];
    
}

- (IBAction)deleteBtnPressed:(id)sender {
   
    [self hide];
    if ([self.delegate respondsToSelector:@selector(didDeleteBtnPressed)]) {
        [self.delegate didDeleteBtnPressed];
    }
}

- (IBAction)sureBtnPressed:(id)sender {
    [self hide];
    
    self.couponProject.count = self.count;
    if ([self.delegate respondsToSelector:@selector(didFinishChanged)]) {
        [self.delegate didFinishChanged];
    }
}

@end
