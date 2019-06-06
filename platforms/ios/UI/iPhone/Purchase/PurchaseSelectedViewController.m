//
//  ResposityViewController.m
//  Boss
//
//  Created by lining on 15/6/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "PurchaseSelectedViewController.h"
#import "BSFetchWarehouse.h"
#import "BSFetchStorageRequest.h"
#import "CBLoadingView.h"

#define kCellHeight  50

@interface PurchaseSelectedViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL isFirstLoadView;
    NSInteger selectedRow;
    
}
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation PurchaseSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    if (self.type == SelectedType_resposity) {
        self.navigationItem.title = @"选择仓库";
    }
    else
    {
        self.navigationItem.title = @"选择库位";
    }
    isFirstLoadView = true;
    
    [self initData];
    
    [[CBLoadingView shareLoadingView] show];
    if (self.type == SelectedType_resposity) {
        self.selectedObject = self.purchaseOrder.warehouse;
        [self registerNofitificationForMainThread:kBSFetchRespositoryRequest];
        BSFetchWarehouse *reqest = [[BSFetchWarehouse alloc] init];
        [reqest execute];
    }
    else if (self.type == SelectedType_storage)
    {
//        self.selectedObject = self.purchaseOrder.storage;
        [self registerNofitificationForMainThread:kBSFetchStorageRequest];
        BSFetchStorageRequest *request = [[BSFetchStorageRequest alloc] init];
        
        [request execute];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isFirstLoadView) {
        
        [self initView];
        isFirstLoadView = true;
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

- (void)initData
{
    if (self.type == SelectedType_resposity) {
        self.dataArray = [[BSCoreDataManager currentManager] fetchAllWarehouses];
    }
    else if (self.type == SelectedType_storage)
    {
        self.dataArray = [[BSCoreDataManager currentManager] fetchAllStoreages];
    }
}

#pragma mark - Received Notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [[CBLoadingView shareLoadingView] hide];
    NSDictionary *retDict = notification.userInfo;
    if ([[retDict numberValueForKey:@"rc"] integerValue] == 0) {
        NSLog(@"收到通知");
        [self initData];
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSOptionCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bs_common_cell_n"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bs_common_cell_h"]];
        
        UIImage *selectedImg = [UIImage imageNamed:@"option_selected"];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 0.0, IC_SCREEN_WIDTH - 2 * 16.0 - selectedImg.size.width, kCellHeight)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
        titleLabel.tag = 101;
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - 16.0 - selectedImg.size.width, (kCellHeight - selectedImg.size.height)/2.0, selectedImg.size.width, selectedImg.size.height)];
        selectedImageView.backgroundColor = [UIColor clearColor];
        selectedImageView.image = selectedImg;
        selectedImageView.tag = 102;
        [cell.contentView addSubview:selectedImageView];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kCellHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
        lineImageView.backgroundColor = [UIColor clearColor];
        lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
        [cell.contentView addSubview:lineImageView];
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UIImageView *selectedImageView = (UIImageView *)[cell.contentView viewWithTag:102];
    NSString *string = nil;
    BOOL selected = false;
    
    if (self.type == SelectedType_resposity) {
        CDWarehouse *warehouse = [self.dataArray objectAtIndex:indexPath.row];
        string = warehouse.warehouse_name;
        
        CDWarehouse *currentwarehouse = (CDWarehouse *)self.selectedObject;
        
        if ([warehouse.pick_id integerValue] == [currentwarehouse.pick_id integerValue]) {
            selected = true;
            NSLog(@"第%d行被选中",indexPath.row);
        }
    }
    else if (self.type == SelectedType_storage)
    {
        CDStorage *storage = [self.dataArray objectAtIndex:indexPath.row];
        string = storage.displayName;
        
        CDStorage *currentStorage = (CDStorage *)self.selectedObject;
        
        if ([storage.storage_id integerValue] == [currentStorage.storage_id integerValue]) {
            selected = true;
        }

    }
    
    titleLabel.text = string;
    
    if (selected)
    {
        selectedImageView.hidden = NO;
    }
    else
    {
        selectedImageView.hidden = YES;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedObject = [self.dataArray objectAtIndex:indexPath.row];
    [tableView reloadData];
    
    if (self.type == SelectedType_storage) {
        self.purchaseOrder.storage = (CDStorage *)self.selectedObject;
    }
    else if (self.type == SelectedType_resposity)
    {
        self.purchaseOrder.warehouse = (CDWarehouse *)self.selectedObject;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedManageObject:withType:)])
    {
        [self.delegate didSelectedManageObject:self.selectedObject withType:self.type];
    }
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:0.25];
//    [self.navigationController popViewControllerAnimated:YES];
}


-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
