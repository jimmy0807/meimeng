//
//  MemberCouponProductViewController.m
//  Boss
//
//  Created by lining on 16/8/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCouponProductViewController.h"
#import "CardProjectCell.h"
#import "CBMessageView.h"
#import "BSFetchCouponCardProductRequest.h"

@interface MemberCouponProductViewController ()
//<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *couponProducts;

@end

@implementation MemberCouponProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.title = @"优惠券内项目";
    
    [self registerNofitificationForMainThread:kBSFetchCouponCardProductResponse];
    [self reloadData];
    
    [self registerNofitificationForMainThread:kBSFetchCouponCardProductResponse];
    BSFetchCouponCardProductRequest *request = [[BSFetchCouponCardProductRequest alloc] initWithCouponCardId:self.couponCard.cardID];
    [request execute];
    
}


#pragma mark - reload data
- (void)reloadData
{
    self.couponProducts = self.couponCard.products.array;
    [self.tableView reloadData];
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchCouponCardProductResponse]) {
        //        [[CBLoadingView shareLoadingView] hide];
        int ret = [[notification.userInfo numberValueForKey:@"rc"] integerValue];
        if (ret == 0) {
            [self reloadData];
        }
        else
        {
            NSString *errorMsg = [notification.userInfo stringValueForKey:@"rm"];
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:errorMsg];
            [messageView show];
        }
    }

}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardProjectCell"];
    if (cell == nil) {
        cell = [CardProjectCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.arrowImgHidden = true;
    CDCouponCardProduct *couponProduct = [self.couponProducts objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = couponProduct.productName;
    cell.dateLabel.text = [NSString stringWithFormat:@"￥%.2f",couponProduct.unitPrice];
    cell.priceLabel.text = @"";
    cell.countLabel.text = [NSString stringWithFormat:@"%@/%@次",couponProduct.remainQty,couponProduct.purchaseQty];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
