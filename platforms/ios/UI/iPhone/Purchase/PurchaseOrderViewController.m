//
//  PurchaseOrderViewController.m
//  Boss
//
//  Created by lining on 15/6/15.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "PurchaseOrderViewController.h"
#import "CBSegmentControl.h"
#import "UIImage+Resizable.h"
#import "CreatePurchaseOrderViewController.h"
#import "OrderExpandCell.h"
#import "OrderProductCell.h"
#import "ApproveDetailViewController.h"
#import "BSHandlePurchaseOrderRequest.h"
#import "BSFetchOrderLinesRequest.h"
#import "CBMessageView.h"
#import "BSFetchPurchaseOrderRequest.h"
#import "CBLoadingView.h"
#import "OrderCell.h"
#import "MoveItemViewController.h"
#import "MoveOrdeViewController.h"
#import "BSFetchPurchaseTaxRequest.h"
#import "CBRefreshView.h"
#import "OrderInputCell.h"
#import "OrderApprovedCell.h"

#define kCellHeight         60
#define kExpandHeight       60
#define kMarginSize         20
#define kTableHeadHeight    68
#define kProductCellHeight  90

#define ORDER_COUNT    10

typedef enum kOrderTag
{
    kOrderTag_draft,            //草稿
    kOrderTag_confirmed,        //待审核
    kOrderTag_approved,         //待入库
    kOrderTag_done,             //已完成
}kOrderTag;


@interface PurchaseOrderViewController ()<UITableViewDataSource, UITableViewDelegate,CBSegmentControlDelegate,OrderExpandCellDelegate,CBRefreshDelegate>
{
    BOOL isFistLoadView;
    NSInteger currentSelectedRow; //当前选中的一行
    
    BOOL isLoading;
    CBRefreshState refreshState;
}

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *allOrders;            //全部订单
@property(nonatomic, strong) NSArray *approvedOrders;       //待入库
@property(nonatomic, strong) NSArray *confirmedOrders;      //已提交
@property(nonatomic, strong) NSArray *draftOrders;          //草稿
@property(nonatomic, strong) NSArray *doneOrders;           //已取消
@property(nonatomic, assign) kOrderTag orderTag;
@property(nonatomic, strong) NSArray *dataArray;
@end

@implementation PurchaseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"采购";
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n"] highlightedImage:[UIImage imageNamed:@"navi_add_h"]];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self registerNofitificationForMainThread:kBSFetchOrderResponse];
    [self registerNofitificationForMainThread:kBSCreatePurchaseOrderResponse];
    [self registerNofitificationForMainThread:kBSCommitPurchaseOrderResponse];
    [self registerNofitificationForMainThread:kBSEditPurchaseOrderResponse];
    [self registerNofitificationForMainThread:kBSMoveDoneReponse];
    [self registerNofitificationForMainThread:kBSCancelPurchaseOrderResponse];
    [self registerNofitificationForMainThread:kBSConfirmedPurchaseOrderResponse];
    [self registerNofitificationForMainThread:kBSDeletePurchaseOrderResponse];
    
     currentSelectedRow = -1;

    //拿税率req
    [[[BSFetchPurchaseTaxRequest alloc] init] execute];
    
    self.orderTag = kOrderTag_draft;
    [self initData];
    [self fetchOrdersWithStartIndex:0];
    
    isFistLoadView = true;
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
    self.tableView.tableHeaderView = [self segmentControlView];
    self.tableView.refreshDelegate = self;
    self.tableView.canLoadMore = true;
    [self.view addSubview:self.tableView];
    
    isLoading = NO;
    refreshState = CBRefreshStateRefresh;
}

- (void) initData
{
    BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];

    NSString *state = [self orderState];
    self.dataArray = [dataManager fetchPurchaseOrdersWithState:state];
}

- (NSString *)orderState
{
    NSString *state;
    if (self.orderTag == kOrderTag_confirmed) {
       state = @"confirmed";
    }
    else if (self.orderTag == kOrderTag_done)
    {
        state = @"done";
    }
    else if (self.orderTag == kOrderTag_approved)
    {
        state = @"approved";
    }
    else if (self.orderTag == kOrderTag_draft)
    {
        state = @"draft";
    }
    return state;
}



