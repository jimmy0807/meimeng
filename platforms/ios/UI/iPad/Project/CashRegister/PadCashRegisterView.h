//
//  PadCashRegisterView.h
//  Boss
//
//  Created by XiaXianBing on 16/1/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayBankManager.h"
#import "PadSettingConstant.h"

@protocol PadCashRegisterViewDelegate <NSObject>
- (void)didPadSettingWithType:(kPadSettingViewType)type;
- (void)didPadCashRegisterFailed:(NSString *)error;
- (void)didPadCashRegisterSuccessWithPaymode:(CDPOSPayMode *)paymode amount:(CGFloat)amount bankNo:(NSString *)bankNo pos_type:(NSString*)pos_type;
@end

@interface PadCashRegisterView : UIView <PayBankManagerDelegate>

@property (nonatomic, assign) id<PadCashRegisterViewDelegate> delegate;

- (id)initWithPaymode:(CDPOSPayMode *)paymode amount:(CGFloat)amount;

@end
