//
//  PadNumberKeyboard.h
//  Boss
//
//  Created by lining on 16/1/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PadNumberKeyboardDelegate <NSObject>
@optional
- (void)didPadNumberKeyboardDonePressed:(UITextField*)textField;
@end

@interface PadNumberKeyboard : UIView
@property(nonatomic, weak) UITextField *textField;
@property(nonatomic, assign) CGRect rect;

- (instancetype) initWithTextField:(UITextField *)textField;
- (instancetype) initWithKeyboardWidth:(CGFloat)keyboardWidth textField:(UITextField *)textField;

@property(nonatomic, weak)id<PadNumberKeyboardDelegate> delegate;

@end

@interface UITextField (CustomKeyboard)

- (PadNumberKeyboard *)customNumberKeyBoard;
- (PadNumberKeyboard *)customNumberKeyBoardWithWidth:(CGFloat)width;

@end