- (UIView *)segmentControlView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, kTableHeadHeight)];
    view.autoresizingMask = 0xff;
    
    CBSegmentControl *segmentControl = [[CBSegmentControl alloc] initWithFrame:CGRectMake(kMarginSize/2.0, (kTableHeadHeight - 29)/2.0, view.frame.size.width - kMarginSize, 29) titles:@[@"草稿",@"待审核",@"待入库",@"已入库"]];
    segmentControl.delegate = self;
    segmentControl.autoresizingMask = 0xff;
    segmentControl.selectedIdx = self.orderTag;
    [view addSubview:segmentControl];

    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kTableHeadHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [view addSubview:lineImageView];
    return view;
}
#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Request
-(void) fetchOrdersWithStartIndex:(NSInteger)startIndex
{
    if (!isLoading) {
        NSString *state = [self orderState];
        //    [[CBLoadingView shareLoadingView] show];
        BSFetchPurchaseOrderRequest *req = [[BSFetchPurchaseOrderRequest alloc] initWithStartIndex:startIndex state:state];
        [req execute];
        isLoading = YES;
    }
   
}

#pragma mark - ReceivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchOrderResponse]) {
        isLoading = NO;
        [self.tableView stopWithRefreshState:refreshState];
        [self reloadTableView];
    }
    
    else if ([notification.name isEqualToString:kBSCreatePurchaseOrderResponse] || [notification.name isEqualToString:kBSConfirmedPurchaseOrderResponse] || [notification.name isEqualToString:kBSCancelPurchaseOrderResponse]||[notification.name isEqualToString:kBSCommitPurchaseOrderResponse] || [notification.name isEqualToString:kBSDeletePurchaseOrderResponse] || [notification.name isEqualToString:kBSMoveDoneReponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            currentSelectedRow = -1;
            [self fetchOrdersWithStartIndex:0];
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]];
            [messageView show];
        }
    }
}


#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    NSLog(@"right button pressed");
    CreatePurchaseOrderViewController *createPurchaseVC = [[CreatePurchaseOrderViewController alloc] initWithNibName:NIBCT(@"CreatePurchaseOrderViewController") bundle:nil];
    createPurchaseVC.type = OrderType_create;
    [self.navigationController pushViewController:createPurchaseVC animated:YES];
}

#pragma mark -
#pragma mark CBSegmentControlDelegate
-(void)didSegmentCotrolSelectedAtIndex:(NSInteger)index
{
    NSLog(@"segment selected at index: %d",index);
    self.orderTag = index;
    
    [self fetchOrdersWithStartIndex:0];
    [self reloadTableView];
}


#pragma mark - reload TableView

-(void)reloadTableView
{
    NSLog(@"relodTableView");
    [self initData];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderTag == kOrderTag_done) {
        return [self doneCell:tableView indexPath:indexPath];
    }
    else if (self.orderTag == kOrderTag_confirmed)
    {
        return [self confirmedCell:tableView indexPath:indexPath];
    }
    else if (self.orderTag == kOrderTag_approved)
    {
        return [self approvedCell:tableView indexPath:indexPath];
    }
    else if (self.orderTag == kOrderTag_draft)
    {
        return [self draftCell:tableView indexPath:indexPath];
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderTag == kOrderTag_draft) {
        return true;
    }
    return false;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除");
        
        NSLog(@"didDelBtnPressed at indexPath: %@",indexPath);
//        CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:@"此权限暂未开通"];
//        [msgView show];
            CDPurchaseOrder *order = [self.dataArray objectAtIndex:indexPath.row];
        BSHandlePurchaseOrderRequest *request = [[BSHandlePurchaseOrderRequest alloc] initWithPurchaseOrder:order type:HandleType_delete];
        
        [request execute];
        
        
    }
}


#pragma mark - tableViewCell with tag

//草稿
-(UITableViewCell *) draftCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"draft_cell";
    OrderExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[OrderExpandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier width:self.tableView.frame.size.width canExpand:false];
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
    if (currentSelectedRow == indexPath.row) {
        cell.isExpand = true;
    }
    else
    {
        cell.isExpand = false;
    }
    CDPurchaseOrder *purchaseOrder = [self.dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = purchaseOrder.name;
    cell.dateLabel.text = [NSString stringWithFormat:@"订单日期: %@",[purchaseOrder.date_order substringToIndex:10]];
    cell.amountLabel.text = [NSString stringWithFormat:@"共计: ￥%@",purchaseOrder.amount_total];
    cell.providerLabel.text = [NSString stringWithFormat:@"供应商: %@",purchaseOrder.provider.name];
    return cell;

}

//待入库
-(UITableViewCell *) approvedCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"approve_cell";
    OrderApprovedCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
