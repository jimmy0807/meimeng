//
//  MemberCardPayModeViewController.m
//  Boss
//
//  Created by lining on 16/6/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardPayModeViewController.h"
#import "PayModeCell.h"
#import "MemberPayAlertFieldView.h"
#import "PaymentCell.h"
#import "BSMemberCardOperateRequest.h"
#import "CBLoadingView.h"
#import "MemberCardInfoViewController.h"
#import "CBMessageView.h"
#import "BNActionSheet.h"
#import "OperateManager.h"
#import "MemberFunctionViewController.h"
#import "BSSuccessViewController.h"
#import "BNScanCodeViewController.h"
#import "BSAlipayTradeRequest.h"
#import "BSAlipayRefundRequest.h"

#define kFloat  0.0001

@interface MemberCardPayModeViewController ()<PayModeCellDelegate,MemberPayAlertFieldViewDelegate,PaymentCellDelegate,BNActionSheetDelegate,BSSuccessViewControllerDelegate, BNScanCodeDelegate>
{
    
}
@property (nonatomic, strong) CDPOSPayMode *currentPayMode;//当前支付方式
@property (nonatomic, strong) NSMutableArray *payModes;//支付方式
@property (nonatomic, strong) NSMutableArray *payments;//已支付数组

@property (nonatomic, strong) MemberPayAlertFieldView *payAlertView;
@property (nonatomic, assign) CGFloat payMoney; //已完成值
@property (nonatomic, assign) CGFloat remainMoney;//剩余值 = expectMoney - payMoney


@property (nonatomic, assign) CGFloat cardAmount; //会员卡金额
@property (nonatomic, assign) CGFloat couponAmount; //优惠券金额
@property (nonatomic, assign) CGFloat pointAmount; //积分金额
@property (nonatomic, assign) CGFloat cardPoints; //积分


@property (nonatomic, strong) NSNumber *operateID; //单据号
@property (nonatomic, strong) CDMember *member;

@property (nonatomic, strong) NSMutableDictionary *alipayParams;

@end

@implementation MemberCardPayModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    self.payModes = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchPOSPayMode]];
    
    
    self.payments = [NSMutableArray array];
  
    
    [self initTitle];
    [self initData];
    
//    self.payModes = [
    
   
    
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, 25)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableFooterView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    [self registerNofitificationForMainThread:kBSAlipayTradeResponse];
    [self registerNofitificationForMainThread:kBSAlipayRefundResponse];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initData
{
    self.payModes = [NSMutableArray array];
    NSArray *modeArray = [[BSCoreDataManager currentManager] fetchPOSPayMode];
    
    if (self.operateType == kPadMemberCardOperateRefund) {
        //退款
        for (CDPOSPayMode *payMode in modeArray) {
            if (payMode.mode.integerValue == kPadPayModeTypeCash || payMode.mode.integerValue == kPadPayModeTypeBankCard)
            {
                [self.payModes addObject:payMode];
            }
        }
    }
    else if (self.operateType == kPadMemberCardOperateCashier || self.operateType == kPadMemberCardOperateBuy)
    {
         //收银 & 购买
        for (CDPOSPayMode *payMode in modeArray) {
            if (payMode.mode.integerValue == kPadPayModeTypeCard) {
                if (self.posOperate.member == nil || self.posOperate.member.isDefaultCustomer.boolValue)
                {
                    NSLog(@"散客无法使用会员卡");
                }
                else
                {
                    [self.payModes insertObject:payMode atIndex:0];
                    self.cardAmount = self.posOperate.memberCard.balance.floatValue;
                }

            }
            else if (payMode.mode.integerValue == kPadPayModeTypeCoupon)
            {
                if (self.posOperate.member == nil || self.posOperate.member.isDefaultCustomer.boolValue)
                {
                    NSLog(@"散客无法使用优惠券");
                }
                else
                {
                    if (self.posOperate.couponCard == nil || self.posOperate.couponCard.remainAmount.floatValue == 0)
                    {
                        NSLog(@"无优惠券");
                    }
                    else
                    {
                        [self.payModes addObject:payMode];
                        self.couponAmount = self.posOperate.couponCard.remainAmount.floatValue;
                    }
                }
            }
            else if (payMode.mode.integerValue == kPadPayModeTypePoint)
            {
                if (self.posOperate.member == nil || self.posOperate.member.isDefaultCustomer.boolValue)
                {
                    NSLog(@"散客无法使用积分");
                }
                else
                {
                    [self.payModes addObject:payMode];
                    self.cardPoints = self.posOperate.memberCard.points.floatValue;
                    self.pointAmount = self.posOperate.memberCard.points.floatValue * self.posOperate.memberCard.priceList.points2Money.floatValue;
                }
            }
            else
            {
                [self.payModes addObject:payMode];
            }
            
//            if (payMode.mode.integerValue == kPadPayModeTypeCash || payMode.mode.integerValue == kPadPayModeTypeBankCard)
//            {
//                
//            }
        }
        if (self.posOperate.member != nil && !self.posOperate.member.isDefaultCustomer.boolValue)
        {
            [self.payModes addObject:@"now_arrears_amount"];
        }
    }
    else
    {
        //充值 还款 卡升级
        for (CDPOSPayMode *payMode in modeArray) {
            if (payMode.mode.integerValue == kPadPayModeTypeCard || payMode.mode.integerValue == kPadPayModeTypeCoupon || payMode.mode.integerValue == kPadPayModeTypePoint)
            {
                continue;
            }
            else
            {
                [self.payModes addObject:payMode];
            }
        }
        
        if (self.operateType == kPadMemberCardOperateRecharge) {
            [self.payModes addObject:@"now_arrears_amount"];
        }
    }

}

