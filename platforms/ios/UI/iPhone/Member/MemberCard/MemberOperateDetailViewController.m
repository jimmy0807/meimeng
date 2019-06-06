//
//  MemberOperateDetailViewController.m
//  Boss
//
//  Created by lining on 16/5/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberOperateDetailViewController.h"
#import "BSFetchPosProductRequest.h"
#import "BSFetchPosConsumProduct.h"
#import "BSFetchPosCouponRequest.h"
#import "BSFetchPosPayInfoRequest.h"
#import "OperateHeadCell.h"
#import "OperateProductCell.h"
#import "PayCell.h"
#import "OperateTotalCell.h"

typedef enum Operate_Section
{
    Section_Head,       //头
    Section_Product,    //商品明细
    Section_PayStyle,   //支付方式
    Section_Num
}Operate_Section;

typedef enum SectionInfo
{
    SectionInfo_Name,
    SectionInfo_Card,
    SectionInfo_Discount,
    SectionInfo_Operator,
    SectionInfo_Shop,
    SectionInfo_Num
}SectionInfo;

@interface MemberOperateDetailViewController ()
{
    NSInteger requestCount;
}

@property (nonatomic, strong) NSArray *posProducts;
@property (nonatomic, strong) NSArray *consumeProducts;
@property (nonatomic, strong) NSArray *couponProducts;
@property (nonatomic, strong) NSArray *payInfos;

@end

@implementation MemberOperateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.title = [[BSCoreDataManager currentManager] operateType:self.operate.type];
    
    [self registerNofitificationForMainThread:kBSFetchMemberCardOperateResponse];
    [self registerNofitificationForMainThread:kFetchPosOperateProductResponse];
    [self registerNofitificationForMainThread:kFetchPosPayInfoResponse];
    [self registerNofitificationForMainThread:kFetchPosConsumeProductResponse];
    [self registerNofitificationForMainThread:kPosCouponProductResponse];
    
    
    [self sendRequest];
    
    [self reloadData];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, 20)];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = view;
}

- (void)refreshOperate
{
    self.operate = [[BSCoreDataManager currentManager] findEntity:@"CDPosOperate" withValue:self.operateID forKey:@"operate_id"];
    [self sendRequest];
    self.title = [[BSCoreDataManager currentManager] operateType:self.operate.type];
    
}

- (void)reloadData
{
    
    self.posProducts = [[BSCoreDataManager currentManager] fetchPosProductsWithOperate:self.operate];
    self.consumeProducts = [[BSCoreDataManager currentManager] fetchConsumeProductsInCardWithOperate:self.operate];
    self.couponProducts = [[BSCoreDataManager currentManager] fetchPosCouponProductsWithOPerate:self.operate];
    
    self.payInfos = self.operate.payInfos.array;
    
    [self.tableView reloadData];
}

