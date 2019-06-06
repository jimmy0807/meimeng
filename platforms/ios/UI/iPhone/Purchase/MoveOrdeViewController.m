//
//  PuchaseOrderMoveViewController.m
//  Boss
//  带移动的订单
//  Created by lining on 15/7/20.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "MoveOrdeViewController.h"
#import "OrderCell.h"
#import "BSFetchMoveOrderRequest.h"
#import "CBLoadingView.h"
#import "MoveItemViewController.h"
#import "BSHandlePurchaseOrderRequest.h"

@interface MoveOrdeViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL isFistLoadView;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;
@end

@implementation MoveOrdeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"入库";
    
    isFistLoadView = true;
    [self initData];
    
    [self registerNofitificationForMainThread:kBSFetchMoveOrderResponse];
//    [[[BSHandlePurchaseOrderRequest alloc] initWithPurchaseOrder:self.purchaseOrder type:HandleType_input] execute];
    [[[BSFetchMoveOrderRequest alloc] initWithPurchaseOrder:self.purchaseOrder] execute];
   
    [[CBLoadingView shareLoadingView] show];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isFistLoadView) {
        [self initView];
        
        isFistLoadView = false;
    }
}
#pragma mark - init View & Data
- (void) initView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //    self.tableView.bounces = false;
    self.tableView.autoresizingMask = 0xff;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void) initData
{
    BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
    self.dataArray = [dataManager fetchPurchaseMoveOrdersWithOrigin:self.purchaseOrder.name];
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"cell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithWidth:self.tableView.frame.size.width type:CellType_confirmed reuseIdentifier:indentifier];
    }
    
    CDPurchaseOrderMove *moveOrder = [self.dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = moveOrder.name;
    cell.detailLabel.text = [NSString stringWithFormat:@"源单据: %@",moveOrder.origin];
    cell.rateLabel.hidden = YES;
    if ([moveOrder.state isEqualToString:@"done"]) {
        cell.arrowImageView.image = [UIImage imageNamed:@"order_input_done.png"];
    }
    else
    {
        cell.arrowImageView.image = [UIImage imageNamed:@"order_input_wait.png"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    return kSearchBarHeight;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDPurchaseOrderMove *moveOrder = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([moveOrder.state isEqualToString:@"done"]) {
        return;
    }
    
    [[[BSHandlePurchaseOrderRequest alloc] initWithID:moveOrder.move_id type:HandleType_translate] execute];
    [[CBLoadingView shareLoadingView] show];
    
    MoveItemViewController *moveProductVC = [[MoveItemViewController alloc] initWithNibName:NIBCT(@"MoveItemViewController") bundle:nil];
    moveProductVC.moveOrder = moveOrder;
    [self.navigationController pushViewController:moveProductVC animated:YES];
    NSLog(@"%d",indexPath.row);
}

#pragma mark - ReceivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMoveOrderResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        NSDictionary *retDict = notification.userInfo;
        if ([[retDict numberValueForKey:@"rc"] integerValue] == 0) {
            [self initData];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
