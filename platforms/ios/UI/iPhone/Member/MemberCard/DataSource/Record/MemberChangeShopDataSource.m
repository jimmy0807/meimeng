//
//  MemberChangeShopDataSource.m
//  Boss
//
//  Created by lining on 16/5/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberChangeShopDataSource.h"
#import "CardProjectCell.h"

@implementation MemberChangeShopDataSource

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.changeShops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CardProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardProjectCell"];
    if (cell == nil) {
        cell = [CardProjectCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.priceLabel.textColor = [UIColor grayColor];
    cell.priceLabel.font = [UIFont systemFontOfSize:13];
    CDMemberChangeShop *changeShop  = [self.changeShops objectAtIndex:indexPath.row];
    //    cell.titleLabel.text = [[BSCoreDataManager currentManager] operateType:arrear.type];
    cell.titleLabel.text = changeShop.card_name;
    cell.dateLabel.text = changeShop.create_date;
    if ([changeShop.is_change_member_shop boolValue]) {
        cell.priceLabel.text = [NSString stringWithFormat:@"原门店(会员):%@",changeShop.member_shop_name];
        cell.countLabel.text = [NSString stringWithFormat:@"新门店(会员):%@",changeShop.now_member_shop_name];
    }
    else
    {
        cell.priceLabel.text = [NSString stringWithFormat:@"原门店(卡):%@",changeShop.card_shop_name];
        NSLog(@"%@",changeShop.now_card_shop_name);
        cell.countLabel.text = [NSString stringWithFormat:@"新门店(卡):%@",changeShop.now_card_shop_name];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
