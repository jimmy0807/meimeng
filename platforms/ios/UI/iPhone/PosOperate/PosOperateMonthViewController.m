//
//  PosOperateMonthViewController.m
//  Boss
//
//  Created by lining on 16/9/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateMonthViewController.h"
#import "PosOperateMonthView.h"
#import "BSFetchPosOperateRequest.h"
#import "PosOperateDetailViewController.h"

@interface PosOperateMonthViewController ()<PosOperateViewDelegate>
@property (nonatomic,strong) PosOperateMonthView *operateMonthView;
@end

@implementation PosOperateMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.title = [NSString stringWithFormat:@"%d月份单据",self.income.month.integerValue];
    
    [self initView];
    
    [self registerNofitificationForMainThread:kFetchPosCardOperateResponse];
    [self registerNofitificationForMainThread:kFetchPosCommissionResponse];
    [self sendReqeust];
}

#pragma mark - init view
- (void)initView
{
    self.operateMonthView = [PosOperateMonthView createView];
    self.operateMonthView.delegate = self;
    self.operateMonthView.income = self.income;
    [self.operateMonthView reloadView];
    
    [self.view addSubview:self.operateMonthView];
    
    [self.operateMonthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
}


#pragma mark - send request
- (void)sendReqeust
{
    BSFetchPosOperateRequest *request = [[BSFetchPosOperateRequest alloc] init];
    NSString *month = [NSString stringWithFormat:@"%@-%02d",self.income.year,[self.income.month integerValue]];
    request.type = month;
    request.shopID = self.income.storeID;
    [request execute];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kFetchPosCardOperateResponse]) {
        [self.operateMonthView reloadView];
    }
    else if ([notification.name isEqualToString:kFetchPosCommissionResponse]) {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            [self.operateMonthView reloadView];
        }
    }
    
}


#pragma mark - PosOperateViewDelegate
- (void)didSelectedPosOperate:(CDPosOperate *)operate
{
    PosOperateDetailViewController *operateDetailVC = [[PosOperateDetailViewController alloc] init];
    operateDetailVC.operate = operate;
    [self.navigationController pushViewController:operateDetailVC animated:YES];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
