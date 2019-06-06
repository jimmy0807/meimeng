//
//  MemberFilterViewController.m
//  Boss
//
//  Created by lining on 16/5/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFilterViewController.h"
#import "MemberFilterView.h"
#import "BSMemberFilterRequest.h"
#import "MemberDataSource.h"
#import "MemberFunctionViewController.h"


@interface MemberFilterViewController ()<MemberFilterViewDelegate,MemberDataSourceDelegate>
@property (nonatomic, strong) MemberFilterView *filterView;
@property (nonatomic, strong) MemberDataSource *dataSource;
@end

@implementation MemberFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    self.navigationItem.title = @"筛选";

    
    self.filterView = [[MemberFilterView alloc] initWithStore:self.store];
    self.filterView.delegate = self;
    [self.view addSubview:self.filterView];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    self.dataSource = [[MemberDataSource alloc] initWithTableView:self.filterView.tableView];
    self.dataSource.delegate = self;
//    
//    [self registerNofitificationForMainThread:kBSFilterMemberResponse];
//    [self sendFilterRequest];
}

#pragma mark - MemberFilterViewDelegate
- (void)didFilterMembers:(NSArray *)filterMembers
{
    self.dataSource.filterMembers = filterMembers;
}

- (BOOL)notSendRequestWhenFilterIsNull
{
    self.dataSource.filterMembers = nil;
    return true;
}

#pragma mark - MemberDataSourceDelegate
- (void)didSelectedMemberAtIndexPath:(NSIndexPath *)indexPath
{
    CDMember *member = [self.dataSource.filterMembers objectAtIndex:indexPath.row];
    MemberFunctionViewController *memberFunctionVC = [[MemberFunctionViewController alloc] initWithNibName:@"MemberFunctionViewController" bundle:nil];
    memberFunctionVC.member = member;
    [self.navigationController pushViewController:memberFunctionVC animated:YES];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
