//
//  PadProjectKeyboardView.h
//  Boss
//
//  Created by XiaXianBing on 15/10/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PadProjectConstant.h"

@class PadProjectKeyboardView;
@protocol PadProjectKeyboardViewDelegate  <NSObject>
- (void)addServiceWithAmount:(CGFloat)amount;
- (void)didKeyboardViewClose:(PadProjectKeyboardView *)keyboardView;
@end

@interface PadProjectKeyboardView : UIView

@property (nonatomic, strong) NSMutableString *currentstr;

- (id)initWithFrame:(CGRect)frame delegate:(id<PadProjectKeyboardViewDelegate>)delegate;

@end
