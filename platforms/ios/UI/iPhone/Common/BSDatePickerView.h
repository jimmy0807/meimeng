//
//  BSDatePickerView.h
//  Boss
//
//  Created by lining on 16/5/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSDatePickerView;
@protocol BSDatePickerViewDelegate <NSObject>
@optional
- (void)didDatePicker:(BSDatePickerView *)pickerView dateValueChanged:(NSDate *)date;
- (void)didDatePicker:(BSDatePickerView *)pickerView sureSelectedDate:(NSDate *)date;
- (void)didDatePicker:(BSDatePickerView *)pickerView cancelSelectedDate:(NSDate *)orginDate;
@end

@interface BSDatePickerView : UIView
+ (instancetype)createViewFromNib;
+ (instancetype)createView;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, weak) id<BSDatePickerViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
- (IBAction)bgBtnPressed:(id)sender;
- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)sureBtnPressed:(id)sender;

- (void)show;
- (void)hide;
@end
