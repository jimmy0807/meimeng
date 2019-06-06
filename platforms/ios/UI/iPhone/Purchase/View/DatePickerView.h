//
//  DatePickerView.h
//  Boss
//
//  Created by lining on 15/7/14.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate <NSObject>

@optional
- (void)didValueChanged:(NSString *)dateString;
@end

@interface DatePickerView : UIView
@property(nonatomic) BOOL isHaveHideBtn;
- (id)initWithFrame:(CGRect)frame dateString:(NSString *)dateString delegate:(id<DatePickerViewDelegate>)delegate;



- (void)show;
- (void)hide;
@end
