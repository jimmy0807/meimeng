//
//  PadRefundViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadPaymentCell.h"
#import "PadPayModeCell.h"
#import "PadCardOperateSwitchCell.h"
#import "PadCashRegisterView.h"

@interface PadRefundViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, PadPaymentCellDelegate, PadPayModeCellDelegate, PadCashRegisterViewDelegate, PadCardOperateSwitchCellDelegate>

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithMemberCard:(CDMemberCard *)memberCard;

- (void)didTextFieldEditDone:(UITextField *)textField;

@end
