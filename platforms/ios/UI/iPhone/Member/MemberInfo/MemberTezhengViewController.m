//
//  MemberTezhengViewController.m
//  Boss
//
//  Created by lining on 16/4/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberTezhengViewController.h"
#import "MemberAddTezhengViewController.h"
#import "MemberTezhengDataSource.h"
#import "BSFetchMemberTezhengRequest.h"
#import "BSFetchExtendRequest.h"
#import "MemberTezhengDetailViewController.h"

@interface MemberTezhengViewController ()<TeZhengDataSourceDelegate>
@property (nonatomic, strong) MemberTezhengDataSource *dataSource;
@end

@implementation MemberTezhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.title = @"会员特征";
    
    self.dataSource = [[MemberTezhengDataSource alloc] initWithMember:self.member tableView:self.tableView];
    self.dataSource.delegate = self;
    
//    [self registerNofitificationForMainThread:kBSFetchMemberTezhengResponse];
    [self registerNofitificationForMainThread:kBSUpdateMemberResponse];
    
    [[[BSFetchExtendRequest alloc] init] execute];
  
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSUpdateMemberResponse]) {
        [[[BSFetchMemberTezhengRequest alloc] initWithMember:self.member] execute];
    }
}

#pragma mark - TeZhengDataSourceDelegate
- (void)didSelectedTezheng:(CDMemberTeZheng *)tezheng
{
    MemberTezhengDetailViewController *tengzhengDetailVC = [[MemberTezhengDetailViewController alloc] init];
    tengzhengDetailVC.tezheng = tezheng;
    tengzhengDetailVC.member = self.member;
    [self.navigationController pushViewController:tengzhengDetailVC animated:YES];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)addBtnPressed:(id)sender {
//    MemberAddTezhengViewController *addVC = [[MemberAddTezhengViewController alloc] init];
//    addVC.member = self.member;
//    [self.navigationController pushViewController:addVC animated:YES];
    MemberTezhengDetailViewController *tengzhengDetailVC = [[MemberTezhengDetailViewController alloc] init];
    tengzhengDetailVC.member = self.member;
    [self.navigationController pushViewController:tengzhengDetailVC animated:YES];
}
@end
