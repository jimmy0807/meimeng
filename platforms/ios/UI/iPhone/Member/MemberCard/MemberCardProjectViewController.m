//
//  MemberCardProjectViewController.m
//  Boss
//
//  Created by lining on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardProjectViewController.h"
#import "CardProjectCell.h"
#import "BSFetchMemberCardProjectRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "MemberRecordViewController.h"

@interface MemberCardProjectViewController ()
@property (nonatomic, strong) NSArray *cardProjects;
@end

@implementation MemberCardProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    BNRightButtonItem *rightBtnItem = [[BNRightButtonItem alloc]initWithTitle:@"明细"];
    rightBtnItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    self.title = @"卡内项目";
    
//    BSFetchMemberCardProjectRequest *request = [[BSFetchMemberCardProjectRequest alloc] initWithMemberCardID:self.memberCard.cardID];
//    [request execute];
//    [[CBLoadingView shareLoadingView] show];
    
    
    [self reloadData];
    
    [self registerNofitificationForMainThread:kBSFetchMemberCardProjectResponse];
    
}

#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    MemberRecordViewController *recordVC = [[MemberRecordViewController alloc] init];
    recordVC.card = self.memberCard;
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark - reload data
- (void)reloadData
{
    NSMutableArray *projects = [NSMutableArray array];
    for (CDMemberCardProject *cardProject in self.memberCard.projects.array) {
        if (cardProject.remainQty.integerValue > 0) {
//            count ++;
            [projects addObject:cardProject];
        }
    }
    self.cardProjects = projects;
    [self.tableView reloadData];
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberCardProjectResponse]) {
//        [[CBLoadingView shareLoadingView] hide];
        int ret = [[notification.userInfo numberValueForKey:@"rc"] integerValue];
        if (ret == 0) {
            [self reloadData];
        }
        else
        {
            NSString *errorMsg = [notification.userInfo stringValueForKey:@"rm"];
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:errorMsg];
            [messageView show];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cardProjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CardProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardProjectCell"];
    if (cell == nil) {
        cell = [CardProjectCell createCell];
    }
    cell.arrowImgHidden = true;
    CDMemberCardProject *cardProject = [self.cardProjects objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = cardProject.projectName;
    cell.dateLabel.text = cardProject.create_date;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[cardProject.projectPrice floatValue]];
    cell.countLabel.text = [NSString stringWithFormat:@"%@/%@次",cardProject.remainQty,cardProject.purchaseQty];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
