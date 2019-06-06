//
//  PanDianViewController.m
//  Boss
//
//  Created by lining on 15/7/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "PanDianViewController.h"
#import "BSFetchPanDianRequest.h"
#import "BSHandlePanDianRequest.h"
#import "CBSegmentControl.h"
#import "CBRefreshView.h"
#import "BSFetchPanDianRequest.h"
#import "PanDianCell.h"
#import "CreatePanDianViewController.h"
#import "BSProjectRequest.h"
#import "CBLoadingView.h"
#import "BSFetchStorageRequest.h"

#define kCellHeight  60
#define kMarginSize  20
#define kTableHeadHeight    68

@interface PanDianViewController ()<UITableViewDataSource,UITableViewDelegate,CBSegmentControlDelegate,CBRefreshDelegate>
{
    BOOL isFirstLoadView;
    BOOL isLoading;
    CBRefreshState refreshState;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) BSProjectRequest *request;

@end

@implementation PanDianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"盘点";
    isFirstLoadView = true;
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n"] highlightedImage:[UIImage imageNamed:@"navi_add_h"]];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    [self registerNofitificationForMainThread:kBSFetchPanDianResponse];
    [self registerNofitificationForMainThread:kBSProjectRequestSuccess];
    [self registerNofitificationForMainThread:kBSProjectRequestFailed];
    
    [self registerNofitificationForMainThread:PopToPanDianVCRefresh];
    [self registerNofitificationForMainThread:kBSAutoPanDianResponse];
    
    
    //盘点
    [self fetchPanDiansWithStartIndex:0];
    
    //创建
//    BSHandlePanDianRequest *req = [[BSHandlePanDianRequest alloc] initWithPanDian:nil type:HandlePanDian_create];
//    [req execute];
    
    [self initData];
    
    [self sendBaseRequest];
    
   
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isFirstLoadView) {
    
        [self initView];
        isFirstLoadView = false;
    }
}

#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    NSLog(@"right button pressed");
    CreatePanDianViewController *createPanDianVC = [[CreatePanDianViewController alloc] initWithNibName:NIBCT(@"CreatePanDianViewController") bundle:nil];
    createPanDianVC.type = PanDianType_create;
    [self.navigationController pushViewController:createPanDianVC animated:YES];
}

- (void)sendBaseRequest
{
    BSFetchStorageRequest *request = [[BSFetchStorageRequest alloc] init];
    [request execute];
    
    NSArray *templates = [[BSCoreDataManager currentManager] fetchAllProjectTemplate];
    NSArray *items = [[BSCoreDataManager currentManager] fetchAllProjectItem];
    if (templates.count == 0 && items.count == 0)
    {
        NSLog(@"产品还没有拿");
        [[CBLoadingView shareLoadingView] show];
        [[BSProjectRequest sharedInstance] startProjectRequest];
        
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
    self.tableView.tableHeaderView = [self segmentControlView];
    self.tableView.refreshDelegate = self;
    self.tableView.canLoadMore = true;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    isLoading = NO;
    refreshState = CBRefreshStateRefresh;
}


- (UIView *)segmentControlView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, kTableHeadHeight)];
    view.autoresizingMask = 0xff;
    
    CBSegmentControl *segmentControl = [[CBSegmentControl alloc] initWithFrame:CGRectMake(kMarginSize/2.0, (kTableHeadHeight - 29)/2.0, view.frame.size.width - kMarginSize, 29) titles:@[@"草稿",@"进行中",@"已完成"]];
    segmentControl.delegate = self;
    segmentControl.autoresizingMask = 0xff;
    segmentControl.selectedIdx = self.panDianTag;
    [view addSubview:segmentControl];
    
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kTableHeadHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [view addSubview:lineImageView];
    return view;
}

- (void) initData
{
    BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
    
    NSString *state = [self panDianState];
    
    self.dataArray = [dataManager fetchPanDiansWithState:state];
    
}

- (NSString *)panDianState
{
    NSString *state;
    
    if (self.panDianTag == kPandianTag_draft) {
        state = @"draft";
    }
    else if (self.panDianTag == kPandianTag_confirm)
    {
        state = @"confirm";
    }
    else if (self.panDianTag == kPandianTag_done)
    {
        state = @"done";
    }
   
    return state;
}

#pragma mark - Request
-(void) fetchPanDiansWithStartIndex:(NSInteger)startIndex
{
    if (!isLoading) {
        NSString *state = [self panDianState];
        //    [[CBLoadingView shareLoadingView] show];
        BSFetchPanDianRequest *req = [[BSFetchPanDianRequest alloc] initWithStartIndex:startIndex state:state];
        [req execute];
        isLoading = YES;
        if (startIndex == 0) {
//            [[CBLoadingView shareLoadingView] show];
        }
    }
    
}

#pragma mark - notification
 - (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchPanDianResponse]) {
//        [[CBLoadingView shareLoadingView] hide];
         isLoading = NO;
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] == 0) {
            [self.tableView stopWithRefreshState:refreshState];
            [self reloadTableView];
        }
    }
    else if ([notification.name isEqualToString:kBSProjectRequestSuccess] || [notification.name isEqualToString:kBSProjectRequestFailed])
    {
        [[CBLoadingView shareLoadingView] hide];
    }
    else if ([notification.name isEqualToString:PopToPanDianVCRefresh] || [notification.name isEqualToString:kBSAutoPanDianResponse])
    {
        [self fetchPanDiansWithStartIndex:0];
        [self reloadTableView];
    }
}

#pragma mark -
#pragma mark CBSegmentControlDelegate
-(void)didSegmentCotrolSelectedAtIndex:(NSInteger)index
{
    NSLog(@"segment selected at index: %d",index);
    self.panDianTag = index;
    
    [self fetchPanDiansWithStartIndex:0];
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
    static NSString *indentifier = @"indentifier";
    PanDianCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[PanDianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier width:self.tableView.frame.size.width];
        
    }
    CDPanDian *panDian = [self.dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = panDian.name;
    cell.dateLabel.text = [NSString stringWithFormat:@"盘点日期: %@",[panDian.date substringToIndex:10]];
  
    cell.detailLabel.text = [NSString stringWithFormat:@"库位: %@", panDian.storage.displayName];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PanDianCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
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
    CDPanDian *panDian = [self.dataArray objectAtIndex:indexPath.row];
    
    CreatePanDianViewController *createPanDianVC = [[CreatePanDianViewController alloc] initWithNibName:NIBCT(@"CreatePanDianViewController") bundle:nil];
    createPanDianVC.panDian = panDian;
    if (self.panDianTag == kPandianTag_draft) {
        
        createPanDianVC.type = PanDianType_edit;
    }
    else if (self.panDianTag == kPandianTag_confirm)
    {
        createPanDianVC.type = PanDianType_confirm;
    }
    else if (self.panDianTag == kPandianTag_done)
    {
        createPanDianVC.type = PanDianType_look;
    }
   
    [self.navigationController pushViewController:createPanDianVC animated:YES];
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
        [self fetchPanDiansWithStartIndex:self.dataArray.count];
    }
}

#pragma mark -
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.tableView cleanCBrefreshView];
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
