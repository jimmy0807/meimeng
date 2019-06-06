//
//  PadDatePickerView.m
//  meim
//
//  Created by jimmy on 2017/5/10.
//
//

#import "PadDatePickerView.h"

@interface PadDatePickerView ()
@property(nonatomic, strong)UIDatePicker* pickerView;
@property(nonatomic, strong)UIView* backgroundView;
@end

@implementation PadDatePickerView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 1024, 768)];
    
    if ( self )
    {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        [btn addTarget:self action:@selector(didBlankButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 468, 1024, 300)];
        self.backgroundView.backgroundColor = COLOR(239, 242, 242, 1);
        [self addSubview:self.backgroundView];
        
        self.pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(212, 0, 600, 300)];
        [self.backgroundView addSubview:self.pickerView];
    }
    
    return self;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    _datePickerMode = datePickerMode;
    self.pickerView.datePickerMode = self.datePickerMode;
}

- (void)show
{
    __block CGRect frame = self.backgroundView.frame;
    frame.origin.y = 768;
    self.backgroundView.frame = frame;
    [UIView animateWithDuration:0.3 animations:^{
        frame.origin.y = 468;
        self.backgroundView.frame = frame;
    }];
}

- (void)didBlankButtonPressed:(id)sender
{
    self.selectFinished(self.pickerView.date);
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.backgroundView.frame;
        frame.origin.y = 768;
        self.backgroundView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setDate:(NSDate *)date
{
    self.pickerView.date = date;
}

@end
