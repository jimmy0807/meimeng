//
//  MemberCardRecedeViewController.m
//  Boss
//  退卡
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardRecedeViewController.h"
#import "MemberCardPayModeViewController.h"

@interface MemberCardRecedeViewController ()
@property (nonatomic, assign) CGFloat refundMoney;
@property (nonatomic, assign) BOOL refundCard;
@end

@implementation MemberCardRecedeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hideKeyBoardWhenClickEmpty = true;
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"退款(卡)";
    self.noLabel.text = self.card.cardNo;
    self.typeLabel.text = self.card.priceList.name;
    self.amountLabel.text = [NSString stringWithFormat:@"余额：￥%.2f",self.card.amount.floatValue];
    
    self.amountField.delegate = self;
    self.amountField.keyboardType = UIKeyboardTypeDecimalPad;
    self.amountField.text = [NSString stringWithFormat:@"%.2f",self.card.amount.floatValue];
    
    self.sureBtn.enabled = true;
}


#pragma makr - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - button action
- (IBAction)checkBoxBtnPressed:(id)sender {
    self.checkBoxImg.highlighted = !self.checkBoxImg.highlighted;
    
    self.refundCard = self.checkBoxImg.highlighted;
    
}

- (IBAction)sureBtnPressed:(id)sender {
    MemberCardPayModeViewController *payModeVC = [[MemberCardPayModeViewController alloc] init];
    payModeVC.card = self.card;
    payModeVC.expectMoney = self.card.amount.floatValue;
    payModeVC.refundCard = self.refundCard;
    payModeVC.operateType = kPadMemberCardOperateRefund;
    [self.navigationController pushViewController:payModeVC animated:YES];
}



#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.refundMoney = textField.text.floatValue;
    textField.text = [NSString stringWithFormat:@"%.2f",self.refundMoney];
    if (self.refundMoney - 0.01 < 0) {
        self.sureBtn.enabled = false;
    }
    else
    {
        self.sureBtn.enabled = true;
    }
}

@end
