//
//  HistoryPosViewController.m
//  Boss
//
//  Created by jimmy on 16/2/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "HistoryPosViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HomeHistoryMonthTableViewCell.h"
#import "HomeHistoryPosTableViewCell.h"
#import "PadPosViewController.h"
#import "BSFetchPosOperateRequest.h"
#import "BSFetchPosMonthIncomeRequest.h"
#import "PadWebViewController.h"
#import "NSData+Additions.h"
#import "CBMessageView.h"
#import "CBLoadingView.h"
#import "UIImage+Resizable.h"

@interface HistoryPosViewController ()<HomeHistoryMonthTableViewCellDelegate,HomeHistoryPosTableViewCellDelegate, UISearchBarDelegate>
@property(nonatomic, weak)IBOutlet UIButton* todayButton;
@property(nonatomic, weak)IBOutlet UIButton* weekButton;
@property(nonatomic, weak)IBOutlet UIButton* monthButton;
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)NSArray* historyPosOperateArray;
@property(nonatomic, strong)NSMutableDictionary* historyDateDictionary;
@property(nonatomic, strong)NSString* selectedMonthYearString;
@property(nonatomic, strong)NSString* selectedBackString;
@property(nonatomic, strong)NSNumber* selectedMonthStoreID;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation HistoryPosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName: @"HomeHistoryMonthTableViewCell" bundle: nil] forCellReuseIdentifier:@"HomeHistoryMonthTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName: @"HomeHistoryPosTableViewCell" bundle: nil] forCellReuseIdentifier:@"HomeHistoryPosTableViewCell"];
    
    [self fetchHistoryPosOperates];
    [self fetchHistoryPosOperatesFromServer];
    
    [self registerNofitificationForMainThread:kFetchPosCardOperateResponse];
    [self registerNofitificationForMainThread:kFetchPosMonthIncomeResponse];
    [self registerNofitificationForMainThread:kBSCancelOperateResponse];
    
    [self setHeaderView];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kFetchPosCardOperateResponse])
    {
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            if ( self.searchBar.text.length == 0 )
            {
                [self fetchHistoryPosOperates];
            }
            else
            {
                self.historyPosOperateArray = notification.object;
            }
            [self reloadTableView];
        }
    }
    else if ([notification.name isEqualToString:kFetchPosMonthIncomeResponse])
    {
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            [self fetchHistoryPosOperates];
            [self reloadTableView];
        }
    }
    else if ( [notification.name isEqualToString:kBSCancelOperateResponse] )
    {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0)
        {
            [self reloadTableView];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]];
            [messageView show];
        }
        
        [[CBLoadingView shareLoadingView] hide];
        
        return;
    }
}

- (IBAction)didTodayButtonPressed:(UIButton*)sender
{
    [self setHeaderView];
    self.selectedMonthYearString = @"";
    self.selectedBackString = @"";
    self.todayButton.selected = YES;
    self.weekButton.selected = NO;
    self.monthButton.selected = NO;
    [self fetchHistoryPosOperates];
    [self fetchHistoryPosOperatesFromServer];
    [self reloadTableView];
}

- (IBAction)didWeekButtonPressed:(UIButton*)sender
{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.selectedMonthYearString = @"";
    self.selectedBackString = @"";
    self.todayButton.selected = NO;
    self.weekButton.selected = YES;
    self.monthButton.selected = NO;
    [self fetchHistoryPosOperates];
    [self fetchHistoryPosOperatesFromServer];
    [self reloadTableView];
}

