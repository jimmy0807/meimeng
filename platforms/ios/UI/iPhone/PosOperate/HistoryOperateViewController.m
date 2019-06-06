//
//  HistoryOperateViewController.m
//  Boss
//
//  Created by lining on 16/8/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "HistoryOperateViewController.h"
#import "PosOperateDayView.h"
#import "PosOperateWeekView.h"
#import "PosOperateMonthView.h"
#import "PosOperateMonthIncomeView.h"
#import "BSFetchPosOperateRequest.h"
#import "BSFetchPosMonthIncomeRequest.h"
#import "PosOperateMonthViewController.h"
#import "PosOperateDetailViewController.h"


typedef enum OperateType
{
    OperateType_Today,
    OperateType_Week,
    OperateType_Month
}OperateType;



@interface HistoryOperateViewController ()<PosOperateMonthIncomeViewDelegate,PosOperateViewDelegate>
{
    NSInteger requestCount;
}
@property(nonatomic, strong) IndicatorCollectionTableView *indicatorCollectView;

@property(nonatomic, assign) OperateType type;
@property(nonatomic, assign) NSString *monthString;
@property(nonatomic, strong) NSArray *operateArray;
@property(nonatomic, strong) NSArray *dataSouces;
@end

@implementation HistoryOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.title = @"历史单据";
    
    [self initView];
    
    [self registerNofitificationForMainThread:kFetchPosCardOperateResponse];
    [self registerNofitificationForMainThread:kFetchPosMonthIncomeResponse];
    [self registerNofitificationForMainThread:kFetchPosCommissionResponse];
    
    [self sendRequest];
}


#pragma mark - initView
- (void) initView
{
    PosOperateDayView *dayView = [PosOperateDayView createView];
    dayView.delegate = self;
    
    PosOperateWeekView *weekView = [PosOperateWeekView createView];
    weekView.delegate = self;
    
    PosOperateMonthIncomeView *monthIncomeView = [PosOperateMonthIncomeView createView];
    monthIncomeView.delegate = self;
    
    self.indicatorCollectView = [[IndicatorCollectionTableView alloc]    initWithTitles:@[@"今日",@"七日",@"每月"]];
    self.indicatorCollectView.indicatorViews = @[dayView,weekView,monthIncomeView];
    
    self.indicatorCollectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.indicatorCollectView];
    self.indicatorCollectView.scrollView.backgroundColor = AppThemeColor;
    [self.indicatorCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    [self.indicatorCollectView reloadSubViews];
}

#pragma mark - send request
- (void)sendRequest
{
    BSFetchPosOperateRequest* request = [[BSFetchPosOperateRequest alloc] init];
    //日
    request.type = @"day";
    [request execute];
    requestCount++;

    //周
    BSFetchPosOperateRequest* request1 = [[BSFetchPosOperateRequest alloc] init];
    request1.type = @"week";
    [request1 execute];
    requestCount++;
    
    BSFetchPosMonthIncomeRequest* monthIncomeRequest = [[BSFetchPosMonthIncomeRequest alloc] init];
    [monthIncomeRequest execute];
    requestCount++;
    
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kFetchPosCommissionResponse]) {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            [self.indicatorCollectView reloadData];
        }
    }
    else
    {
        requestCount--;
        if (requestCount == 0) {
            [self.indicatorCollectView reloadData];
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

#pragma mark - PosOperateMonthIncomeViewDelegate
- (void)didSelectedMonthIncome:(CDPosMonthIncome *)monthIncome
{
    PosOperateMonthViewController *operateMonthVC = [[PosOperateMonthViewController alloc] init];
    operateMonthVC.income = monthIncome;
    [self.navigationController pushViewController:operateMonthVC animated:YES];
}

#pragma makr - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
