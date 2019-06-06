//
//  PosOperateMonthDataSource.m
//  Boss
//
//  Created by lining on 16/8/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateMonthView.h"
#import "PosOperateMonthCell.h"
#import "PosOperateCell.h"
#import "BSFetchPosOperateRequest.h"


@interface PosOperateMonthView ()
@property (nonatomic, strong) NSFetchedResultsController *fetchRequestsController;
@property (nonatomic, strong) NSString *month;
@end

@implementation PosOperateMonthView

+ (instancetype)createView
{
    PosOperateMonthView *monthView = [self loadFromNib];
    monthView.tableView.dataSource = monthView;
    monthView.tableView.delegate = monthView;
    return monthView;
}

- (void)reloadView
{
    self.month = [NSString stringWithFormat:@"%@-%02d",self.income.year,[self.income.month integerValue]];
    self.fetchRequestsController = [[BSCoreDataManager currentManager] fetchHistoryPosOprerateResultControllerByType:self.month storeID:self.income.storeID];
    if (self.fetchRequestsController.sections.count > 0) {
        self.noOperateView.hidden = true;
        self.tableView.hidden = false;
        [self.tableView reloadData];
    }
    else
    {
        self.noOperateView.hidden = false;
        self.tableView.hidden = true;
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
    PosOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateCell"];
    if (cell == nil) {
        cell = [PosOperateCell createCell];
    }
    
    CDPosOperate *operate = [self.fetchRequestsController objectAtIndexPath:indexPath];
    cell.operate = operate;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 100;
    
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
    if ([self.delegate respondsToSelector:@selector(didSelectedPosOperate:)]) {
        CDPosOperate *operate = [self.fetchRequestsController objectAtIndexPath:indexPath];
        [self.delegate didSelectedPosOperate:operate];
    }
}

@end