- (void)initTitle
{
    self.payMoney = 0.0;
    if (self.operateType == kPadMemberCardOperateRecharge)
    {
        self.expectMoney = self.card.priceList.refill_money.floatValue;
        self.navigationItem.title = [NSString stringWithFormat:@"%.2f元续充", self.expectMoney];
    }
    else if (self.operateType == kPadMemberCardOperateRepayment)
    {
//        self.expectMoney = self.card.priceList.refill_money.floatValue;
        self.navigationItem.title = [NSString stringWithFormat:@"待还金额¥%.2f", self.expectMoney];
    }
    
    else if (self.operateType == kPadMemberCardOperateUpgrade)
    {
        self.navigationItem.title = @"不需支付任何升级费用请直接确认";
    }
    else if (self.operateType == kPadMemberCardOperateRefund)
    {
        self.navigationItem.title = [NSString stringWithFormat:@"卡内余额￥%.2f",self.card.amount.floatValue];
    }
    else if (self.operateType == kPadMemberCardOperateCashier)
    {
        self.expectMoney = self.posOperate.amount.floatValue;
        self.navigationItem.title = [NSString stringWithFormat:@"未付:￥%.2f",self.expectMoney];
    }
    
    self.remainMoney = self.expectMoney - self.payMoney;
}

- (void)reloadTitle
{
    if (self.operateType == kPadMemberCardOperateRepayment)
    {
        if (self.remainMoney < 0) {
            self.navigationItem.title = [NSString stringWithFormat:@"找零:￥%.2f",fabs(self.remainMoney)];
        }
        else
        {
            self.navigationItem.title = [NSString stringWithFormat:@"待还金额¥%.2f", self.remainMoney];
        }
    }
    else if (self.operateType == kPadMemberCardOperateRefund)
    {
        if (self.remainMoney < 0) {
            self.navigationItem.title = [NSString stringWithFormat:@"找零:￥%.2f",fabs(self.remainMoney)];
        }
        else
        {
            self.navigationItem.title = [NSString stringWithFormat:@"卡内金额¥%.2f", self.remainMoney];
        }
    }
    else if (self.operateType == kPadMemberCardOperateCashier)
    {
        if (self.remainMoney < 0) {
            self.navigationItem.title = [NSString stringWithFormat:@"找零:￥%.2f",fabs(self.remainMoney)];
        }
        else
        {
            self.navigationItem.title = [NSString stringWithFormat:@"未付:￥%.2f",self.remainMoney];
        }
    }
}


- (void)setOperateType:(kPadMemberCardOperateType)operateType
{
    _operateType = operateType;
    
}

- (void)setRemainMoney:(CGFloat)remainMoney
{
    _remainMoney = remainMoney;
    if (_remainMoney <= 0) {
        self.sureBtn.enabled = true;
    }
    else
    {
        self.sureBtn.enabled = false;
    }
    if (self.operateType == kPadMemberCardOperateRepayment) {
        if (_remainMoney < 0) {
            
        }
    }
    [self reloadTitle];
}

