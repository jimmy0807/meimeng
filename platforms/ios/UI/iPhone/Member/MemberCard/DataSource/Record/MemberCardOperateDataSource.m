//
//  MemberCardOperateDataSource.m
//  Boss
//
//  Created by lining on 16/4/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardOperateDataSource.h"
#import "MemberCardCell.h"

@interface MemberCardOperateDataSource ()

@end

@implementation MemberCardOperateDataSource


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.operates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MemberCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCardCell"];
    if (cell == nil) {
        cell = [MemberCardCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CDPosOperate *operate = [self.operates objectAtIndex:indexPath.row];
    NSString *type = [[BSCoreDataManager currentManager] operateType:operate.type];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)",type,operate.name];
    cell.titleLabel.font = [UIFont systemFontOfSize:16];
    cell.detailLabel.text = operate.operate_date;
//    cell.detailLabel.font = [UIFont systemFontOfSize:15];
    cell.valueLabel.font = [UIFont systemFontOfSize:18];
    cell.valueLabel.textColor = [UIColor blackColor];
    cell.valueLabel.text = [NSString stringWithFormat:@"%.2f",[operate.nowAmount floatValue]];
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
