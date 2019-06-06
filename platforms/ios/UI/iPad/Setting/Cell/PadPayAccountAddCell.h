//
//  PadPayAccountAddCell.h
//  Boss
//
//  Created by XiaXianBing on 16/1/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PadSettingConstant.h"

#define kPadPayAccountAddCellWidth      (kPadSettingRightSideViewWidth - 2 * 32.0)
#define kPadPayAccountAddCellHeight      212.0

@class PadPayAccountAddCell;
@protocol PadPayAccountAddCellDelegate <NSObject>
- (void)didPadPayAccountConfirmButtonClick:(PadPayAccountAddCell *)cell;
- (void)padPayAccountAddCell:(PadPayAccountAddCell *)cell didTextFieldEndEdit:(UITextField *)textField;
@end

@interface PadPayAccountAddCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, assign) kPadPayAccountType accountType;
@property (nonatomic, assign) id<PadPayAccountAddCellDelegate> delegate;

@end
