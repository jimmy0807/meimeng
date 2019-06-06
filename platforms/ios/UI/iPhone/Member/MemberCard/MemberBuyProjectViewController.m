//
//  MemberBuyProjectViewController.m
//  Boss
//
//  Created by lining on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberBuyProjectViewController.h"
#import "CBMessageView.h"
#import "MemberCardCell.h"

@interface MemberBuyProjectViewController ()
@property (nonatomic, strong) NSArray *buyProjects;
@end

@implementation MemberBuyProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    self.title = @"购买的项目";
    [self reloadData];
    [self registerNofitificationForMainThread:kBSFetchMemberCardProjectResponse];
}

#pragma mark - reload data
- (void)reloadData
{
    self.buyProjects = self.memberCard.products.array;
    [self.tableView reloadData];
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberCardProjectResponse]) {
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
    return self.buyProjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCardCell"];
    if (cell == nil) {
        cell = [MemberCardCell createCell];
        cell.valueLabel.font = [UIFont systemFontOfSize:17];
        cell.valueLabel.textColor = [UIColor blackColor];
        
//        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        cell.titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
    }
    
    CDMemberCardProject *buyProject = [self.buyProjects objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = buyProject.projectName;
    cell.detailLabel.text = buyProject.create_date;
    cell.countLabel.text = [NSString stringWithFormat:@"x%@",buyProject.purchaseQty];
    cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[buyProject.projectPriceUnit doubleValue]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