#pragma mark - send request
- (void)sendRequest
{
    if (self.operate == nil) {
        return;
    }
    
    //一般消费产品
    [[[BSFetchPosProductRequest alloc] initWithPosOperate:self.operate] execute];
    requestCount ++;
    
    //会员卡内消费项目
    [[[BSFetchPosConsumProduct alloc] initWithPosOperate:self.operate] execute];
    requestCount ++;
    
    
    //优惠券消费项目
    [[[BSFetchPosCouponRequest alloc] initWithPosOperate:self.operate] execute];
    requestCount ++;
    
    //付款方式信息
    [[[BSFetchPosPayInfoRequest alloc] initWithPosOperate:self.operate
      ] execute];
    requestCount ++;
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberCardOperateResponse]) {
        [self refreshOperate];
        return;
    }
    
    requestCount --;
    if (requestCount == 0) {
        [self reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return Section_Num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == Section_Head) {
        return SectionInfo_Num;
    }
    else if (section == Section_Product)
    {
        return self.posProducts.count + self.consumeProducts.count + self.couponProducts.count;
    }
    else if (section == Section_PayStyle)
    {
        if (self.payInfos.count > 0) {
            return self.payInfos.count + 1;
        }
        else
        {
            return 0;
        }
//        return self.payInfos.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == Section_Head) {
        OperateHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"OperateHeadCell"];
        if (headCell == nil) {
            headCell = [OperateHeadCell createCell];
            headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (row == SectionInfo_Name) {
            headCell.nameLabel.text = @"单据号";
            headCell.valueLabel.text = self.operate.name;
        }
        else if (row == SectionInfo_Card)
        {
            headCell.nameLabel.text = @"会员卡";
            headCell.valueLabel.text = self.operate.card_name;
        }
        else if (row == SectionInfo_Discount)
        {
            headCell.nameLabel.text = @"会员卡折扣方案";
            headCell.valueLabel.text = self.operate.pricelist_name;
        }
        else if (row == SectionInfo_Operator)
        {
            headCell.nameLabel.text = @"操作人";
            headCell.valueLabel.text = self.operate.operate_user_name;
        }
        else if (row == SectionInfo_Shop)
        {
            headCell.nameLabel.text = @"操作卡的门店";
            headCell.valueLabel.text = self.operate.operate_shop_name;
        }
        return headCell;
    }
    else if (section == Section_Product)
    {
        OperateProductCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"OperateProductCell"];
        if (productCell == nil) {
            productCell = [OperateProductCell createCell];
            productCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        CDPosBaseProduct *posProduct;
        if (row < self.posProducts.count) {
            posProduct = self.posProducts[row];
        
        }
        else if (row < self.posProducts.count + self.consumeProducts.count)
        {
            NSInteger idx = row - self.posProducts.count;
            posProduct = self.consumeProducts[idx];
            
        }
        else if (row < self.posProducts.count + self.consumeProducts.count + self.couponProducts.count)
        {
            NSInteger idx = row - self.posProducts.count - self.consumeProducts.count;
            posProduct = self.couponProducts[idx];
        }
        productCell.posProduct = posProduct;
        return productCell;
    }
    else if (section == Section_PayStyle)
    {
        if (row < self.payInfos.count) {
            PayCell *payCell = [tableView dequeueReusableCellWithIdentifier:@"PayCell"];
            if (payCell == nil) {
                payCell = [PayCell createCell];
                payCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            CDPosOperatePayInfo *payInfo = self.payInfos[row];
            payCell.payLabel.text = payInfo.journal_name;
            payCell.payMoney.text = [NSString stringWithFormat:@"￥%.2f",[payInfo.pay_amount floatValue]];
            return payCell;
        }
        else
        {
            OperateTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OperateTotalCell"];
            if (cell == nil) {
                cell = [OperateTotalCell createCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.operate.nowAmount floatValue]];
            return cell;
        }
        
    }
    return nil;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == Section_Head) {
        if (row == SectionInfo_Num - 1) {
            return 50;
        }
        else
        {
            return 30;
        }
    }
    else if (section == Section_Product)
    {
        return 75;
    }
    else if (section == Section_PayStyle)
    {
//        if (row < self.payInfos.count) {
//            return 44;
//        }
        return 44;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == Section_Head) {
        return 30;
    }
    else if (section == Section_Product) {
        if (self.couponProducts.count + self.posProducts.count + self.consumeProducts.count > 0) {
            return 30;
        }
        else
        {
            return 0;
        }
    }
    else if (section == Section_PayStyle)
    {
        if (self.payInfos.count > 0) {
            return 30;
        }
        else
        {
            return 0;
        }
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = COLOR(245, 245, 245, 1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 100, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12.0];
    if (section == Section_Head) {
        label.text = @"基本信息";
    }
    else if (section == Section_Product) {
        label.text = @"商品明细";
    }
    else if (section == Section_PayStyle)
    {
        label.text = @"付款明细";
    }
    [view addSubview:label];
    return view;
}

#pragma mark - Memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
