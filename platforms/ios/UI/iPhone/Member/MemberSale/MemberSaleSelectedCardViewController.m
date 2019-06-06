//
//  MemberSaleSelectedCardViewController.m
//  Boss
//
//  Created by lining on 16/6/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberSaleSelectedCardViewController.h"
#import "SelectedCardCell.h"
#import "productProjectMainController.h"
#import "MemberCardShopCartViewController.h"
#import "OperateManager.h"
#import "BSFetchMemberCardRequest.h"
#import "BSFetchCouponCardRequest.h"
#import "BSFetchMemberCardDetailRequest.h"

typedef enum kSection
{
    kSection_card,
    kSection_coupon,
    kSection_num
}kSection;


@interface MemberSaleSelectedCardViewController ()
@property (nonatomic, strong) NSArray *memberCards;
@property (nonatomic, strong) NSArray *memberCoupons;
@property (nonatomic, strong) CDMemberCard *currentSelectedCard;
@property (nonatomic, strong) CDCouponCard *currentSelectedCoupon;
@end

@implementation MemberSaleSelectedCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = LS(@"选卡或券");
    
   
    [self registerNofitificationForMainThread:kBSFetchMemberCardResponse];
    [self registerNofitificationForMainThread:kBSFetchCouponCardResponse];
    
    [self sendRequest];
    [self reloadData];
    
    
    self.currentSelectedCard = [OperateManager shareManager].posOperate.memberCard;
    self.currentSelectedCoupon = [OperateManager shareManager].posOperate.couponCard;
}

#pragma mark - reload data
- (void)reloadData
{
    self.memberCards = self.member.card.array;
    self.memberCoupons = self.member.coupons.array;
    [self.tableView reloadData];
}