- (void)setPayMoney:(CGFloat)payMoney
{
    _payMoney = payMoney;
    self.remainMoney = self.expectMoney - payMoney;
    
    if (self.operateType == kPadMemberCardOperateRepayment || self.operateType == kPadMemberCardOperateRefund) {
        if (_payMoney > 0) {
            self.sureBtn.enabled = true;

        }
    }
    
//    if (self.remainMoney <= 0) {
//        self.sureBtn.enabled = true;
//    }
//    else
//    {
//        self.sureBtn.enabled = false;
//    }
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSMemberCardOperateResponse]) {
        [[CBLoadingView shareLoadingView] hide];
        
        NSInteger ret = [[notification.userInfo numberValueForKey:@"rc"] integerValue];
        NSString *msg = [notification.userInfo stringValueForKey:@"rm"];
        
        if (ret == 0)
        {
            NSString *title;
            if (self.operateType == kPadMemberCardOperateRecharge) {
                title = @"卡充值成功";
            }
            if (self.operateType == kPadMemberCardOperateUpgrade) {
                title = @"卡升级成功";
            }
            if (self.operateType == kPadMemberCardOperateRepayment) {
                title = @"卡还款成功";
            }
            else if (self.operateType == kPadMemberCardOperateRefund)
            {
                title = @"退款成功";
            }
            else if (self.operateType == kPadMemberCardOperateCashier)
            {
                title = @"收银成功";
            }
            else if (self.operateType == kPadMemberCardOperateBuy)
            {
                title = @"购买成功";
            }
            
            self.operateID = [notification.object objectForKey:@"operate_id"];
            
            if (self.operateType == kPadMemberCardOperateCashier )
            {
                NSLog(@"收银成功");
                self.member = [OperateManager shareManager].posOperate.member;
                [OperateManager shareManager].posOperate.isLocal = false;
                [OperateManager shareManager].posOperate = nil;
//                for (UIViewController *viewController in self.navigationController.viewControllers) {
//                    if ([viewController isKindOfClass:[MemberFunctionViewController class]]) {
//                        [self.navigationController popToViewController:viewController animated:YES];
//                        [[[CBMessageView alloc] initWithTitle:title] show];
//                        return;
//                    }
//                }
                
                
                BSSuccessViewController *successVC = [BSSuccessViewController createViewControllerWithTopTip:nil contentTitle:@"收银成功" detailTitle:[NSString stringWithFormat:@"¥%.2f",self.expectMoney]];
                successVC.operateID = self.operateID;
                successVC.member = self.member;
                successVC.delegate = self;
                successVC.style = ViewShowStyle_Cashier;
                [self.navigationController pushViewController:successVC animated:YES];
                return;
                
//                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                for (UIViewController *viewController in self.navigationController.viewControllers) {
                    if ([viewController isKindOfClass:[MemberCardInfoViewController class]]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                        break;
                    }
                }
            }
            [[[CBMessageView alloc] initWithTitle:title] show];
        }
        else
        {
            CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:msg];
            [msgView show];
        }
    }
    else if ([notification.name isEqualToString:kBSAlipayTradeResponse] )
    {
        NSDictionary* params = notification.userInfo;
        NSNumber* errorCode = params[@"errcode"];
        if ( errorCode && [errorCode integerValue] == 0 )
        {
            NSString* tradeNo = params[@"data"][@"trade_no"];
            NSNumber* record = params[@"data"][@"record"];
            BSAlipayTradeRequest* request = notification.object;
            CGFloat amount = [self.alipayParams[@"total_amount"] floatValue];
            if ( amount > 0 )
            {
                [self didSureBtnPressedWithPayMode:request.paymode money:amount bankNo:tradeNo pos_type:[record stringValue]];
            }
            else
            {
                NSInteger wxAmount = [self.alipayParams[@"total_fee"] integerValue];
                tradeNo = params[@"data"][@"out_trade_no"];
                
                [self didSureBtnPressedWithPayMode:request.paymode money:1.0 * wxAmount / 100 bankNo:tradeNo pos_type:[record stringValue]];
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:params[@"errmsg"]
                                                               delegate:nil
                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else if ([notification.name isEqualToString:kBSAlipayRefundResponse] )
    {
        NSDictionary* params = notification.userInfo;
        NSNumber* errorCode = params[@"errcode"];
        if ( errorCode && [errorCode integerValue] == 0 )
        {
            BSAlipayRefundRequest* request = (BSAlipayRefundRequest*)notification.object;
            NSDictionary *dict = [self.payments objectAtIndex:request.paymentIndex];
            [self.payments removeObjectAtIndex:request.paymentIndex];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:request.paymentIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            self.payMoney -= [dict[@"amount"] floatValue];
            
            [self performSelector:@selector(delayToReload) withObject:nil afterDelay:0.3];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:params[@"errmsg"]
                                                               delegate:nil
                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

#pragma mark - BSSuccessViewControllerDelegate
- (void)didCashierBtnPressed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPushToCashier object:self.operateID];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)didAssignBtnPressed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPushToAssign object:self.operateID];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)didSendBtnPressed
{
    if (self.member) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushToGive object:self.operateID userInfo:@{@"member":self.member}];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushToGive object:self.operateID userInfo:nil];
    }

    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (self.operateType == kPadMemberCardOperateRecharge) {
//        return self.payModes.count + 1 + 1; // +1为顶部支付列表 +1为欠款支付
//    }
//    else
//    {
//       
//    }
     return self.payModes.count + 1; // +1为顶部支付列表
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.payments.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentCell"];
        if (cell == nil) {
            cell = [PaymentCell createCell];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *paymentDict = [self.payments objectAtIndex:row];
        NSObject *payMode = [paymentDict objectForKey:@"mode"];
        NSNumber *payAmount = [paymentDict objectForKey:@"amount"];
        cell.indexPath = indexPath;
        cell.payMode = payMode;
        cell.amount = payAmount.floatValue;
        if ([payMode isKindOfClass:[CDPOSPayMode class]]) {
            cell.titleLabel.text = [NSString stringWithFormat:@"%@:￥%.2f",((CDPOSPayMode *)payMode).payName,payAmount.floatValue];
        }
        else
        {
            cell.titleLabel.text = [NSString stringWithFormat:@"%@:￥%.2f",@"欠款支付",payAmount.floatValue];
        }
        
        return cell;
    }
    else
    {
        PayModeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayModeCell"];
        if (cell == nil) {
            cell = [PayModeCell createCell];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        CDPOSPayMode *payMode = [self.payModes objectAtIndex:section - 1];
        if ([payMode isKindOfClass:[CDPOSPayMode class]]) {
            cell.payMode = payMode;
        }
        else
        {
            cell.payMode = nil;
            [cell.payBtn setTitle:@"欠款支付" forState:UIControlStateNormal];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 25;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - PaymentCellDelegate
- (void)didCancelBtnPressed:(PaymentCell *)cell
{
    if ([cell.payMode isKindOfClass:[CDPOSPayMode class]])
    {
        CDPOSPayMode *payMode = (CDPOSPayMode *)cell.payMode;
        if (payMode.mode.integerValue == kPadPayModeTypeAlipay || payMode.mode.integerValue == kPadPayModeTypeWeChat )
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:LS(@"PadDeletePaymemtRemindInfo") delegate:self cancelButtonTitle:LS(@"PadDeletePaymentCancel") otherButtonTitles:LS(@"PadDeletePaymentConfirm"), nil];
            alertView.tag = cell.indexPath.row;
            [alertView show];
            
            return;
        }
    }
    
    [self.payments removeObjectAtIndex:cell.indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.payMoney -= cell.amount;
    if ([cell.payMode isKindOfClass:[CDPOSPayMode class]]) {
        CDPOSPayMode *payMode = (CDPOSPayMode *)cell.payMode;
        if (payMode.mode.integerValue == kPadPayModeTypeCard) {
            self.cardAmount += cell.amount;
        }
        else if (payMode.mode.integerValue == kPadPayModeTypeCoupon)
        {
            self.couponAmount += cell.amount;
        }
        else if (payMode.mode.integerValue == kPadPayModeTypePoint)
        {
            self.pointAmount += cell.amount;
            self.cardPoints = self.pointAmount/self.posOperate.memberCard.priceList.points2Money.floatValue;
        }
    }
    
    [self performSelector:@selector(delayToReload) withObject:nil afterDelay:0.3];
}

- (void)delayToReload
{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSDictionary *dict = [self.payments objectAtIndex:alertView.tag];
       
        NSObject *object = [dict objectForKey:@"mode"];
        if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            
            if ( paymode.mode.integerValue == kPadPayModeTypeAlipay )
            {
                NSString* bankNo = [dict objectForKey:@"bankNo"];
                
                NSMutableDictionary* alipayParams = [NSMutableDictionary dictionary];
                alipayParams[@"payment_id"] = paymode.payment_acquirer_id;
                alipayParams[@"method"] = @"alipay.trade.refund";
                alipayParams[@"trade_no"] = bankNo;
                alipayParams[@"out_request_no"] = @"system_generates";
                alipayParams[@"body"] = @"Pad收银";
                alipayParams[@"refund_amount"] = [dict objectForKey:@"amount"];
                alipayParams[@"refund_reason"] = @"退款";
                alipayParams[@"operator_id"] = [PersonalProfile currentProfile].userID;
                alipayParams[@"store_id"] = [PersonalProfile currentProfile].getCurrentStoreID;
                alipayParams[@"terminal_id"] = [PersonalProfile currentProfile].getCurrentStoreID;
                
                BSAlipayRefundRequest* request = [[BSAlipayRefundRequest alloc] initWithParams:alipayParams];
                request.paymentIndex = alertView.tag;
                [request execute];
            }
            else if ( paymode.mode.integerValue == kPadPayModeTypeWeChat )
            {
                NSString* bankNo = [dict objectForKey:@"bankNo"];
                
                NSMutableDictionary* alipayParams = [NSMutableDictionary dictionary];
                alipayParams[@"payment_id"] = paymode.payment_acquirer_id;
                alipayParams[@"out_trade_no"] = bankNo;
                alipayParams[@"out_refund_no"] = @"system_generates";
                alipayParams[@"device_info"] = [PersonalProfile currentProfile].deviceString;
                alipayParams[@"refund_fee"] = @((int)([[dict objectForKey:@"amount"] floatValue] * 100));
                alipayParams[@"total_fee"] = @((int)([[dict objectForKey:@"amount"] floatValue] * 100));
                alipayParams[@"op_user_id"] = [PersonalProfile currentProfile].userID;
                
                BSAlipayRefundRequest* request = [[BSAlipayRefundRequest alloc] initWithParams:alipayParams];
                request.paymentIndex = alertView.tag;
                [request execute];
            }
        }
    }
}

#pragma mark - PayModeCellDelegate
- (void)didPayModeBtnPressed:(CDPOSPayMode *)payMode
{
    if (self.operateType == kPadMemberCardOperateRepayment) {
        if (self.remainMoney - kFloat < 0) {
            [[[CBMessageView alloc] initWithTitle:[NSString stringWithFormat:@"亲，你的欠款 ￥%.2f 已还完，如无问题，请点确认进行还款",self.expectMoney]] show];
            return;
        }
    }
    
    if (self.operateType == kPadMemberCardOperateBuy || self.operateType == kPadMemberCardOperateCashier) {
        if (self.remainMoney - kFloat < 0) {
            [[[CBMessageView alloc] initWithTitle:[NSString stringWithFormat:@"亲，客户消费的 ￥%.2f 已支付完，如无问题，请点确认进行结算",self.expectMoney]] show];
            return;
        }
    }
    
    
    
    NSLog(@"%@",payMode.payName);
    self.currentPayMode = payMode;
    if (self.payAlertView) {
        self.payAlertView.payMode = payMode;
        self.payAlertView.payMoney = self.remainMoney > 0 ? self.remainMoney : 0;
    }
    else
    {
        self.payAlertView = [MemberPayAlertFieldView createViewWithPayMode:payMode money:self.remainMoney > 0 ? self.remainMoney : 0 delegate:self];
    }
    
//    if (self.operateType == kPadMemberCardOperateBuy) {
//        self.payAlertView.card = self.card;
//    }
    
    if (payMode.mode) {
        if (payMode.mode.integerValue == kPadPayModeTypeCard) {
            
            if (self.cardAmount - kFloat <= 0) {
                [[[CBMessageView alloc] initWithTitle:@"当前会员卡内余额为0,请选择其他支付方式付款"] show];
                return;
            }
            self.payAlertView.titleLabel.text = [NSString stringWithFormat:@"会员卡(余额:￥%.2f)",self.cardAmount];
            
        }
        else if (payMode.mode.integerValue == kPadPayModeTypeCoupon)
        {
            if (self.couponAmount - kFloat <= 0) {
                [[[CBMessageView alloc] initWithTitle:@"当前优惠券金额为0,请选择其他支付方式付款"] show];
                return;
            }
            self.payAlertView.titleLabel.text = [NSString stringWithFormat:@"优惠券(余额:￥%.2f)",self.couponAmount];
        }
        else if (payMode.mode.integerValue == kPadPayModeTypePoint)
        {
            if (self.pointAmount - kFloat <= 0) {
                [[[CBMessageView alloc] initWithTitle:@"当前积分为0,请选择其他支付方式付款"] show];
                return;
            }
            self.payAlertView.titleLabel.text = [NSString stringWithFormat:@"积分(当前积分%.2f,最高可抵扣￥%.2f)",self.cardPoints,self.pointAmount];
        }
    }
    [self.payAlertView show];
}

#pragma mark - MemberPayAlertFieldViewDelegate
- (void) didSureBtnPressedWithPayMode:(CDPOSPayMode *)payMode money:(CGFloat)money
{
    [self didSureBtnPressedWithPayMode:payMode money:money bankNo:@"" pos_type:@""];
}

- (void) didSureBtnPressedWithPayMode:(CDPOSPayMode *)payMode money:(CGFloat)money bankNo:(NSString *)bankNo pos_type:(NSString *)pos_type
{
    if (payMode) {
        if (payMode.mode.integerValue == kPadPayModeTypeCard) {
            money = MIN(money, self.cardAmount);
            self.cardAmount -= money;
        }
        else if (payMode.mode.integerValue == kPadPayModeTypeCoupon)
        {
            money = MIN(money, self.couponAmount);
            self.couponAmount -= money;
        }
        else if (payMode.mode.integerValue == kPadPayModeTypePoint)
        {
            money = MIN(money, self.pointAmount);
            self.pointAmount -= money;
            self.cardPoints = self.pointAmount/self.posOperate.memberCard.priceList.points2Money.floatValue;
        }
    }
    if (self.operateType == kPadMemberCardOperateRecharge) {
        
    }
    else if (self.operateType == kPadMemberCardOperateRepayment)
    {
        if (money > self.remainMoney) {
            if (payMode.mode.integerValue != kPadPayModeTypeCash) {
                money = self.remainMoney;
            }
        }
    }
    else if (self.operateType == kPadMemberCardOperateBuy || self.operateType == kPadMemberCardOperateCashier)
    {
        if (payMode.mode.integerValue != kPadPayModeTypeCash) {
            if (money - self.remainMoney >= kFloat) {
                money = self.remainMoney;
            }
        }
    }
    
    if ( bankNo.length == 0 && pos_type.length == 0 && payMode )
    {
        if (payMode.mode.integerValue == kPadPayModeTypeAlipay)
        {
            self.alipayParams = [NSMutableDictionary dictionary];
            self.alipayParams[@"payment_id"] = payMode.payment_acquirer_id;
            self.alipayParams[@"method"] = @"alipay.trade.pay";
            self.alipayParams[@"subject"] = @"Pad收银";
            self.alipayParams[@"body"] = @"Pad收银";
            self.alipayParams[@"total_amount"] = @(money);
            self.alipayParams[@"undiscountable_amount"] = @(money);
            self.alipayParams[@"operator_id"] = [PersonalProfile currentProfile].userID;
            self.alipayParams[@"store_id"] = [PersonalProfile currentProfile].getCurrentStoreID;
            self.alipayParams[@"terminal_id"] = [PersonalProfile currentProfile].deviceString;
            self.alipayParams[@"timeout_express"] = @"15m";
            self.alipayParams[@"out_trade_no"] = @"system_generates";
            
            BNScanCodeViewController* vc = [[BNScanCodeViewController alloc] initWithDelegate:self];
            vc.paymode = payMode;
            [self.navigationController pushViewController:vc animated:true];
            
            return;
        }
        else if (payMode.mode.integerValue == kPadPayModeTypeWeChat)
        {
            self.alipayParams = [NSMutableDictionary dictionary];
            self.alipayParams[@"payment_id"] = payMode.payment_acquirer_id;
            self.alipayParams[@"body"] = @"Pad收银";
            self.alipayParams[@"total_fee"] = @((int)(money * 100));
            self.alipayParams[@"device_info"] = [PersonalProfile currentProfile].deviceString;
            self.alipayParams[@"out_trade_no"] = @"system_generates";
            
            BNScanCodeViewController* vc = [[BNScanCodeViewController alloc] initWithDelegate:self];
            vc.paymode = payMode;
            [self.navigationController pushViewController:vc animated:true];
            
            return;
        }
    }
    
    BOOL isExist = false;
    NSInteger row = -1;
    NSMutableDictionary *paymentDict = [NSMutableDictionary dictionary];
    self.payMoney += money;
    
    paymentDict[@"bankNo"] = bankNo;
    paymentDict[@"pos_type"] = pos_type;
    
    if (self.currentPayMode && self.currentPayMode.mode.integerValue == kPadPayModeTypeBankCard) {
        
    }
    else
    {
        for (NSMutableDictionary *paymentDict in self.payments) {
            row ++;
            NSObject *payMode = [paymentDict objectForKey:@"mode"];
            if (self.currentPayMode)
            {
                if ([payMode isKindOfClass:[CDPOSPayMode class]] && (((CDPOSPayMode *)payMode).mode.integerValue == self.currentPayMode.mode.integerValue)) {
                    NSNumber *amount = [paymentDict objectForKey:@"amount"];
                    paymentDict[@"amount"] = @(money + amount.floatValue);
                    isExist = true;
                    break;
                }
            }
            else
            {
                if ([payMode isKindOfClass:[NSString class]] && ([((NSString *) payMode) isEqualToString:@"now_arrears_amount"])) {
                    NSNumber *amount = [paymentDict objectForKey:@"amount"];
                    paymentDict[@"amount"] = @(money + amount.floatValue);
                    isExist = true;
                    break;
                }
            }
        }
    }
    if (isExist) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        if (self.currentPayMode) {
            paymentDict[@"mode"] = self.currentPayMode;
        }
        else
        {
            paymentDict[@"mode"] = @"now_arrears_amount";
        }
        
        paymentDict[@"amount"] = @(money);
        [self.payments addObject:paymentDict];
        row = self.payments.count - 1;
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)doAlipayRequest:(CDPOSPayMode*)paymode
{
    NSMutableArray* productArray = [NSMutableArray array];
    
    for (int i = 0; i < self.posOperate.products.count; i++)
    {
        CDPosProduct *product = (CDPosProduct *)[self.posOperate.products objectAtIndex:i];
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        if ( self.alipayParams[@"total_fee"] ) //微信
        {
            params[@"goods_id"] = product.product_id;
            params[@"goods_name"] = product.product_name;
            params[@"goods_num"] = product.product_qty;
            params[@"goood_category"] = @(0);
            params[@"price"] = product.product_price;
            params[@"body"] = product.product_name;
        }
        else
        {
            params[@"goods_id"] = product.product_id;
            params[@"goods_name"] = product.product_name;
            params[@"quantity"] = product.product_qty;
            params[@"goood_category"] = @(0);
            params[@"price"] = product.product_price;
            params[@"body"] = product.product_name;
        }
        
        [productArray addObject:params];
    }
    
    if ( self.alipayParams[@"total_fee"] ) //微信
    {
        self.alipayParams[@"detail"] = productArray;
    }
    else
    {
        self.alipayParams[@"goods_detail"] = productArray;
    }
    
    BSAlipayTradeRequest* request = [[BSAlipayTradeRequest alloc] initWithParams:self.alipayParams];
    request.paymode = paymode;
    [request execute];
}

- (void)scanCodeViewController:(BNScanCodeViewController *)viewController didScanSuccess:(NSString *)result;
{
    if ( result.length > 0 )
    {
        self.alipayParams[@"auth_code"] = result;
        [self doAlipayRequest:viewController.paymode];
    }
}

- (void) didChangeBtnPressedWithPayMode:(CDPOSPayMode *)payMode
{
    
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)sureBtnPressed:(id)sender {
    if (self.operateType == kPadMemberCardOperateRecharge)
    {
        [self rechargeRequest];
    }
    else if (self.operateType == kPadMemberCardOperateUpgrade)
    {
        [self upgradeRequest];
    }
    else if (self.operateType == kPadMemberCardOperateRepayment)
    {
        [self repaymentRequest];
    }
    else if (self.operateType == kPadMemberCardOperateRefund)
    {
        if (self.refundCard)
        {
            if (self.card.amount.floatValue > 0 /* || self.memberCard.courseRemainAmount.floatValue > 0 */)
            {
                BNActionSheet *actionSheet = [[BNActionSheet alloc]
                                              initWithTitle:LS(@"PadRefundCardRemindOverage")
                                              items:@[LS(@"PadRefundCardSure")]
                                              cancelTitle:LS(@"Cancel")
                                              delegate:self];
                [actionSheet show];
            }
            else
            {
                BNActionSheet *actionSheet = [[BNActionSheet alloc]
                                              initWithTitle:LS(@"PadRefundCardRemindInfo")
                                              items:@[LS(@"PadRefundCardSure")]
                                              cancelTitle:LS(@"Cancel")
                                              delegate:self];
                [actionSheet show];
            }
            
            return;
        }
        else
        {
            [self refundCardRequest];
        }
    }
    else if (self.operateType == kPadMemberCardOperateCashier || self.operateType == kPadMemberCardOperateBuy)
    {
        [self cashierReqeust];
    }
}

#pragma mark - REQUEST

#pragma mark - recharge request 充值
- (void)rechargeRequest
{
    NSDictionary *params = [NSDictionary dictionary];
    CGFloat arrearsAmount = 0.0;
    NSMutableArray *statementIds = [NSMutableArray array];
    for (int i = 0; i < self.payments.count; i++)
    {
        NSMutableDictionary *dict = (NSMutableDictionary *)[self.payments objectAtIndex:i];
        NSObject *object = [dict objectForKey:@"mode"];
        if ([object isKindOfClass:[NSString class]])
        {
            arrearsAmount = [[dict objectForKey:@"amount"] floatValue];
        }
        else if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            NSArray *payArray = [self paymentParamArray:dict];
            [statementIds addObject:payArray];
        }
    }
   
    params = @{@"card_id":self.card.cardID, @"now_arrears_amount":@(arrearsAmount), @"statement_ids":statementIds};
    
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:self.operateType];
    [request execute];
    [[CBLoadingView shareLoadingView] show];
}