- (IBAction)didMonthButtonPressed:(UIButton*)sender
{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.todayButton.selected = NO;
    self.weekButton.selected = NO;
    self.monthButton.selected = YES;
    [self fetchHistoryPosOperates];
    [self fetchHistoryPosOperatesFromServer];
    [self reloadTableView];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyPosOperateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.selectedMonthYearString.length == 0 && self.monthButton.selected )
    {
        return [self tableView:tableView cellForHomeTableviewYear:indexPath];
    }
    else
    {
        return [self tableView:tableView cellForHomeTableviewMonth:indexPath];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForHomeTableviewYear:(NSIndexPath *)indexPath
{
    HomeHistoryMonthTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeHistoryMonthTableViewCell"];
    cell.delegate = self;
    
    CDPosMonthIncome* p = self.historyPosOperateArray[indexPath.row];
    cell.inCome = p;
    
    NSIndexPath* orignalIndexPath = self.historyDateDictionary[p.year];
    if ( orignalIndexPath )
    {
        if ( orignalIndexPath.row == indexPath.row )
        {
            [cell showDate:[NSString stringWithFormat:@"%@年",p.year]];
        }
        else
        {
            [cell hideDate];
        }
    }
    else
    {
        self.historyDateDictionary[p.year] = indexPath;
        [cell showDate:[NSString stringWithFormat:@"%@年",p.year]];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForHomeTableviewMonth:(NSIndexPath *)indexPath
{
    HomeHistoryPosTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeHistoryPosTableViewCell"];
    
    CDPosOperate* op = self.historyPosOperateArray[indexPath.row];
    cell.operate = op;
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    if ( self.monthButton.selected || self.weekButton.selected )
    {
        NSIndexPath* orignalIndexPath = self.historyDateDictionary[op.day];
        if ( orignalIndexPath )
        {
            if ( orignalIndexPath.row == indexPath.row )
            {
                [cell showDate:[NSString stringWithFormat:@"%@日",op.day]];
            }
            else
            {
                [cell hideDate];
            }
        }
        else
        {
            self.historyDateDictionary[op.day] = indexPath;
            [cell showDate:[NSString stringWithFormat:@"%@日",op.day]];
        }
    }
    else
    {
        [cell hideDate];
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( self.selectedMonthYearString.length != 0 )
    {
        return 79;
    }
    
    return 15.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( self.selectedMonthYearString.length == 0 )
    {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 15)];
        v.backgroundColor = COLOR(242, 245, 245, 1);

        return v;
    }
    else
    {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 79)];
        v.backgroundColor = COLOR(242, 245, 245, 1);
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(150, 18, 46, 30);
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
        [btn setImage:[UIImage imageNamed:@"Pad_Home_history_monthBack"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Pad_Home_history_monthBack"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(didMonthBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btn];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(172, 23, 211, 21)];
        label.textColor = COLOR(134, 134, 157, 1);
        label.font = [UIFont systemFontOfSize:17];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = self.selectedBackString;
        [v addSubview:label];
        
        
        UIButton* emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        emptyButton.frame = v.bounds;
        [emptyButton addTarget:self action:@selector(didMonthBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:emptyButton];
        
        return v;
    }
    
    return nil;
}

- (void)didMonthBackButtonPressed:(id)sender
{
    self.selectedMonthYearString = @"";
    self.selectedBackString = @"";
    [self fetchHistoryPosOperates];
    [self reloadTableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)didMenuButtonPressed:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)didHomeHistoryPosTableViewYearCellPresssed:(HomeHistoryMonthTableViewCell*)cell inCome:(CDPosMonthIncome*)inCome
{
    self.selectedMonthYearString = [NSString stringWithFormat:@"%@-%02d",inCome.year,[inCome.month integerValue]];
    self.selectedMonthStoreID = inCome.storeID;
    self.selectedBackString = [NSString stringWithFormat:@"%@年%02d月",inCome.year,[inCome.month integerValue]];
    [self fetchHistoryPosOperates];
    [self fetchHistoryPosOperatesFromServer];
    [self reloadTableView];
}

- (void)didHomeHistoryPosTableViewCellPresssed:(HomeHistoryPosTableViewCell*)cell
{
    CDPosOperate* op = self.historyPosOperateArray[cell.indexPath.row];
    
    PadPosViewController *posViewController = [[PadPosViewController alloc] init];
    posViewController.operate = op;
    [self.navigationController pushViewController:posViewController animated:YES];
}

- (void)fetchHistoryPosOperates
{
    if ( self.todayButton.selected )
    {
        self.historyPosOperateArray = [[BSCoreDataManager currentManager] fetchHistoryPosOperatesByType:@"day" storeID:nil];
    }
    else if ( self.weekButton.selected )
    {
        self.historyDateDictionary = [NSMutableDictionary dictionary];
        self.historyPosOperateArray = [[BSCoreDataManager currentManager] fetchHistoryPosOperatesByType:@"week" storeID:nil];
    }
    else
    {
        self.historyDateDictionary = [NSMutableDictionary dictionary];
        if ( self.selectedMonthYearString.length == 0 && self.monthButton.selected )
        {
            self.historyPosOperateArray = [[BSCoreDataManager currentManager] fetchHistoryPosMonthIncome];
        }
        else
        {
            self.historyPosOperateArray = [[BSCoreDataManager currentManager] fetchHistoryPosOperatesByType:self.selectedMonthYearString storeID:self.selectedMonthStoreID];
        }
    }
}

- (void)fetchHistoryPosOperatesFromServer
{
    if ( self.todayButton.selected )
    {
        BSFetchPosOperateRequest* request = [[BSFetchPosOperateRequest alloc] init];
        request.type = @"day";
        [request execute];
    }
    else if ( self.weekButton.selected )
    {
        BSFetchPosOperateRequest* request = [[BSFetchPosOperateRequest alloc] init];
        request.type = @"week";
        [request execute];
    }
    else
    {
        if ( self.selectedMonthYearString.length == 0 )
        {
            BSFetchPosMonthIncomeRequest* request = [[BSFetchPosMonthIncomeRequest alloc] init];
            [request execute];
        }
        else
        {
            BSFetchPosOperateRequest* request = [[BSFetchPosOperateRequest alloc] init];
            request.type = self.selectedMonthYearString;
            request.shopID = self.selectedMonthStoreID;
            [request execute];
        }
    }
}

- (void)reloadTableView
{
    [self.tableView reloadData];
    [self reloadEmptyPosImageView];
}

- (void)reloadEmptyPosImageView
{
    UIImageView* emptyPosImageView = [self.tableView viewWithTag:2986];
    
    if ( self.todayButton.selected && self.historyPosOperateArray.count == 0 )
    {
        if ( emptyPosImageView == nil )
        {
            UIImage* image = [UIImage imageNamed:@"Pad_History_EmptyPos"];
            emptyPosImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.tableView.frame.size.width - image.size.width)/2, (self.tableView.frame.size.height - image.size.height)/2, image.size.width, image.size.height)];
            emptyPosImageView.image = image;
            emptyPosImageView.tag = 2986;
            [self.tableView addSubview:emptyPosImageView];
        }
        
        return;
    }
    
    [emptyPosImageView removeFromSuperview];
}