#pragma mark - sendRequest
- (void)sendRequest
{
    NSMutableArray *cardIds = [NSMutableArray array];
    NSMutableArray *couponIds = [NSMutableArray array];
    for (CDMemberCard * memberCard in self.member.card.array) {
        [cardIds addObject:memberCard.cardID];
    }
    
    for (CDCouponCard *couponCard in self.member.coupons.array) {
        [couponIds addObject:couponCard.cardID];
    }
    
    if (cardIds.count > 0)
    {
        BSFetchMemberCardRequest *memberRequest = [[BSFetchMemberCardRequest alloc] initWithMemberCardIds:cardIds];
        [memberRequest execute];
    }
    
    if (couponIds.count > 0)
    {
        BSFetchCouponCardRequest *couponRequest = [[BSFetchCouponCardRequest alloc] initWithCouponCardIds:couponIds];
        [couponRequest execute];
    }

}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [self reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSection_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSection_card) {
        return self.memberCards.count;
    }
    else if (section == kSection_coupon)
    {
        return self.memberCoupons.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    SelectedCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectedCardCell"];
    if (cell == nil) {
        cell = [SelectedCardCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.circleImgView.highlighted = false;
    if (section == kSection_card) {
        CDMemberCard *card = [self.memberCards objectAtIndex:row];
       
        cell.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",card.priceList.name,card.cardNo];
        cell.moneyLabel.text = [NSString stringWithFormat:@"余额￥%.2f 积分:%.2f",card.amount.floatValue,card.points.floatValue];
        
        if (card.arrearsAmount.floatValue > 0) {
            cell.arrearLabel.text = [NSString stringWithFormat:@"欠款¥%.2f",card.arrearsAmount.floatValue];
        }
        else
        {
            cell.arrearLabel.text = @"";
        }
        NSInteger count = 0;
        for (CDMemberCardProject *cardProject in card.projects.array) {
            if (cardProject.remainQty.integerValue > 0) {
                count ++;
            }
        }
        cell.countLabel.text = [NSString stringWithFormat:@"卡内可用项目%d个",count];
        cell.stateView.hidden = YES;
        if (card.state.integerValue != kPadMemberCardStateActive)
        {
            cell.stateView.hidden = NO;
            if (card.state.integerValue == kPadMemberCardStateDraft)
            {
                cell.stateLabel.text = LS(@"PadMemberCardStateDraft");
            }
            else if (card.state.integerValue == kPadMemberCardStateLost)
            {
                cell.stateLabel.text = LS(@"PadMemberCardStateLost");
            }
            else if (card.state.integerValue == kPadMemberCardStateReplacement)
            {
                cell.stateLabel.text = LS(@"PadMemberCardStateReplacement");
            }
            else if (card.state.integerValue == kPadMemberCardStateMerger)
            {
                cell.stateLabel.text = LS(@"PadMemberCardStateMerger");
            }
            else if (card.state.integerValue == kPadMemberCardStateUnlink)
            {
                cell.stateLabel.text = LS(@"PadMemberCardStateUnlink");
            }
        }
        else if ( [card.isInvalid boolValue] )
        {
            cell.stateView.hidden = NO;
            cell.stateLabel.text = @"已过期";
        }

        
        if (self.currentSelectedCard.cardID.integerValue == card.cardID.integerValue) {
            cell.circleImgView.highlighted = true;
        }
        
    }
    else if (section == kSection_coupon)
    {
        CDCouponCard *coupon = [self.memberCoupons objectAtIndex:row];
        
        cell.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",coupon.cardName,coupon.cardNumber];
        cell.moneyLabel.text = [NSString stringWithFormat:@"余额￥%.2f",coupon.amount.floatValue];
        cell.arrearLabel.text = @"";
        NSInteger count = 0;
        for (CDCouponCardProduct *couponProduct in coupon.products.array) {
            if (couponProduct.remainQty.integerValue > 0) {
                count ++;
            }
        }

        cell.countLabel.text = [NSString stringWithFormat:@"券内可用项目%d个",coupon.courseRemainQty.integerValue];
        if (self.currentSelectedCoupon.cardID.integerValue == coupon.cardID.integerValue) {
            cell.circleImgView.highlighted = true;
        }
        
        if (coupon.isInvalid.boolValue) {
            cell.stateView.hidden = false;
            cell.stateLabel.text = @"已失效";
        }
        else
        {
            cell.stateView.hidden = true;
        }
        
    }
//    if (self.currentSelectedIndexPath && self.currentSelectedIndexPath.section == section && self.currentSelectedIndexPath.row == row) {
//        cell.circleImgView.highlighted = true;
//    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == kSection_card && self.memberCards.count > 0) {
        return 40;
    }
    if (section == kSection_coupon && self.memberCoupons.count > 0) {
        return 40;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = COLOR(245, 245, 245, 1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, (40 - 20)/2.0, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor grayColor];
    [view addSubview:label];
    if (section == kSection_card) {
        label.text = @"会员卡";
    }
    else if (section == kSection_coupon)
    {
        label.text = @"优惠券";
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.currentSelectedIndexPath = indexPath;
    
    if (indexPath.section == kSection_card) {
        CDMemberCard *card = [self.memberCards objectAtIndex:indexPath.row];
        if (self.currentSelectedCard.cardID.integerValue == card.cardID.integerValue) {
            self.currentSelectedCard = nil;
        }
        else
        {
            self.currentSelectedCard = card;
        }
    }
    else if (indexPath.section == kSection_coupon)
    {
        CDCouponCard *coupon = [self.memberCoupons objectAtIndex:indexPath.row];
        if (self.currentSelectedCoupon.cardID.integerValue == coupon.cardID.integerValue) {
            self.currentSelectedCoupon = nil;
        }
        else
        {
            self.currentSelectedCoupon = coupon;
        }
        
    }
    [tableView reloadData];
}

#pragma mark - btn action
- (IBAction)sureBtnPressed:(id)sender {
    
    if (self.currentSelectedCard) {
        [OperateManager shareManager].memberCard = self.currentSelectedCard;
    }
    
    if(self.currentSelectedCoupon)
    {
        [OperateManager shareManager].couponCard = self.currentSelectedCoupon;
    }

    if (self.isPopDismiss) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kChangeMemberAndCard" object:nil];
    }
    else
    {
        ProductProjectMainController *projectMainVC = [[ProductProjectMainController alloc] init];
        projectMainVC.controllerType = ProductControllerType_Sale;
        projectMainVC.card = self.currentSelectedCard;
        projectMainVC.coupon = self.currentSelectedCoupon;
        
        [self.navigationController pushViewController:projectMainVC animated:YES];
    }
}



#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
