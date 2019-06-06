//
//  PadCardOperateViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/10/28.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadPaymentCell.h"
#import "PadPayModeCell.h"
#import "PadCashRegisterView.h"

@interface PadCardOperateViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate, PadPaymentCellDelegate, PadPayModeCellDelegate, PadMaskViewDelegate, PadCashRegisterViewDelegate>

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithMember:(CDMember *)member priceList:(CDMemberPriceList *)priceList cardNumber:(NSString *)number;
- (id)initWithMember:(CDMember *)member memberCard:(CDMemberCard *)memberCard operateType:(kPadMemberCardOperateType)operateType;
- (id)initWithMember:(CDMember *)member memberCard:(CDMemberCard *)memberCard arrears:(NSArray *)arrears;
- (id)initWithMemberCard:(CDMemberCard *)memberCard params:(NSDictionary *)params;

- (void)didTextFieldEditDone:(UITextField *)textField;

@end