#pragma mark - upgrade request 卡升级
- (void)upgradeRequest
{
    NSDictionary *params = [NSDictionary dictionary];
    NSMutableArray *statementIds = [NSMutableArray array];
    for (int i = 0; i < self.payments.count; i++)
    {
        NSMutableDictionary *dict = (NSMutableDictionary *)[self.payments objectAtIndex:i];
        NSObject *object = [dict objectForKey:@"mode"];
        if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            NSArray *payArray = [self paymentParamArray:dict];
            [statementIds addObject:payArray];
        }
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.updateParams];
    [dict setObject:statementIds forKey:@"statement_ids"];
    params = [NSDictionary dictionaryWithDictionary:dict];
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:self.operateType];
    [request execute];
    [[CBLoadingView shareLoadingView] show];

}
#pragma mark - repayment request 还款
- (void)repaymentRequest
{
    NSDictionary *params = [NSDictionary dictionary];
    for (CDMemberCardArrears *arrears in self.arrears)
    {
        arrears.tempAmount = @(arrears.unRepaymentAmount.floatValue);
    }
    
    NSMutableArray *repaymentIds = [NSMutableArray array];
    NSMutableArray *mutableArrears = [NSMutableArray arrayWithArray:self.arrears];
    // "type":[arrears]-充值欠款 [course_arrears]-消费欠款
    // NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"arrearsType" ascending:YES];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    [mutableArrears sortUsingDescriptors:sortArray];
    
    for (int i = 0; i < mutableArrears.count; i++) {
        CDMemberCardArrears *arrear = [mutableArrears objectAtIndex:i];
        for (int j = 0; j < self.payments.count; j ++) {
            NSMutableDictionary *payDict = [self.payments objectAtIndex:j];
            CDPOSPayMode *payMode = [payDict objectForKey:@"mode"];
            CGFloat amount = [[payDict objectForKey:@"amount"] floatValue];
            
            if (arrear.tempAmount.floatValue == amount) {
                NSArray *array = @[@(0), @(NO), @{@"repayment_amount":@(amount), @"arrears_id":arrear.arrearsID, @"name":arrear.arrearsName, @"journal_id":payMode.payID}];
                
                [repaymentIds addObject:array];
                
                [mutableArrears removeObjectAtIndex:i];
                i--;
                
                [self.payments removeObjectAtIndex:j];
                j--;
                break;
                
            }
            if (arrear.tempAmount.floatValue > amount) {
                NSArray *array = @[@(0), @(NO), @{@"repayment_amount":@(amount), @"arrears_id":arrear.arrearsID, @"name":arrear.arrearsName, @"journal_id":payMode.payID}];
                [repaymentIds addObject:array];
                
                arrear.tempAmount = @(arrear.tempAmount.floatValue - amount);
                
                [self.payments removeObjectAtIndex:j];
                j --;
                continue;
            }
            if (arrear.tempAmount.floatValue < amount) {
                CGFloat amount = arrear.tempAmount.floatValue;
                NSArray *array = @[@(0), @(NO), @{@"repayment_amount":@(arrear.tempAmount.floatValue), @"arrears_id":arrear.arrearsID, @"name":arrear.arrearsName, @"journal_id":payMode.payID}];
                [repaymentIds addObject:array];
                
                [mutableArrears removeObjectAtIndex:i];
                [payDict setObject:@(amount - arrear.tempAmount.floatValue) forKey:@"amount"];
                
                i--;
                break;
            }
        }
    }
    params = @{@"card_id":self.card.cardID, @"repayment_ids":repaymentIds};
    
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:self.operateType];
    [request execute];
    [[CBLoadingView shareLoadingView] show];

}

