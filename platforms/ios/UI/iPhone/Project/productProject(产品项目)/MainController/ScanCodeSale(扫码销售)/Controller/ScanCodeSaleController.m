//
//  ScanCodeSaleController.m
//  Boss
//
//  Created by jiangfei on 16/7/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ScanCodeSaleController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanQRCodeView.h"
#import "BottomPayView.h"
#import "ShopCartDataSource.h"
#import "EditShopCartViewController.h"
#import "OperateManager.h"
#import "MemberCardPayModeViewController.h"
#import "CBMessageView.h"
#import "MemberCardShopCartViewController.h"
#import "MemberSalePayViewController.h"

@interface ScanCodeSaleController ()<ScanQRCodeViewDelegate,ShopCartDataSouceDelegate,BottomPayViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *sureLabel;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) ScanQRCodeView *scanView;
@property (strong, nonatomic) BottomPayView *bottomPayView;
@property (strong, nonatomic) ShopCartDataSource *dataSouce;
@property (strong, nonatomic) NSString *code;

@end


@implementation ScanCodeSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sureLabel.layer.cornerRadius = 6.0;
    self.sureLabel.clipsToBounds = YES;
    
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.title = @"扫码销售";
    
//    NSLog(@"frame: %@",NSStringFromCGRect(self.codeView.frame));
    
    self.scanView = [[ScanQRCodeView alloc] initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, 150) delegate:self];
    [self.codeView addSubview:self.scanView];
    [self.scanView startScan];

    
    self.bottomPayView = [[[NSBundle mainBundle] loadNibNamed:@"BottomPayView" owner:self options:nil] lastObject];
    self.bottomPayView.delegate = self;
    self.bottomPayView.operate = [OperateManager shareManager].posOperate;
    [self.bottomView addSubview:self.bottomPayView];
    [self.bottomPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    self.dataSouce = [[ShopCartDataSource alloc] initWithTableView:self.tableView delegate:self];
    
    [self registerNofitificationForMainThread:kShopCartDataChanged];
    
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.hideKeyBoardWhenClickEmpty = true;
    
    [self registerNofitificationForMainThread:UIApplicationDidBecomeActiveNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [self.scanView stopScan];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:UIApplicationDidBecomeActiveNotification]) {
//        [self.scanView startScan];
    }
    else
    {
        self.bottomPayView.operate = [OperateManager shareManager].posOperate;
    }
}


#pragma mark - BottomPayViewDelegate
- (void)didGuaDanOperate:(CDPosOperate *)operate
{
    NSLog(@"挂单");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入手牌号(可不填写)" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
//    [[OperateManager shareManager] guaDan];
}

- (void)didPayOperate:(CDPosOperate *)operate
{
    NSLog(@"结算");
//    MemberCardPayModeViewController *payModeVC = [[MemberCardPayModeViewController alloc] init];
//    payModeVC.operateType = kPadMemberCardOperateCashier;
//    payModeVC.posOperate = [OperateManager shareManager].posOperate;
//    [self.navigationController pushViewController:payModeVC animated:YES];
    
    MemberSalePayViewController *memberSalePayVC = [[MemberSalePayViewController alloc] init];
    memberSalePayVC.operateManager = [OperateManager shareManager];
    [self.navigationController pushViewController:memberSalePayVC animated:YES];
    

}

- (void)didShopCartOperate:(CDPosOperate *)operate
{
    NSLog(@"---");
    MemberCardShopCartViewController *shopCartVC = [[MemberCardShopCartViewController alloc] init];
    shopCartVC.operateManager = [OperateManager shareManager];
    [self.navigationController pushViewController:shopCartVC animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    //    NSLog(@"text: %@ - idx: %d",[alertView textFieldAtIndex:0].text,buttonIndex);
    [OperateManager shareManager].posOperate.handno = [alertView textFieldAtIndex:0].text;
    
    NSLog(@"挂单");
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[OperateManager shareManager] guaDan];
}


#pragma mark - ScanQRCodeViewDelegate
- (void)didFinishScanWithResult:(NSString *)result
{
    self.code = result;
    [self addProjectItemToCart];
}

- (void)addProjectItemToCart
{
    if (self.code.length == 0) {
        CBMessageView *messgeView = [[CBMessageView alloc] initWithTitle:@"请输入二维码"];
        [messgeView show];
        return;
    }
    CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:self.code forKey:@"defaultCode"];
    if (!item) {
        item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:self.code forKey:@"barcode"];
    }
    
    if (item == nil) {
        NSLog(@"不存在");
    }
    else
    {
        [[OperateManager shareManager] addObject:item];
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:kShopCartDataChanged object:nil];
    }

}

//#pragma mark - UITextFieldDelegate
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self addProjectItemToCart];
//}

#pragma mark - ShopCartDataSouceDelegate 
- (void)didSelectedPosproduct:(CDPosProduct *)product
{
    EditShopCartViewController *editCartVC = [[EditShopCartViewController alloc] init];
    editCartVC.member = [OperateManager shareManager].posOperate.member;
    editCartVC.product = product;
    [self.navigationController pushViewController:editCartVC animated:YES];
}

- (void)didSelectedUseItem:(CDCurrentUseItem *)useItem
{
    EditShopCartViewController *editCartVC = [[EditShopCartViewController alloc] init];
    editCartVC.member = [OperateManager shareManager].posOperate.member;
    editCartVC.useItem = useItem;
    [self.navigationController pushViewController:editCartVC animated:YES];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    textField.resignFirstResponder
    self.code = textField.text;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

#pragma mark - button action


#pragma mark - 二维码图标被点击
- (IBAction)codeBtnClick:(UIButton *)sender {
    NSLog(@"二维码图标被点击");
}

#pragma mark 确定按钮被点击
- (IBAction)sureBtnClick:(UIButton *)sender {
    NSLog(@"确定按钮被点击");
    [self.textField resignFirstResponder];
    self.code = self.textField.text;
    [self addProjectItemToCart];
}



@end
