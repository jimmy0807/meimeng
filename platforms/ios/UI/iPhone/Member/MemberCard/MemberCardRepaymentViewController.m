//
//  MemberCardRepaymentViewController.m
//  Boss
//  还款
//  Created by lining on 16/6/17.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardRepaymentViewController.h"
#import "BSFetchMemberCardArrearsRequest.h"
#import "CardRepaymentCell.h"
#import "MemberCardPayModeViewController.h"

@interface MemberCardRepaymentViewController ()
@property (nonatomic, strong) NSMutableArray *arrears;
@property (nonatomic, strong) NSMutableDictionary *selectedItemDict;

@end

@implementation MemberCardRepaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"还款";
    
    self.sureBtn.enabled = false;
    self.selectedItemDict = [NSMutableDictionary dictionary];
    
    BSFetchMemberCardArrearsRequest *arrearsRequest = [[BSFetchMemberCardArrearsRequest alloc] initWithMemberCardID:self.memberCard.cardID];
    [arrearsRequest execute];
    [self registerNofitificationForMainThread:kBSFetchMemberCardArrearsResponse];
    
    [self reloadData];
}

#pragma mark - init data
- (void)reloadData
{
    self.arrears = [NSMutableArray array];
    for (CDMemberCardArrears *arrear in self.memberCard.arrears)
    {
        if (arrear.unRepaymentAmount.floatValue != 0)
        {
            [self.arrears addObject:arrear];
        }
        
    }
    [self.tableView reloadData];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrears.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardRepaymentCell *repaymentCell = [tableView dequeueReusableCellWithIdentifier:@"CardRepaymentCell"];
    if (repaymentCell == nil) {
        repaymentCell = [CardRepaymentCell createCell];
        repaymentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CDMemberCardArrears *arrear = [self.arrears objectAtIndex:indexPath.row];
   
    repaymentCell.titleLabel.text = LS(arrear.arrearsType);
    repaymentCell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",arrear.unRepaymentAmount.floatValue];
    repaymentCell.detailLabel.text = arrear.operateName;
    repaymentCell.dateLabel.text = [arrear.createDate substringToIndex:10];
    
    if ([self.selectedItemDict objectForKey:arrear.arrearsID]) {
        repaymentCell.selectedImgView.highlighted = true;
    }
    else
    {
        repaymentCell.selectedImgView.highlighted = false;
    }
    return repaymentCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    CDMemberCardArrears *arrear = [self.arrears objectAtIndex:indexPath.row];
    CDMemberCardArrears *selectedArrear = [self.selectedItemDict objectForKey:arrear.arrearsID];
    if (selectedArrear == nil) {
        [self.selectedItemDict setObject:arrear forKey:arrear.arrearsID];
    }
    else
    {
        [self.selectedItemDict removeObjectForKey:arrear.arrearsID];
    }
    
    if (self.selectedItemDict.allValues.count > 0) {
        self.sureBtn.enabled = true;
    }
    else
    {
        self.sureBtn.enabled = false;
    }
    
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - button action
- (IBAction)sureBtnPressed:(id)sender {
    MemberCardPayModeViewController  *payModeVC = [[MemberCardPayModeViewController alloc] init];
    payModeVC.card = self.memberCard;
    payModeVC.arrears = self.selectedItemDict.allValues;
//    payModeVC.expectMoney =
    for (CDMemberCardArrears *arrear in payModeVC.arrears) {
        NSLog(@"%.2f",arrear.unRepaymentAmount.floatValue);
        payModeVC.expectMoney += arrear.unRepaymentAmount.floatValue;
    }
    payModeVC.operateType = kPadMemberCardOperateRepayment;
    [self.navigationController pushViewController:payModeVC animated:YES];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
