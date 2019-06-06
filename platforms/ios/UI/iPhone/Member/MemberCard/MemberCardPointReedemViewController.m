//
//  MemberCardPointReedemViewController.m
//  Boss
//
//  Created by lining on 16/6/21.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardPointReedemViewController.h"
#import "BSMemberCardRedeemRequest.h"
#import "ShopProductController.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "ProductProjectMainController.h"

@interface MemberCardPointReedemViewController ()<ShopProductControllerDelegate>
@property (nonatomic, assign) CGFloat point;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) CDProjectItem *reedemItem;
@end

@implementation MemberCardPointReedemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    self.title = @"积分兑换";
    
    self.hideKeyBoardWhenClickEmpty = true;
    
    self.cardNoLabel.text = self.card.cardNo;
    self.cardTypeLabel.text = self.card.priceList.name;
    self.pointLabel.text = [NSString stringWithFormat:@"总积分：%.2f",self.card.points.floatValue];
    self.pointTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.markTextField.returnKeyType = UIReturnKeyDone;
    
    self.pointTextField.tag = 101;
    self.markTextField.tag = 102;
    
    self.pointTextField.delegate = self;
    self.markTextField.delegate = self;
    
    self.sureBtn.enabled = false;
    [self registerNofitificationForMainThread:kBSMemberCardRedeemResponse];
    [self registerNofitificationForMainThread:kBSPointItemSelectFinish];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSMemberCardRedeemResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] == 0)
        {
            [[[CBMessageView alloc] initWithTitle:@"积分兑换成功"] show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
    else if ([notification.name isEqualToString:kBSPointItemSelectFinish])
    {
        self.reedemItem = notification.object;
        self.productNameLabel.text = self.reedemItem.itemName;
    }
}

#pragma mark - btn action
- (IBAction)sureBtnPressed:(id)sender {
    if (self.reedemItem == nil) {
        [[[CBMessageView alloc] initWithTitle:@"请选择兑换的商品"] show];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.card.cardID forKey:@"card_id"];
    [params setObject:@(-self.point) forKey:@"exchange_point"];
    if (self.remark.length != 0)
    {
        [params setObject:self.remark forKey:@"remark"];
    }
    
    if (self.reedemItem)
    {
        [params setObject:self.reedemItem.itemID forKey:@"product_id"];
    }
    
    [[CBLoadingView shareLoadingView] show];
    BSMemberCardRedeemRequest *request = [[BSMemberCardRedeemRequest alloc] initWithParams:params];
    [request execute];
}

- (IBAction)selectedProductBtnPressed:(id)sender {
    NSLog(@"----");
    ProductProjectMainController *productVC = [[ProductProjectMainController alloc] init];
   
    productVC.controllerType = ProductControllerType_Point;
    [self.navigationController pushViewController:productVC animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return;
    }
    if (textField.tag == 101) {
        textField.text = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
        self.point = textField.text.floatValue;
        self.sureBtn.enabled = true;
    }
    else
    {
        self.remark = textField.text;
    }
}

#pragma mark - ShopProductControllerDelegate
-(void)didSelectedProjectItem:(CDProjectItem*)item
{
    self.reedemItem = item;
    self.productNameLabel.text = self.reedemItem.itemName;
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
