//
//  DatePickerView.m
//  Boss
//
//  Created by lining on 15/7/14.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView ()
@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, strong) UIView *pickerView;
@property(nonatomic, strong) UIButton *hideBtn;
@property(nonatomic, assign) id<DatePickerViewDelegate>delegate;
@end


@implementation DatePickerView

- (id)initWithFrame:(CGRect)frame dateString:(NSString *)dateString delegate:(id<DatePickerViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.delegate = delegate;
        
        self.autoresizingMask = 0xff;
        
        self.hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.hideBtn.frame = self.bounds;
        [self.hideBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.hideBtn];
        
        self.pickerView = [[UIView alloc] init];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.autoresizingMask = 0xff;
        self.datePicker = [[UIDatePicker alloc] init];
        
        self.datePicker.datePickerMode = UIDatePickerModeDate;

        if (dateString.length > 0 && ![dateString isEqualToString:@"0"]) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormat dateFromString:dateString];
            self.datePicker.date = date;
        }
        else
        {
            self.datePicker.date = [NSDate date];
        }
        
        [self.pickerView addSubview:self.datePicker];
        
        CGRect frame = self.datePicker.frame;
        frame.size.width = self.frame.size.width;
        self.datePicker.frame = frame;
        
        frame.origin.y = self.frame.size.height;
        
        
        self.pickerView.frame = frame;
        
        
        [self addSubview:self.pickerView];
        
        [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.hidden = true;

    }
    return self;
}


- (void)setIsHaveHideBtn:(BOOL)isHaveHideBtn
{
    _isHaveHideBtn = isHaveHideBtn;
    
    self.hideBtn.hidden = !isHaveHideBtn;
}

- (void)show
{
    if (self.hidden) {
        self.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.pickerView.frame;
            frame.origin.y = self.frame.size.height - frame.size.height;
            self.pickerView.frame = frame;
        } completion:nil];
    }
}


- (void)hide
{
    if (!self.hidden) {
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.pickerView.frame;
            frame.origin.y = self.frame.size.height;
            self.pickerView.frame = frame;
        } completion:^(BOOL finished) {
            self.hidden = YES;
            [self datePickerValueChanged:self.datePicker];
        }];
    }
}

#pragma mark - datePickerValueChangerd
-(void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    NSLog(@"dateChanged");
    NSDate *date = datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    if ([self.delegate respondsToSelector:@selector(didChangeValueForKey:)]) {
        [self.delegate didValueChanged:dateString];
    }
    
}

@end
