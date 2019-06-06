//
//  MemberCardAmountDetailViewController.m
//  Boss
//
//  Created by lining on 16/5/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardAmountDetailViewController.h"
#import "BSFetchCardAmountsRequest.h"
#import "MemberCardAmountDataSource.h"
#import "MemberRecordDetailViewController.h"


@interface MemberCardAmountDetailViewController ()<MemberRecordDataSourceProtocol>
@property (nonatomic, strong) MemberCardAmountDataSource *dataSource;
@end

@implementation MemberCardAmountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = [NSString stringWithFormat:@"￥%.2f",[self.card.amount floatValue]];
    
    [self registerNofitificationForMainThread:kBSFetchMemberCardAmountResponse];
    
    self.dataSource = [[MemberCardAmountDataSource alloc] init];
    self.dataSource.delegate = self;
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    
//    dataSource.tag = title;
//    [self.dataSourceDict setObject:dataSource forKey:title];
    [self reloadData];
    [self sendRequest];
    
}
#pragma mark - reload data
- (void)reloadData
{
//    NSArray *amounts = self.card.amounts.array;
    
    NSArray *amounts = [self fetchCardAmounts];
    self.dataSource.amounts = amounts;
    
    [self.tableView reloadData];
}

- (NSArray *)fetchCardAmounts
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"card.cardID = %@ && card_amount != 0",self.card.cardID];
    
    //    CDMemberCardAmount
    NSArray *amounts = [[BSCoreDataManager currentManager] fetchItems:@"CDMemberCardAmount" sortedByKey:@"amount_id" ascending:true predicate:predicate];
    return amounts;
}

#pragma mark - send request
- (void)sendRequest
{
    BSFetchCardAmountsRequest *amountRequest = [[BSFetchCardAmountsRequest alloc] initWithCardID:self.card.cardID];
    [amountRequest execute];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [self reloadData];
}

#pragma mark - MemberRecordDataSourceProtocol
- (void)didItemSelectedwithType:(NSString *)type atIndexPath:(NSIndexPath *)indexPath
{
    CDMemberCardAmount *amount = [self.dataSource.amounts objectAtIndex:indexPath.row];
    NSArray *sectionArray = @[@[@{@"单据编号":amount.operate_name},@{@"类型":[[BSCoreDataManager currentManager] operateType:amount.type]},@{@"支付方式":amount.journal_name},@{@"金额":amount.amount},@{@"积分":amount.point},@{@"会员卡内金额变动":amount.card_amount}]
                     ];
    MemberRecordDetailViewController *detailVC = [[MemberRecordDetailViewController alloc] init];
    detailVC.sectionArray = sectionArray;
    detailVC.title = @"金额变动";
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
