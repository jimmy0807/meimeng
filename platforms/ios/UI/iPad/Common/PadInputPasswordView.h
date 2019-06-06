//
//  PadInputPasswordView.h
//  Boss
//
//  Created by lining on 16/1/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputPasswordViewDelegate <NSObject>
@optional
- (void)didSelectedNumber:(NSString *)number;
- (void)didCancelBtnPressed;
- (void)didInputPasswordDone:(NSString *)password; 

@end

@interface PadInputPasswordView : UIView

@property(nonatomic, weak) id<InputPasswordViewDelegate>delegate;
- (instancetype) initWithMoney:(CGFloat)money delegate:(id<InputPasswordViewDelegate>)delegate;

- (void)clear; //清空密码

@end
