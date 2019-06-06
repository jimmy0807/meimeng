//
//  PurchaseViewController.m
//  Boss
//
//  Created by lining on 15/6/15.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "PurchaseViewController.h"
#import "BSFetchPurchaseOrderRequest.h"
#import "PurchaseOrderViewController.h"

#define kCellHeight  60
#define kMarginSize  20


@interface PurchaseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isFirstLoadView;
}
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *allOrders;                //全部订单
@property(nonatomic, strong) NSArray *approvedOrders;           //待入库
@property(nonatomic, strong) NSArray *confimedOrders;           //待审核
@property(nonatomic, strong) NSArray *draftOrders;              //草稿
@property(nonatomic, strong) NSArray *doneOrders;               //已完成

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"采购";
    isFirstLoadView = true;
    
    [self registerNofitificationForMainThread:kBSFetchOrderResponse];
    [self registerNofitificationForMainThread:kBSCreatePurchaseOrderResponse];
    [self initData];
    BSFetchPurchaseOrderRequest *req = [[BSFetchPurchaseOrderRequest alloc] init];
    [req execute];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isFirstLoadView) {
        
        [self initView];
        isFirstLoadView = false;
    }
    
    
}

#pragma mark - init view & data
- (void)initView
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
    
    self.allOrders = [dataManager fetchPurchaseOrdersWithState:nil];
    self.approvedOrders = [dataManager fetchPurchaseOrdersWithState:@"approved"];
    self.confimedOrders = [dataManager fetchPurchaseOrdersWithState:@"confirmed"];
    self.draftOrders = [dataManager fetchPurchaseOrdersWithState:@"draft"];
    self.doneOrders = [dataManager fetchPurchaseOrdersWithState:@"done"];
}


#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Received Notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchOrderResponse]) {
        [self initData];
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"indentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_n"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_item_cell_h"]];
        
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0, IC_SCREEN_WIDTH, 0.5)];
        topLine.backgroundColor = [UIColor clearColor];
        topLine.tag = 100;
        topLine.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [cell.contentView addSubview:topLine];
        
        UIImage *arrowImage = [UIImage imageNamed:@"project_item_arrow"];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, kCellHeight/2.0 - 20.0 + 2.0, self.tableView.frame.size.width - 15 - arrowImage.size.width, 20.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.tag = 101;
        titleLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        [cell.contentView addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, kCellHeight/2.0 + 2.0, titleLabel.frame.size.width, 20.0)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:13.0];
        detailLabel.tag = 102;
        detailLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        [cell.contentView addSubview:detailLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 15 - arrowImage.size.width, (kCellHeight - arrowImage.size.height)/2.0, arrowImage.size.width, arrowImage.size.height)];
        arrowImageView.backgroundColor = [UIColor clearColor];
        arrowImageView.image = arrowImage;
        [cell.contentView addSubview:arrowImageView];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kCellHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [cell.contentView addSubview:lineImageView];
    }
    
    UIImageView *topLine = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:102];
    topLine.hidden = YES;
    titleLabel.text = @"采购订单";
//    detailLabel.text = @"已批准: 3个 已提交: 1个";
    detailLabel.text = [NSString stringWithFormat:@"草稿:%d个 待审核:%d个 待入库:%d个",self.draftOrders.count,self.confimedOrders.count,self.approvedOrders.count];
    if (indexPath.row == 0) {
        topLine.hidden = NO;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    return kSearchBarHeight;
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PurchaseOrderViewController *orderVC = [[PurchaseOrderViewController alloc] init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

@end
