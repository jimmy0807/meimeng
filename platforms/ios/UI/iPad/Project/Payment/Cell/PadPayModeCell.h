//
//  PadPayModeCell.h
//  Boss
//
//  Created by XiaXianBing on 15/10/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PadProjectConstant.h"
#import "PadMaskViewConstant.h"

#define kPadPayModeCellWidth        kPadMaskViewWidth
#define kPadPayModeCellHeight       92.0

@class PadPayModeCell;
@protocol PadPayModeCellDelegate <NSObject>

- (void)didPadPaymodeCellContentClick:(PadPayModeCell *)cell;
- (void)didPadPaymodeCellCancelButtonClick:(PadPayModeCell *)cell;
- (void)didAmountTextFieldBeginEditing:(PadPayModeCell *)cell;
- (void)didAmountTextFieldEndEditing:(PadPayModeCell *)cell;
- (BOOL)didPadPayModeCellConfirm:(PadPayModeCell *)cell;

@end

@interface PadPayModeCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *contentButton;
@property (nonatomic, strong) UIImageView *detailImageView;
@property (nonatomic, strong) UILabel *paymodeLabel;
@property (nonatomic, strong) UITextField *amountTextField;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) id<PadPayModeCellDelegate> delegate;

- (void)hideInputViews;
- (void)didConfirmButtonClick:(id)sender;

@end
