//
//  MemberCardPayModeViewController.h
//  Boss
//
//  Created by lining on 16/6/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "MemberCardOperateView.h"

@interface MemberCardPayModeViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>

//kPadMemberCardOperateRecharge充值； kPadMemberCardOperateRefund退款；kPadMemberCardOperateRepayment还款； kPadMemberCardOperateUpgrade卡升级；
 //kPadMemberCardOperateCashier收银； kPadMemberCardOperateBuy//购买
@property (assign, nonatomic) kPadMemberCardOperateType operateType;

@property (strong, nonatomic) CDMemberCard *card;
@property (nonatomic, assign) CGFloat expectMoney; //期望值

@property (nonatomic, strong) CDPosOperate *posOperate;
@property (nonatomic, strong) NSArray *arrears;
@property (nonatomic, strong) NSDictionary *updateParams;
@property (nonatomic, assign) BOOL refundCard;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureBtnPressed:(id)sender;

@end
