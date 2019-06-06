//
//  MemberCardConsumeDataSource.m
//  Boss
//
//  Created by lining on 16/4/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardConsumeDataSource.h"
#import "MemberCardCell.h"

@interface MemberCardConsumeDataSource ()

@end

@implementation MemberCardConsumeDataSource
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.consumes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MemberCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCardCell"];
    if (cell == nil) {
        cell = [MemberCardCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CDMemberCardConsume *consume = [self.consumes objectAtIndex:indexPath.row];
    cell.titleLabel.text = consume.product_name;
    cell.detailLabel.text = consume.create_date;
//    cell.valueLabel.text = [NSString stringWithFormat:@"%.2f",[consume.price floatValue]];
    cell.valueLabel.font = [UIFont systemFontOfSize:13];
    cell.valueLabel.textColor = [UIColor grayColor];
    cell.valueLabel.text = [NSString stringWithFormat:@"%@次",consume.consume_qty];
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
