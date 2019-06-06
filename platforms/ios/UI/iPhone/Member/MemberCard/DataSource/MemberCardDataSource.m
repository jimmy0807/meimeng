//
//  MemberCardDataSource.m
//  Boss
//
//  Created by lining on 16/3/25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardDataSource.h"
#import "MemberVipCardCell.h"

@implementation MemberCardDataSource
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.memberCards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MemberVipCardCell";
    MemberVipCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [MemberVipCardCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CDMemberCard *card = [self.memberCards objectAtIndex:indexPath.row];
    cell.nameLabel.text = card.priceList.name;
    cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[card.amount floatValue]];
    cell.cardNoLabel.text = card.cardNo;
    cell.shopLabel.text = card.storeName;
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CDMemberCard *memberCard = [self.memberCards objectAtIndex:row];

    if ([self.delegate respondsToSelector:@selector(didSelectctdedMemberCard:)]) {
        [self.delegate didSelectctdedMemberCard:memberCard];
    }
}

@end
