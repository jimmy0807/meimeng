//
//  MemberCardArrearDataSource.m
//  Boss
//
//  Created by lining on 16/4/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardArrearDataSource.h"
#import "CardProjectCell.h"

@interface MemberCardArrearDataSource ()
@end

@implementation MemberCardArrearDataSource

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.arrears.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CardProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardProjectCell"];
    if (cell == nil) {
        cell = [CardProjectCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CDMemberCardArrears *arrear = [self.arrears objectAtIndex:indexPath.row];
//    cell.titleLabel.text = [[BSCoreDataManager currentManager] operateType:arrear.type];
    cell.titleLabel.text = arrear.arrearsName;
    cell.dateLabel.text = arrear.createDate;
    cell.priceLabel.text = [NSString stringWithFormat:@"欠款金额:%.2f",[arrear.arrearsAmount floatValue]];
    cell.countLabel.text = [NSString stringWithFormat:@"已还金额:%.2f",[arrear.repaymentAmount floatValue]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"title: %@ indexPath: %@",self.tag,indexPath);
    if ([self.delegate respondsToSelector:@selector(didItemSelectedwithType:atIndexPath:)]) {
        [self.delegate didItemSelectedwithType:self.tag atIndexPath:indexPath];
    }
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

@end

