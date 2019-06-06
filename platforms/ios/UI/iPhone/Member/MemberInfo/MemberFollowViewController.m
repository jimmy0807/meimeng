//
//  MemberFollowViewController.m
//  Boss
//
//  Created by lining on 16/5/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFollowViewController.h"
#import "BSFetchMemberFollowRequest.h"
#import "MemberFollowCell.h"
#import "MemberFollowDetailViewController.h"
#import "MemberFollowCreateViewController.h"

@interface MemberFollowViewController ()
@property (strong, nonatomic) NSArray *follows;
@property (strong, nonatomic) NSMutableArray *years;
@property (strong, nonatomic) NSMutableDictionary *yearFollowsDict;
@property (strong, nonatomic) NSMutableDictionary *monthFirstRowDict;
//@property (strong, nonatomic) NSFetchedResultsController *requestController;
//@property (strong, nonatomic)
@end

@implementation MemberFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n.png"] highlightedImage:[UIImage imageNamed:@"navi_add_h.png"]];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.navigationItem.title = @"跟进表";
    [self registerNofitificationForMainThread:kBSFetchMemberFollowResponse];
    [self registerNofitificationForMainThread:kBSCreateMemberFollowResponse];
    [self sendRequest];
    [self reloadData];
    
    
}

- (void)reloadData
{
    self.follows = [[BSCoreDataManager currentManager] fetchMemberFollowsWithMember:self.member];
    
    self.years = [NSMutableArray array];
    self.yearFollowsDict = [NSMutableDictionary dictionary];
    
    self.monthFirstRowDict = [NSMutableDictionary dictionary];
    
    for (CDMemberFollow *follow in self.follows) {
        NSMutableArray *yearFollows = [self.yearFollowsDict objectForKey:follow.year];
        if (yearFollows == nil) {
            yearFollows = [NSMutableArray array];
            [self.years addObject:follow.year];
            [self.yearFollowsDict setObject:yearFollows forKey:follow.year];
        }
        [yearFollows addObject:follow];
        
        NSMutableDictionary *monthDict = [self.monthFirstRowDict objectForKey:follow.year];
        if (monthDict == nil) {
            monthDict = [NSMutableDictionary dictionary];
            [self.monthFirstRowDict setObject:monthDict forKey:follow.year];
        }
    }
    
    
    if (self.follows.count == 0) {
        self.noView.hidden = false;
        self.tableView.hidden = true;
    }
    else
    {
        self.noView.hidden = true;
        self.tableView.hidden = false;
        [self.tableView reloadData];
    }
}

#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    MemberFollowCreateViewController *followCreateVC = [[MemberFollowCreateViewController alloc] init];
    followCreateVC.member = self.member;
    [self.navigationController pushViewController:followCreateVC animated:YES];
}

#pragma mark - sendRequest
- (void)sendRequest
{
    BSFetchMemberFollowRequest *request = [[BSFetchMemberFollowRequest alloc] init];
    request.member = self.member;
    [request execute];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberFollowResponse]) {
        NSLog(@"_________________reload data________________");
        [self reloadData];
    }
    else if ([notification.name isEqualToString:kBSCreateMemberFollowResponse])
    {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            [self sendRequest];
        }
    }
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.years.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *yearFollows = [self.yearFollowsDict objectForKey:[self.years objectAtIndex:section]];
    return yearFollows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    MemberFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberFollowCell"];
    if (cell == nil) {
        cell = [MemberFollowCell createCell];
    }
    
    NSNumber *year = [self.years objectAtIndex:section];
    NSArray *yearFollows = [self.yearFollowsDict objectForKey:year];
    CDMemberFollow *follow = [yearFollows objectAtIndex:row];
    cell.follow = follow;
    
    NSLog(@"month: %@",follow.month);
    
    NSMutableDictionary *firstRowDict = [self.monthFirstRowDict objectForKey:year];
    
//    NSLog(@"-------fistRowDict: %@",firstRowDict);
    
    if ([firstRowDict objectForKey:follow.month] == nil) {
        [firstRowDict setObject:@(row) forKey:follow.month];
        cell.monthLabel.hidden = false;
        NSLog(@"fistRowDict: %@",firstRowDict);
    }
    else
    {
        if ([[firstRowDict objectForKey:follow.month] integerValue] == row) {
            cell.monthLabel.hidden = false;
        }
        else
        {
            cell.monthLabel.hidden = true;
        }
    }
    
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSNumber *year = [self.years objectAtIndex:section];
    NSArray *yearFollows = [self.yearFollowsDict objectForKey:year];
    CDMemberFollow *follow = [yearFollows objectAtIndex:row];
    
    MemberFollowDetailViewController *followDetailVC = [[MemberFollowDetailViewController alloc] init];
    followDetailVC.follow = follow;
    [self.navigationController pushViewController:followDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.image = [UIImage imageNamed:@"member_follow_head_bg.png"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, (46-20)/2.0, 100, 20)];
    label.font = [UIFont systemFontOfSize:15.0];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.text = [NSString stringWithFormat:@"%@年",self.years[section]];
    [view addSubview:label];
    return view;
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
