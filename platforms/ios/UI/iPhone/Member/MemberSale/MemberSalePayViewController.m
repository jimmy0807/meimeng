//
//  MemberSalePayViewController.m
//  Boss
//
//  Created by lining on 16/8/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberSalePayViewController.h"
#import "NSDate+Formatter.h"
#import "MemberCardShopCartViewController.h"
#import "InputDiscountViewController.h"
#import "MemberCardPayModeViewController.h"


@interface MemberSalePayViewController ()<InputDiscountViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *discountLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIButton *payBtn;

@property (nonatomic, strong) CDPosOperate *operate;
@property (assign, nonatomic) CGFloat discount;

@end

@implementation MemberSalePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = LS(@"结算");
    
    self.discount = 10.0f;
    
    
    self.dateLabel.text = [[NSDate date] dateStringWithFormatter:@"yyyy-MM-dd HH:mm"];
    [self reloadSubViews];
    
    [self registerNofitificationForMainThread:kShopCartDataChanged];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadSubViews];
}

- (void)reloadSubViews
{
    self.operate  = self.operateManager.posOperate;
    NSInteger num = self.operate.products.count + self.operate.useItems.count;
    
    self.operate.amount = @(self.operate.amount.floatValue * self.discount / 10.0f);
    self.detailLabel.text = [NSString stringWithFormat:@"共%d件商品,总价￥%.2f",num,self.operate.amount.floatValue];
    
    if (fabs(self.discount - 10.0) < 0.01) {
        self.discountLabel.text = @"全额";
    }
    else
    {
        self.discountLabel.text = [NSString stringWithFormat:@"%.2f折",self.discount];
    }
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.operate.amount.floatValue];
    if (num == 0) {
        self.payBtn.enabled = false;
    }
    else
    {
        self.payBtn.enabled = true;
    }
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [self.operateManager reloadPosOperate];
    [self reloadSubViews];
}

#pragma mark - button action
- (IBAction)detailBtnPressed:(id)sender {
    MemberCardShopCartViewController *shopCartVC = [[MemberCardShopCartViewController alloc] init];
    shopCartVC.operateManager = self.operateManager;
    [self.navigationController pushViewController:shopCartVC animated:YES];
}

- (IBAction)discountBtnPressed:(id)sender {
    InputDiscountViewController *inputDiscountVC = [[InputDiscountViewController alloc] init];
    inputDiscountVC.delegate = self;
    [self.navigationController pushViewController:inputDiscountVC animated:YES];
}

- (IBAction)payBtnPressed:(id)sender {
    MemberCardPayModeViewController *payModeVC = [[MemberCardPayModeViewController alloc] init];
    payModeVC.operateType = kPadMemberCardOperateCashier;
    payModeVC.posOperate = self.operateManager.posOperate;
    [self.navigationController pushViewController:payModeVC animated:YES];
}

#pragma mark - InputDiscountViewControllerDelegate
- (void) inputDiscountDone:(CGFloat)discount
{
    self.discount = discount;
    [self reloadSubViews];
}


#pragma mark - 


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
