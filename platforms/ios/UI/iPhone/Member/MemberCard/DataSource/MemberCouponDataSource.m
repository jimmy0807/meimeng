//
//  MemberCouponDataSource.m
//  Boss
//
//  Created by lining on 16/8/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCouponDataSource.h"
#import "CouponCell.h"
#import "CouponSectionHead.h"

@interface MemberCouponDataSource ()<CouponCellDelegate>
@property (nonatomic, strong) NSMutableArray *validCoupons;
@property (nonatomic, strong) NSMutableArray *invalidCoupons;
@end

@implementation MemberCouponDataSource

- (void)setCouponCards:(NSArray *)couponCards
{
    self.validCoupons = [NSMutableArray array];
    self.invalidCoupons = [NSMutableArray array];
    _couponCards = couponCards;
    for (CDCouponCard * coupon in couponCards) {
        if (coupon.isInvalid.boolValue) {
            [self.invalidCoupons addObject:coupon];
        }
        else
        {
             [self.validCoupons addObject:coupon];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.invalidCoupons.count > 0) {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.validCoupons.count;
    }
    else
    {
        return self.invalidCoupons.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CouponCell";
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [CouponCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CDCouponCard *card;
    if (indexPath.section == 0) {
        card = [self.validCoupons objectAtIndex:indexPath.row];
    }
    else
    {
        card = [self.invalidCoupons objectAtIndex:indexPath.row];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.couponCard = card;
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    else
    {
        return 20;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    else if (section == 1)
    {
        CouponSectionHead *headView = [CouponSectionHead createView];
        return headView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        CDCouponCard *couponCard = [self.validCoupons objectAtIndex:indexPath.row];
        if ([self.delegate respondsToSelector:@selector(didSelectctdedCouponCard:)]) {
            [self.delegate didSelectctdedCouponCard:couponCard];
        }
    }
}

#pragma mark - CouponCellDelegate
- (void)didDetailBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        CDCouponCard *couponCard = [self.validCoupons objectAtIndex:indexPath.row];
        if ([self.delegate respondsToSelector:@selector(didSelectctdedCouponCard:)]) {
            [self.delegate didSelectctdedCouponCard:couponCard];
        }
    }
}

@end