//        cell = [[OrderExpandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier width:self.tableView.frame.size.width canExpand:false];
        cell = [[OrderApprovedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier width:self.tableView.frame.size.width];
    }
    
    CDPurchaseOrder *purchaseOrder = [self.dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = purchaseOrder.name;
    cell.dateLabel.text = [NSString stringWithFormat:@"订单日期: %@",[purchaseOrder.date_order substringToIndex:10]];
   
    cell.amountLabel.text = [NSString stringWithFormat:@"共计: ￥%@",purchaseOrder.amount_total];
    cell.rateLabel.text = [NSString stringWithFormat:@"%.0f%%",[purchaseOrder.shipped_rate floatValue]];
    cell.providerLabel.text = [NSString stringWithFormat:@"供应商: %@",purchaseOrder.provider.name];
    return cell;
}

//待审核
-(UITableViewCell *) confirmedCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"confirmed_cell";
    OrderExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[OrderExpandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier width:self.tableView.frame.size.width canExpand:false];
//        cell = [[OrderCell alloc] initWithWidth:self.tableView.frame.size.width type:CellType_confirmed reuseIdentifier:indentifier];
    }
    
    CDPurchaseOrder *purchaseOrder = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = purchaseOrder.name;
    cell.dateLabel.text = [NSString stringWithFormat:@"订单日期: %@",[purchaseOrder.date_order substringToIndex:10]];
    cell.amountLabel.text = [NSString stringWithFormat:@"共计: ￥%@",purchaseOrder.amount_total];
    cell.providerLabel.text = [NSString stringWithFormat:@"供应商: %@",purchaseOrder.provider.name];
    return cell;
}

//已入库
-(UITableViewCell *) doneCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"input_cell";
    OrderInputCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[OrderInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier width:self.tableView.frame.size.width];
    }
    
    CDPurchaseOrder *purchaseOrder = [self.dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = purchaseOrder.name;
    cell.dateLabel.text = [NSString stringWithFormat:@"订单日期: %@",[purchaseOrder.date_order substringToIndex:10]];
    cell.amountLabel.text = [NSString stringWithFormat:@"共计: ￥%@",purchaseOrder.amount_total];
    cell.providerLabel.text = [NSString stringWithFormat:@"供应商: %@",purchaseOrder.provider.name];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderTag == kOrderTag_confirmed) {
        return 80;
    }
    else if (self.orderTag == kOrderTag_done)
    {
        return [OrderInputCell cellHeight];
    }
    else if (self.orderTag == kOrderTag_approved)
    {
        return [OrderApprovedCell cellHeight];
    }
    else if (self.orderTag == kOrderTag_draft)
    {
//        if (indexPath.row == currentSelectedRow)
//        {
//            return kCellHeight + kExpandHeight;
//        }
//        else
//        {
//            return kCellHeight;
//        }
        return 80;
    }
    
    return 0;
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.orderTag == kOrderTag_confirmed) {
//        CDPurchaseOrder *purchaseOrder = [self.confirmedOrders objectAtIndex:indexPath.row];
//        ApproveDetailViewController *detailVC = [[ApproveDetailViewController alloc] initWithNibName:NIBCT(@"ApproveDetailViewController") bundle:nil];
//        detailVC.purchaseOrder = purchaseOrder;
//        [self.navigationController pushViewController:detailVC animated:YES];
        NSLog(@"didEditBtnPressed at indexPath: %@",indexPath);
        CDPurchaseOrder *order = [self.dataArray objectAtIndex:indexPath.row];
        
        CreatePurchaseOrderViewController *purchaseOrderVC = [[CreatePurchaseOrderViewController alloc] initWithNibName:NIBCT(@"CreatePurchaseOrderViewController") bundle:nil];
        purchaseOrderVC.type = OrderType_confirm;
        purchaseOrderVC.purchaseOrder = order;
        [self.navigationController pushViewController:purchaseOrderVC animated:YES];
    }
    else if (self.orderTag == kOrderTag_done)
    {
        NSLog(@"完成");
//        CDPurchaseOrder *purchaseOrder = [self.doneOrders objectAtIndex:indexPath.row];
//        ApproveDetailViewController *detailVC = [[ApproveDetailViewController alloc] initWithNibName:NIBCT(@"ApproveDetailViewController") bundle:nil];
//        detailVC.type = kType_done;
//        detailVC.purchaseOrder = purchaseOrder;
//        [self.navigationController pushViewController:detailVC animated:YES];
        
        NSLog(@"didEditBtnPressed at indexPath: %@",indexPath);
        CDPurchaseOrder *order = [self.dataArray objectAtIndex:indexPath.row];
        
        CreatePurchaseOrderViewController *purchaseOrderVC = [[CreatePurchaseOrderViewController alloc] initWithNibName:NIBCT(@"CreatePurchaseOrderViewController") bundle:nil];
        purchaseOrderVC.type = OrderType_done;
        purchaseOrderVC.purchaseOrder = order;
        [self.navigationController pushViewController:purchaseOrderVC animated:YES];
    }
    else if (self.orderTag == kOrderTag_approved)
    {
        NSLog(@"待入库");
        CDPurchaseOrder *purchaseOrder = [self.dataArray objectAtIndex:indexPath.row];
        
        if ([purchaseOrder.shipped_rate floatValue] == 0) {
            
            
            MoveItemViewController *moveItemVC = [[MoveItemViewController alloc] initWithNibName:NIBCT(@"MoveItemViewController") bundle:nil];
            [self.navigationController pushViewController:moveItemVC animated:YES];
            
            BSHandlePurchaseOrderRequest *reqest = [[BSHandlePurchaseOrderRequest alloc] initWithPurchaseOrder:purchaseOrder type:HandleType_input];
            [reqest execute];
            [[CBLoadingView shareLoadingView] show];
            
        }
        else
        {
            MoveOrdeViewController *moveOderVC = [[MoveOrdeViewController alloc] initWithNibName:NIBCT(@"MoveOrdeViewController") bundle:nil];
            moveOderVC.purchaseOrder = purchaseOrder;
            [self.navigationController pushViewController:moveOderVC animated:YES];
        }
        
        
    }
    else if (self.orderTag == kOrderTag_draft)
    {
//        if (indexPath.row == currentSelectedRow) {
//            currentSelectedRow = -1;
//        }
//        else
//        {
//            currentSelectedRow = indexPath.row;
//        }
//        [tableView reloadData];
////        [self reloadTableView];
        
        NSLog(@"didEditBtnPressed at indexPath: %@",indexPath);
        CDPurchaseOrder *order = [self.dataArray objectAtIndex:indexPath.row];
        
        CreatePurchaseOrderViewController *purchaseOrderVC = [[CreatePurchaseOrderViewController alloc] initWithNibName:NIBCT(@"CreatePurchaseOrderViewController") bundle:nil];
        purchaseOrderVC.type = OrderType_eidt;
        purchaseOrderVC.purchaseOrder = order;
        [self.navigationController pushViewController:purchaseOrderVC animated:YES];
    }
}


