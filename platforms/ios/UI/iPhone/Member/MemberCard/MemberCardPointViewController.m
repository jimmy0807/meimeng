//
//  MemberCardPointViewController.m
//  Boss
//
//  Created by lining on 16/5/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardPointViewController.h"
#import "MemberCardPointDataSource.h"
#import "BSFetchCardPointsRequest.h"
#import "MemberRecordDetailViewController.h"

@interface MemberCardPointViewController ()<MemberRecordDataSourceProtocol>
@property (nonatomic, strong) MemberCardPointDataSource *dataSource;
@end

@implementation MemberCardPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = [NSString stringWithFormat:@"%@",self.card.points];
    
    self.dataSource = [[MemberCardPointDataSource alloc] init];
    self.dataSource.delegate = self;
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    
    [self registerNofitificationForMainThread:kBSFetchMemberCardPointResponse];
    
    [self sendRequest];
    [self reloadData];
    
}
#pragma mark - reload data
- (void)reloadData
{
    self.dataSource.points = self.card.card_points.array;
    [self.tableView reloadData];
}

#pragma mark - send request
- (void)sendRequest
{
    BSFetchCardPointsRequest *pointRequest = [[BSFetchCardPointsRequest alloc] initWithCardID:self.card.cardID];
    [pointRequest execute];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [self reloadData];
}

#pragma mark - MemberRecordDataSourceProtocol
- (void)didItemSelectedwithType:(NSString *)type atIndexPath:(NSIndexPath *)indexPath
{
    CDMemberCardPoint *point = [self.dataSource.points objectAtIndex:indexPath.row];
    NSArray *sectionArray = @[@[@{@"卡编号":point.card_name},@{@"类型":[[BSCoreDataManager currentManager] operateType:point.type]},@{@"操作时间":point.create_date}],
                     @[@{@"变动前积分":point.point},@{@"变动后积分":point.exchange_point}]];

    MemberRecordDetailViewController *detailVC = [[MemberRecordDetailViewController alloc] init];
    detailVC.sectionArray = sectionArray;
    detailVC.title = @"积分明细";
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
