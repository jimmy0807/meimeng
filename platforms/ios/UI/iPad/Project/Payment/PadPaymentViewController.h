//
//  PadPaymentViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/11/3.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadPaymentCell.h"
#import "PadPayModeCell.h"
#import "PayBankManager.h"
#import "PadCashRegisterView.h"

@interface PadPaymentViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate, PadPaymentCellDelegate, PadPayModeCellDelegate, PadMaskViewDelegate, PadCashRegisterViewDelegate>

@property (nonatomic, weak) PadMaskView *maskView;
@property (nonatomic, weak) UINavigationController *outNavigationController;

@property (nonatomic) BOOL isGuadan;
@property (nonatomic) BOOL isGuadanPay;
@property (nonatomic) BOOL isAddItem;
@property (nonatomic) BOOL isBuyItemAndNotUse;

- (id)initWithPosOperate:(CDPosOperate *)posOperate;

- (void)didTextFieldEditDone:(UITextField *)textField;

@property(nonatomic, strong)NSNumber* orignalOperateID;

@end