#pragma mark -
#pragma mark CBRefreshDelegate Methods

- (void)scrollView:(UIScrollView *)scrollView withRefreshState:(CBRefreshState)state
{
    if (isLoading && refreshState == state)
    {
        return ;
    }

    else if (state == CBRefreshStateLoadMore)
    {
        refreshState = state;
        [self fetchOrdersWithStartIndex:self.dataArray.count];
    }
}

#pragma mark - 
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.tableView cleanCBrefreshView];
}
#pragma mark - OrderExpandCellDelegate

-(void)didExpandBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == currentSelectedRow) {
        currentSelectedRow = -1;
    }
    else
    {
        currentSelectedRow = indexPath.row;
    }
    [self.tableView reloadData];
}

-(void)didEditBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didEditBtnPressed at indexPath: %@",indexPath);
    CDPurchaseOrder *order = [self.draftOrders objectAtIndex:indexPath.row];
    
    CreatePurchaseOrderViewController *purchaseOrderVC = [[CreatePurchaseOrderViewController alloc] initWithNibName:NIBCT(@"CreatePurchaseOrderViewController") bundle:nil];
    purchaseOrderVC.type = OrderType_eidt;
    purchaseOrderVC.purchaseOrder = order;
    [self.navigationController pushViewController:purchaseOrderVC animated:YES];
    
}
-(void)didDelBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didDelBtnPressed at indexPath: %@",indexPath);
    CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:@"此权限暂未开通"];
    [msgView show];
//    CDPurchaseOrder *order = [self.draftOrders objectAtIndex:indexPath.row];
//    BSHandlePurchaseOrderRequest *orderRequest = [[BSHandlePurchaseOrderRequest alloc] init];
//    orderRequest.purchaseOrder = order;
//    orderRequest.type = HandleType_delete;
//    [orderRequest execute];
    
}
-(void)didCommitBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didCommitBtnPressed at indexPath: %@",indexPath);
    
    [[CBLoadingView shareLoadingView] show];
    
    CDPurchaseOrder *order = [self.draftOrders objectAtIndex:indexPath.row];
    BSHandlePurchaseOrderRequest *orderRequest = [[BSHandlePurchaseOrderRequest alloc] initWithPurchaseOrder:order type:HandleType_commit];
//    orderRequest.purchaseOrder = order;
//    orderRequest.type = HandleType_commit;
    [orderRequest execute];
}

@end
