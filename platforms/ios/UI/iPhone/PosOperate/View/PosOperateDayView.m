//
//  PosOperateDataSource.m
//  Boss
//
//  Created by lining on 16/8/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateDayView.h"
#import "PosOperateCell.h"

@interface PosOperateDayView ()
@property (nonatomic, strong) NSArray *posOperates;
@end

@implementation PosOperateDayView

+ (instancetype)createView
{
    PosOperateDayView *dayView = [self loadFromNib];
    dayView.tableView.dataSource = dayView;
    dayView.tableView.delegate = dayView;
    return dayView;
}

- (void)reloadView
{
    self.posOperates = [[BSCoreDataManager currentManager] fetchHistoryPosOperatesByType:@"day" storeID:nil];
    if (self.posOperates.count > 0) {
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posOperates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PosOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateCell"];
    if (cell == nil) {
        cell = [PosOperateCell createCell];
    }
    cell.operate = [self.posOperates objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.backgroundColor = [UIColor clearColor];
    return imgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(didSelectedPosOperate:)]) {
        CDPosOperate *operate = [self.posOperates objectAtIndex:indexPath.row];
        [self.delegate didSelectedPosOperate:operate];
    }
}

- (void)dealloc
{
    NSLog(@"----");
}
@end
