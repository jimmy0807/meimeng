//
//  MemberQinyouViewController.m
//  Boss
//
//  Created by lining on 16/4/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberQinyouViewController.h"
#import "MemberQinyouDataSource.h"
#import "MemberQinyouDetailViewController.h"


@interface MemberQinyouViewController ()<QinyouDataSourceDelegate>
@property (strong, nonatomic) MemberQinyouDataSource *dataSource;
@end

@implementation MemberQinyouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.title = @"会员亲友";
    
    self.dataSource = [[MemberQinyouDataSource alloc] initWithMember:self.member tableView:self.tableView];
    self.dataSource.delegate = self;
}



#pragma mark - 
- (void)didSelectedQinyou:(CDMemberQinyou *)qinyou
{
    MemberQinyouDetailViewController *qyDetailVC = [[MemberQinyouDetailViewController alloc] init];
    qyDetailVC.qinyou = qinyou;
    qyDetailVC.member = self.member;
    [self.navigationController pushViewController:qyDetailVC animated:YES];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)addBtnPressed:(id)sender {
    MemberQinyouDetailViewController *qyDetailVC = [[MemberQinyouDetailViewController alloc] init];
    qyDetailVC.member = self.member;
    [self.navigationController pushViewController:qyDetailVC animated:YES];
}
@end
