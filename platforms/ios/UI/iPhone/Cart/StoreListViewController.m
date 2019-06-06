//
//  StoreListViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/3/31.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "StoreListViewController.h"
#import "BSCoreDataManager.h"
#import "NSObject+MainThreadNotification.h"
#import "CBBackButtonItem.h"
#import "BSFetchStoreListRequest.h"

#define kStoreCellWidth         296.0
#define kStoreCellHeight        64.0

@interface StoreListViewController ()

@property (nonatomic, strong) NSArray *storeList;
@property (nonatomic, strong) UITableView *storeTableView;

@end

@implementation StoreListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.navigationItem.title = @"选择门店";
    
    [self registerNofitificationForMainThread:kBSFetchStoreListResponse];
    
    CBBackButtonItem *backButtonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    self.storeTableView = [[UITableView alloc] initWithFrame:CGRectMake((IC_SCREEN_WIDTH - kStoreCellWidth)/2.0, 0.0, kStoreCellWidth, IC_SCREEN_HEIGHT - 44.0) style:UITableViewStylePlain];
    self.storeTableView.backgroundColor = [UIColor clearColor];
    self.storeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.storeTableView.showsVerticalScrollIndicator = NO;
    self.storeTableView.showsHorizontalScrollIndicator = NO;
    self.storeTableView.delegate = self;
    self.storeTableView.dataSource = self;
    [self.view addSubview:self.storeTableView];
    
    [self initData];
    [self didStoreListRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initData
{
    ;
}

- (void)didStoreListRequest
{
    BSFetchStoreListRequest *request = [[BSFetchStoreListRequest alloc] init];
    [request execute];
}


#pragma mark -
#pragma mark Required Methods


#pragma mark -
#pragma mark CBBackButtonItemDelegate Methods

- (void)didItemBackButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark NotificationOnMainThread Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchStoreListResponse])
    {
        if ([[notification.userInfo numberValueForKey:@"rc"] boolValue])
        {
            self.storeList = [[BSCoreDataManager currentManager] fetchStoreListWithShopID:nil];
            [self.storeTableView reloadData];
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.storeList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kStoreCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoreCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_cell_n"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_cell_h"]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 0.0, kStoreCellWidth - 12.0 - 24.0 - 64.0, kStoreCellHeight)];
        titleLabel.tag = 101;
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.textColor = COLOR(96.0, 96.0, 96.0, 1.0);
        [cell addSubview:titleLabel];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kStoreCellWidth - 64.0 - 24.0, 0.0, 64.0, kStoreCellHeight)];
        numberLabel.tag = 102;
        numberLabel.textAlignment = NSTextAlignmentRight;
        numberLabel.font = [UIFont systemFontOfSize:16.0];
        numberLabel.textColor = COLOR(96.0, 96.0, 96.0, 1.0);
        [cell addSubview:numberLabel];
    }
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *numberLabel = (UILabel *)[cell viewWithTag:102];
    CDStore *store = [self.storeList objectAtIndex:indexPath.row];
    titleLabel.text = store.storeName;
    numberLabel.text = [NSString stringWithFormat:@"%d", 0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