- (IBAction)webButtonPressed:(id)sender {
    
    NSLog(@"后台");
    PersonalProfile* profile = [PersonalProfile currentProfile];
//    NSString* sendParams =  [NSString stringWithFormat:@"login=%@&key=%@&redirect=dashboard",profile.userName,profile.password];
//    NSString* sendParamsSing =  [NSString stringWithFormat:@"login=%@password=%@",profile.userName,profile.password];
//    
//    NSString* prepareForSign = [NSString stringWithFormat:@"%@%@",sendParamsSing,[profile token]];
//    
//    NSData *userData = [prepareForSign dataUsingEncoding:NSUTF8StringEncoding];
//    NSString* sign = [userData md5Hash];
    
//    PadWebViewController* webViewController = [[PadWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/login?db=%@&%@&sign=%@&client_id=%@",profile.baseUrl,profile.sql,sendParams,sign,[profile deviceString]]];
    
    PadWebViewController* webViewController = [[PadWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/login?db=%@&client_id=%@&login=%@&key=%@&sign=%@",profile.baseUrl,profile.sql,[profile deviceString],profile.userName,profile.password,profile.token]];
    
    
    webViewController.disableBounces = YES;
    webViewController.hideNavigation = NO;
    [self.navigationController pushViewController:webViewController animated:YES];
    
}

- (void)setHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024, 64.0)];
    headerView.backgroundColor = [UIColor clearColor];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(150, 20, 725, 44.0)];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"pad_background_white_color"]];
    //UIImage *searchFieldImage = [[UIImage imageNamed:@"pad_member_search_field"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    //[self.searchBar setSearchFieldBackgroundImage:searchFieldImage forState:UIControlStateNormal];
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.placeholder = @"搜索客户名字和电话号码";
    self.searchBar.delegate = self;
    [headerView addSubview:self.searchBar];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ( searchBar.text.length == 0 )
    {
        [self fetchHistoryPosOperates];
    }
    else
    {
        self.historyPosOperateArray = [[BSCoreDataManager currentManager] fetchHistoryPosOperatesByKeyword:searchBar.text];
    }
    [self reloadTableView];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if ( searchBar.text.length == 0 )
    {
        [self fetchHistoryPosOperates];
    }
    else
    {
        self.historyPosOperateArray = [[BSCoreDataManager currentManager] fetchHistoryPosOperatesByKeyword:searchBar.text];
    }
    [self reloadTableView];
}

@end
