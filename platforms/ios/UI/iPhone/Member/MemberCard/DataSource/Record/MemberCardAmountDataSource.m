//
//  MemberCardAmountDataSource.m
//  Boss
//
//  Created by lining on 16/4/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardAmountDataSource.h"
#import "MemberCardCell.h"

@interface MemberCardAmountDataSource ()

@end

@implementation MemberCardAmountDataSource

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.amounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MemberCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCardCell"];
    if (cell == nil) {
        cell = [MemberCardCell createCell];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.valueLabel.font = [UIFont systemFontOfSize:18];
    cell.valueLabel.textColor = [UIColor blackColor];
    CDMemberCardAmount *amount = [self.amounts objectAtIndex:indexPath.row];
    cell.titleLabel.text = [[BSCoreDataManager currentManager] operateType:amount.type];
    cell.detailLabel.text = amount.create_date;
    
   
    cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[amount.card_amount floatValue]];
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
