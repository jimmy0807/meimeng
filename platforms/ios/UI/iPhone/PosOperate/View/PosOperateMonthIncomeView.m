//
//  PosOperateMonthIncomeView.m
//  Boss
//
//  Created by lining on 16/9/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateMonthIncomeView.h"
#import "PosOperateMonthCell.h"
#import "PosOperateCell.h"
#import "BSFetchPosOperateRequest.h"

@interface PosOperateMonthIncomeView ()
@property (nonatomic, strong) NSFetchedResultsController *fetchRequestsController;
@property (nonatomic, strong) NSString *selectedMonth;
@end


@implementation PosOperateMonthIncomeView
+ (instancetype)createView
{
    PosOperateMonthIncomeView *monthIncomeView = [self loadFromNib];
    monthIncomeView.tableView.dataSource = monthIncomeView;
    monthIncomeView.tableView.delegate = monthIncomeView;
    return monthIncomeView;
}

- (void)reloadView
{
    if (self.selectedMonth.length == 0) {
        self.fetchRequestsController = [[BSCoreDataManager currentManager] fetchHistoryPosMonthIncomeResultsController];
    }
    else
    {
        self.fetchRequestsController = [[BSCoreDataManager currentManager] fetchHistoryPosOprerateResultControllerByType:self.selectedMonth storeID:nil];
    }
    if (self.fetchRequestsController.sections.count > 0) {
        self.noOperateView.hidden = true;
        self.tableView.hidden = false;
        [self.tableView reloadData];
    }
    else
    {
        self.noOperateView.hidden = true;
        self.tableView.hidden = false;
        [self.tableView reloadData];
    }
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchRequestsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> secitonInfo = self.fetchRequestsController.sections[section];
    return [secitonInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedMonth.length == 0) {
        PosOperateMonthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateMonthCell"];
        if (cell == nil) {
            cell = [PosOperateMonthCell createCell];
        }
        CDPosMonthIncome *income = [self.fetchRequestsController objectAtIndexPath:indexPath];
        cell.income = income;
        return cell;
    }
    else
    {
        PosOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateCell"];
        if (cell == nil) {
            cell = [PosOperateCell createCell];
        }
        
        CDPosOperate *operate = [self.fetchRequestsController objectAtIndexPath:indexPath];
        cell.operate = operate;
        
        return cell;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedMonth.length == 0) {
        return 81;
    }
    else
    {
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.backgroundColor = COLOR(245, 245, 245, 1);
    
    UILabel *label = [[UILabel alloc] init];
    [imgView addSubview:label];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.leading.offset(20);
    }];
    id<NSFetchedResultsSectionInfo>sectionInfo = self.fetchRequestsController.sections[section];
    label.text = sectionInfo.name;
    return imgView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CDPosMonthIncome *inCome = [self.fetchRequestsController objectAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(didSelectedMonthIncome:)]) {
        [self.delegate didSelectedMonthIncome:inCome];
    }
    
//    if (self.selectedMonth.length == 0) {
//        CDPosMonthIncome *inCome = [self.fetchRequestsController objectAtIndexPath:indexPath];
//        self.selectedMonth = [NSString stringWithFormat:@"%@-%02d",inCome.year,[inCome.month integerValue]];
//        
//        BSFetchPosOperateRequest* request = [[BSFetchPosOperateRequest alloc] init];
//        request.type = self.selectedMonth;
//        
//        [request execute];
//        
//        [self reloadView];
//    }
//    else
//    {
//        
//    }
}

@end