#pragma mark - refund request 退卡
- (void)refundCardRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.card.cardID forKey:@"card_id"];
    [params setObject:@(self.refundCard) forKey:@"is_card_cancel"];
//    [params setObject:@(self.deductionPoints) forKey:@"points"];
    
    NSMutableArray *statementIds = [NSMutableArray array];
    for (int i = 0; i < self.payments.count; i++)
    {
        NSMutableDictionary *dict = (NSMutableDictionary *)[self.payments objectAtIndex:i];
        NSArray *payArray = [self paymentParamArray:dict];
        [statementIds addObject:payArray];
    }
    [params setObject:statementIds forKey:@"statement_ids"];
    
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:self.operateType];
    [request execute];
    [[CBLoadingView shareLoadingView] show];
}

#pragma mark - cachis request 收银
- (void)cashierReqeust
{
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( self.posOperate.memberCard )
    {
        [params setObject:self.posOperate.memberCard.cardID forKey:@"card_id"];
    }
    if (self.posOperate.couponCard.cardID.integerValue == 0)
    {
        [params setObject:[NSArray array] forKey:@"coupon_ids"];
    }
    
    if ((self.posOperate.orderState.integerValue == kPadOrderDraft || self.posOperate.orderState.integerValue == kPadOrderSubmit) && self.posOperate.orderID.integerValue != 0)
    {
        [params setObject:self.posOperate.orderID forKey:@"pad_order_id"];
    }
    if (self.posOperate.member.isDefaultCustomer.boolValue && self.posOperate.book)
    {
        [params setObject:[NSString stringWithFormat:@"%@, %@, %@", @"散客", self.posOperate.book.booker_name, self.posOperate.book.telephone] forKey:@"remark"];
    }
    NSMutableArray *reserveIds = [NSMutableArray array];
    NSMutableDictionary* couponCardsProductParams = [NSMutableDictionary dictionary];
    if (self.posOperate.book != nil && self.posOperate.book.book_id.integerValue != 0)
    {
        [reserveIds addObject:self.posOperate.book.book_id];
    }
    for (CDCurrentUseItem *useItem in self.posOperate.useItems)
    {
        if (useItem.book != nil && useItem.book.book_id.integerValue != 0)
        {
            [reserveIds addObject:useItem.book.book_id];
        }
    }
    for (CDPosProduct *product in self.posOperate.products)
    {
        if (product.book != nil && product.book.book_id.integerValue != 0)
        {
            [reserveIds addObject:product.book.book_id];
        }
    }
    if (reserveIds.count != 0)
    {
        [params setObject:reserveIds forKey:@"reservation_ids"];
    }
    
    CGFloat arrearsAmount = 0.0;
    CGFloat cardSnapAmount = 0.0;
    NSMutableArray *statementIds = [NSMutableArray array];
    
    for (int i = 0; i < self.payments.count; i++)
    {
        NSMutableDictionary *dict = (NSMutableDictionary *)[self.payments objectAtIndex:i];
        NSObject *object = [dict objectForKey:@"mode"];
        CGFloat amount = [[dict objectForKey:@"amount"] floatValue];
        if ([object isKindOfClass:[NSString class]])
        {
            arrearsAmount = [[dict objectForKey:@"amount"] floatValue];
        }
        else if ([object isKindOfClass:[CDPOSPayMode class]])
        {
            CGFloat points = 0.0;
            CDPOSPayMode *paymode = (CDPOSPayMode *)object;
            if (paymode.mode.integerValue == kPadPayModeTypeCard)
            {
                cardSnapAmount = [[dict objectForKey:@"amount"] floatValue];
            }
            else if (paymode.mode.integerValue == kPadPayModeTypeCash)
            {
                if (self.remainMoney < 0) {
                    amount = amount + self.remainMoney;
                }
            }
            else if (paymode.mode.integerValue == kPadPayModeTypeCoupon)
            {
                NSMutableArray* tempArray = [NSMutableArray array];
                [couponCardsProductParams setObject:tempArray forKey:self.posOperate.couponCard.cardID];
                NSArray *array = @[@(0), @(NO), @{@"consume_money":@(amount), @"coupon_id":self.posOperate.couponCard.cardID,@"lines":tempArray}];
                [params setObject:@[array] forKey:@"coupon_ids"];
            }
            else if ( paymode.mode.integerValue == kPadPayModeTypePoint )
            {
                points = amount / self.posOperate.memberCard.priceList.points2Money.floatValue;
                NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"point":@(-points), @"journal_id":paymode.payID}];
                [statementIds addObject:array];
                continue;
            }
            else if ( paymode.mode.integerValue == kPadPayModeTypeBankCard )
            {
                NSString* serialNo = [dict objectForKey:@"bankNo"];
                serialNo = serialNo.length > 0 ? serialNo : @"";
                NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"bank_serial_number":serialNo,@"pos_type":[dict objectForKey:@"pos_type"], @"journal_id":paymode.payID}];
                [statementIds addObject:array];
                continue;
            }
            else if ( paymode.mode.integerValue == kPadPayModeTypeAlipay || paymode.mode.integerValue == kPadPayModeTypeWeChat )
            {
                NSString* record = [dict objectForKey:@"pos_type"];
                NSInteger r = [record integerValue];
                NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"pay_transaction_id":@(r), @"journal_id":paymode.payID}];
                [statementIds addObject:array];
                continue;
            }
            
            NSArray *array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"journal_id":paymode.payID}];
            [statementIds addObject:array];
        }
    }
    [params setObject:statementIds forKey:@"statement_ids"];
    [params setObject:@(arrearsAmount) forKey:@"now_arrears_amount"];
    
    NSMutableArray *productLineIds = [NSMutableArray array];
    NSMutableArray *consumeIds = [NSMutableArray array];
    for (int i = 0; i < self.posOperate.products.count; i++)
    {
        CDPosProduct *product = (CDPosProduct *)[self.posOperate.products objectAtIndex:i];
        NSArray *array = [NSArray array];
        if (cardSnapAmount > product.product_price.floatValue * product.product_qty.integerValue)
        {
            array = @[@(0), @(NO), @{@"product_id":product.product_id, @"price_unit":product.product_price, @"qty":product.product_qty, @"card_pay_amount":@(product.product_price.floatValue * product.product_qty.integerValue), @"is_deposit":@(NO)}];
            cardSnapAmount -= product.product_price.floatValue * product.product_qty.integerValue;
        }
        else
        {
            array = @[@(0), @(NO), @{@"product_id":product.product_id, @"price_unit":product.product_price, @"qty":product.product_qty, @"card_pay_amount":@(cardSnapAmount), @"is_deposit":@(NO)}];
            cardSnapAmount = 0;
        }
        [productLineIds addObject:array];
        
        if (product.product.bornCategory.integerValue == kPadBornCategoryProject)
        {
            NSArray *array = @[@(0), @(NO), @{@"product_id":product.product_id, @"lines_id":@(NO), @"consume_qty":product.product_qty, @"qty":@(0)}];
            [consumeIds addObject:array];
        }
    }
    
    for (int i = 0; i < self.posOperate.useItems.count; i++)
    {
        CDCurrentUseItem *useItem = [self.posOperate.useItems objectAtIndex:i];
        if (useItem.type.integerValue == kPadUseItemPurchasing || useItem.type.integerValue == kPadUseItemCurrentPurchase)
        {
            NSArray *array = @[@(0), @(NO), @{@"product_id":useItem.itemID, @"lines_id":@(NO), @"consume_qty":useItem.useCount, @"qty":useItem.useCount}];
            [consumeIds addObject:array];
        }
        else if (useItem.type.integerValue == kPadUseItemMemberCardProject)
        {
            NSArray *array = @[@(0), @(NO), @{@"product_id":useItem.itemID, @"lines_id":useItem.cardProject.productLineID, @"consume_qty":useItem.useCount, @"qty":useItem.useCount}];
            [consumeIds addObject:array];
        }
        else if (useItem.type.integerValue == kPadUseItemCouponCardProject)
        {
            NSArray *array = @[@(0), @(NO), @{@"product_id":useItem.itemID, @"coupon_lines_id":useItem.couponProject.productLineID, @"consume_qty":useItem.useCount, @"qty":useItem.useCount}];
            [consumeIds addObject:array];
            
            NSMutableArray* couponLines = couponCardsProductParams[self.posOperate.couponCard.cardID];
            if ( couponLines )
            {
                [couponLines addObject:@[@(0),@(FALSE),@{@"product_id":useItem.itemID, @"consume_qty":useItem.useCount,@"coupon_lines_id":useItem.couponProject.productLineID}]];
            }
            else
            {
                couponLines = [NSMutableArray array];
                [couponLines addObject:@[@(0),@(FALSE),@{@"product_id":useItem.itemID, @"consume_qty":useItem.useCount,@"coupon_lines_id":useItem.couponProject.productLineID}]];
                NSArray *array = @[@(0), @(NO),@{@"coupon_id":self.posOperate.couponCard.cardID,@"lines":couponLines}];
                [params setObject:@[array] forKey:@"coupon_ids"];
            }
        }
    }
    
    [params setObject:consumeIds forKey:@"consume_line_ids"];
    [params setObject:productLineIds forKey:@"product_line_ids"];
    if ( self.posOperate.occupy_restaurant_id )
    {
        [params setObject:self.posOperate.occupy_restaurant_id forKey:@"table_line_id"];
    }
    
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateCashier];
    [request execute];
    
    [[CBLoadingView shareLoadingView] show];

}

#pragma mark - PayModeDict params
- (NSArray *)paymentParamArray:(NSDictionary *)payDict
{
    NSArray *array;
    CDPOSPayMode *paymode = [payDict objectForKey:@"mode"];
    CGFloat amount = [[payDict objectForKey:@"amount"] floatValue];
    if ( paymode.mode.integerValue == kPadPayModeTypeBankCard )
    {
        NSString* serialNo = [payDict objectForKey:@"bankNo"];
        serialNo = serialNo.length > 0 ? serialNo : @"";
        array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID, @"bank_serial_number":serialNo,@"pos_type":[payDict objectForKey:@"pos_type"]}];
        
    }
    else
    {
        array = @[@(0), @(NO), @{@"amount":@(amount), @"statement_id":paymode.statementID}];
    }
    
    return array;
    
}

#pragma mark BNActionSheetDelegate Methods

- (void)bnActionSheet:(BNActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self refundCardRequest];
        }
            break;
            
        default:
            break;
    }
}

@end
