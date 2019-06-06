//
//  BSDatePickerView.m
//  Boss
//
//  Created by lining on 16/5/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSDatePickerView.h"

@interface BSDatePickerView ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pickerViewBottomConstraint;
@property (strong, nonatomic) NSDate *orignDate;
@property (assign, nonatomic) BOOL isFromNib;
@end

@implementation BSDatePickerView

+ (instancetype)createViewFromNib
{
    BSDatePickerView *pickerView = [self loadFromNib];
    pickerView.isFromNib = true;
    pickerView.date = [NSDate date];
    pickerView.backgroundColor = COLOR(0, 0, 0, 0.4);
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    pickerView.alpha = 0.0;
    return pickerView;
}

+ (instancetype)createView
{
    BSDatePickerView *pickerView = [[BSDatePickerView alloc] init];
    pickerView.backgroundColor = COLOR(0, 0, 0, 0.4);
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    pickerView.alpha = 0.0;
    return pickerView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.date = [NSDate date];
        [self initSubView];
    }
    return self;
}

- (void) initSubView
{
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgBtn addTarget:self action:@selector(bgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    self.pickerView = [[UIView alloc] init];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        
    }];
    
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = COLOR(235, 235, 235, 1);
    [self.pickerView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.equalTo(@44);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitleColor:COLOR(0, 122, 255, 1) forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.equalTo(@60);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(72, 72, 72, 1);
    titleLabel.text = @"选择日期";
    titleLabel.font = [UIFont systemFontOfSize:16];
    [topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.centerOffset(CGPointZero);
    }];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn setTitleColor:COLOR(0, 122, 255, 1) forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.trailing.offset(0);
        make.width.equalTo(@60);
    }];
    
    
    self.datePicker = [[UIDatePicker alloc] init];
    [self.datePicker addTarget:self action:@selector(pickerViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.date = self.date;
    [self.pickerView addSubview:self.datePicker];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.bottom.offset(0);
    }];
    
    
}

- (void)setDate:(NSDate *)date
{
    if (date == nil) {
        return;
    }
    _date = date;
    self.orignDate = date;
    self.datePicker.date = date;
}

#pragma mark - show & hide
- (void)show
{
    self.hidden = false;
    if (self.isFromNib) {
        self.pickerViewBottomConstraint.constant = 0;
    }
    else
    {
        [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.leading.offset(0);
            make.trailing.offset(0);
        }];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        self.alpha = 1;
    }];
    
}

- (void)hide
{
    if (self.isFromNib) {
        self.pickerViewBottomConstraint.constant = -260;
    }
    else
    {
        [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(0);
            make.leading.offset(0);
            make.trailing.offset(0);
        }];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
//        self.hidden = true;
    }];
}

#pragma mark - action
- (IBAction)bgBtnPressed:(id)sender {
    [self hide];
}

- (IBAction)cancelBtnPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didDatePicker:cancelSelectedDate:)]) {
        [self.delegate didDatePicker:self cancelSelectedDate:self.orignDate];
    }
    
    self.date = _orignDate;
    [self hide];
    
}

- (IBAction)sureBtnPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didDatePicker:sureSelectedDate:)]) {
        [self.delegate didDatePicker:self sureSelectedDate:self.date];
    }
    self.date = _date;
    [self hide];
}

- (IBAction)pickerViewValueChanged:(UIDatePicker *)sender {
//    [self hide];
    _date = sender.date;
    if ([self.delegate respondsToSelector:@selector(didDatePicker:dateValueChanged:)]) {
        [self.delegate didDatePicker:self dateValueChanged:self.date];
    }
}

@end
