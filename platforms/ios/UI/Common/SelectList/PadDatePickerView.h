//
//  PadDatePickerView.h
//  meim
//
//  Created by jimmy on 2017/5/10.
//
//

#import <UIKit/UIKit.h>

@interface PadDatePickerView : UIView

- (void)show;

@property(nonatomic, copy)void (^selectFinished)(NSDate* date);
@property(nonatomic)UIDatePickerMode datePickerMode;
@property(nonatomic, strong)NSDate* date;

@end
