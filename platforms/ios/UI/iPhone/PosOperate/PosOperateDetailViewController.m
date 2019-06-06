//
//  PosOperateDetailViewController.m
//  Boss
//
//  Created by lining on 16/8/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateDetailViewController.h"
#import "PosOperateInfoCell.h"
#import "PosOperateItemCell.h"
#import "PosOperateProductCell.h"
#import "BSFetchPosProductRequest.h"
#import "BSFetchPosPayInfoRequest.h"
#import "BSFetchPosConsumProduct.h"
#import "BSFetchPosCouponRequest.h"
#import "BSFetchPosCommissionRequest.h"
#import "CBMessageView.h"
#import "PosOperateAssignViewController.h"
#import "PhoneGiveViewController.h"
#import "BSFetchPosOperateRequest.h"
#import "CBLoadingView.h"
#import "BSPrintPosOperateRequest.h"
#import "BSFetchMemberDetailRequest.h"

typedef enum kSection
{
    kSection_Detail,
    kSection_PayInfo,
    kSection_Product,
    kSection_num
}kSection;

@interface PosOperateDetailViewController ()
{
    NSInteger requestCount;
}
@property(nonatomic, strong) NSArray *posProducts;
@property(nonatomic, strong) NSArray *consumeProducts;
@property(nonatomic, strong) NSArray *couponProducts;

@property(nonatomic, strong) NSArray *payInfos;
@property(nonatomic, strong) NSMutableArray *products;
@end

@implementation PosOperateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.title = @"单据详情";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PosOperateInfoCell" bundle:nil] forCellReuseIdentifier:@"PosOperateInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PosOperateItemCell" bundle:nil] forCellReuseIdentifier:@"PosOperateItemCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PosOperateProductCell" bundle:nil] forCellReuseIdentifier:@"PosOperateProductCell"];

    [self registerNofitificationForMainThread:kFetchPosPayInfoResponse];
    [self registerNofitificationForMainThread:kFetchPosOperateProductResponse];
    [self registerNofitificationForMainThread:kFetchPosConsumeProductResponse];
    [self registerNofitificationForMainThread:kPosCouponProductResponse];
    
    [self registerNofitificationForMainThread:kFetchPosCommissionResponse];
    
    [self registerNofitificationForMainThread:kPosAssigncommissionResponse];
    
    [self registerNofitificationForMainThread:kPosProductCategoryResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberDetailResponse];
    if (self.operate) {
        [self sendRequest];
    }
    else if (self.operateID)
    {
        NSLog(@"operateID: %@",self.operateID);
        [self registerNofitificationForMainThread:kFetchPosCardOperateResponse];
        
        BSFetchPosOperateRequest *reqeust = [[BSFetchPosOperateRequest alloc] init];
        reqeust.operateID = self.operateID;
        [reqeust execute];
        [[CBLoadingView shareLoadingView] show];
        
    }
    [self reloadData];
}

#pragma mark - reload data
- (void)reloadData
{
    self.payInfos = self.operate.payInfos.array;

    self.posProducts = [[BSCoreDataManager currentManager] fetchPosProductsWithOperate:self.operate];
    self.consumeProducts = [[BSCoreDataManager currentManager] fetchConsumeProductsInCardWithOperate:self.operate];
    self.couponProducts = [[BSCoreDataManager currentManager] fetchPosCouponProductsWithOPerate:self.operate];
    
    
    self.products = [NSMutableArray array];
    [self.products addObjectsFromArray:self.posProducts];
    [self.products addObjectsFromArray:self.consumeProducts];
    
    [self.products addObjectsFromArray:self.couponProducts];
    
    [self.tableView reloadData];
}

#pragma mark - CBBackButtonItemDelegate
-(void)didItemBackButtonPressed:(UIButton*)sender
{
    if (self.isFromSuccessView) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - send reqeust
- (void)sendRequest
{
    //一般消费产品
    [[[BSFetchPosProductRequest alloc] initWithPosOperate:self.operate] execute];
    requestCount ++;
    
    //付款方式信息
    [[[BSFetchPosPayInfoRequest alloc] initWithPosOperate:self.operate
      ] execute];
    requestCount ++;
    
    //会员卡内消费项目
    [[[BSFetchPosConsumProduct alloc] initWithPosOperate:self.operate] execute];
    requestCount ++;
    
    //优惠券消费项目
    [[[BSFetchPosCouponRequest alloc] initWithPosOperate:self.operate] execute];
    requestCount ++;
    
    //业绩分配
    [[[BSFetchPosCommissionRequest alloc] initWithPosOperate:self.operate] execute];
    requestCount ++;
    
    //会员信息
    [[[BSFetchMemberDetailRequest alloc] initWithMember:self.operate.member] execute];
    requestCount ++;
    
    [[CBLoadingView shareLoadingView] show];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    
    if ([notification.name isEqualToString:kPosAssigncommissionResponse])
    {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0)
        {
            [[[BSFetchPosCommissionRequest alloc] initWithPosOperate:self.operate] execute];
        }
        else
        {
//            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]];
//            [messageView show];
        }
    
        return;
    }
    if ([notification.name isEqualToString:kFetchPosCardOperateResponse]) {
        if (!self.operateID) {
            NSLog(@"!!!!!!");
            return;
        }
        self.operate = [[BSCoreDataManager currentManager] findEntity:@"CDPosOperate" withValue:self.operateID forKey:@"operate_id"];
        if (self.operate) {
            [self sendRequest];
        }
        else
        {
            [[CBLoadingView shareLoadingView] hide];
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"单据获取失败"];
            [messageView show];
        }

        return;
    }
    
    if ([notification.name isEqualToString:kPosProductCategoryResponse]) {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0)
        {
             [self.tableView reloadData];
        }
        return;
    }
        
    if ([notification.name isEqualToString:kFetchPosOperateProductResponse])
    {
        requestCount--;
    }
    else if ([notification.name isEqualToString:kFetchPosPayInfoResponse])
    {
        requestCount--;
    }
    else if ([notification.name isEqualToString:kFetchPosConsumeProductResponse])
    {
        requestCount--;
    }
    else if ([notification.name isEqualToString:kFetchPosCommissionResponse])
    {
        requestCount--;
    }
    else if ([notification.name isEqualToString:kPosCouponProductResponse])
    {
        requestCount--;
    }
    else if ([notification.name isEqualToString:kBSFetchMemberDetailResponse])
    {
        requestCount--;
    }
    
    if (requestCount <= 0)
    {
        [[CBLoadingView shareLoadingView] hide];
        [self reloadData];
    }
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSection_num;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSection_Detail) {
        return 2;
    }
    else if (section == kSection_PayInfo)
    {
        if (self.payInfos.count > 0) {
            return self.payInfos.count + 1;
        }
        return 0;
    }
    else
    {
        if (self.products.count > 0) {
            return self.products.count + 1;
        }
        return 0;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kSection_Detail) {
        if (row == 0) {
            PosOperateInfoCell *infoCell =  [tableView dequeueReusableCellWithIdentifier:@"PosOperateInfoCell"];
            if ([self.operate.type isEqualToString:@"消费"]) {
                infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            infoCell.operate = self.operate;
            return infoCell;
        }
        else if (row == 1)
        {
            PosOperateItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateItemCell"];
            itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            itemCell.nameLabel.font = [UIFont systemFontOfSize:13.0f];
            itemCell.valueLabel.font = [UIFont systemFontOfSize:13.0f];
            itemCell.nameLabel.textColor = [UIColor grayColor];
            itemCell.valueLabel.textColor = [UIColor grayColor];
            itemCell.lineImgView.hidden = true;
            itemCell.nameLabel.text = @"日期";
            itemCell.valueLabel.text = self.operate.operate_date;
            return itemCell;
        }
    }
    else if (section == kSection_PayInfo)
    {
        PosOperateItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateItemCell"];
        itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (row == 0) {
            itemCell.nameLabel.font = [UIFont systemFontOfSize:13.0f];
            itemCell.valueLabel.font = [UIFont systemFontOfSize:13.0f];
            itemCell.nameLabel.textColor = [UIColor grayColor];
            itemCell.valueLabel.textColor = [UIColor grayColor];
            
            itemCell.nameLabel.text = @"支付明细";
            itemCell.valueLabel.text = @"";
            
        }
        else
        {
            itemCell.nameLabel.font = [UIFont systemFontOfSize:15.0f];
            itemCell.valueLabel.font = [UIFont systemFontOfSize:15.0f];
            itemCell.nameLabel.textColor = COLOR(72, 72, 72, 1);
            itemCell.valueLabel.textColor = COLOR(72, 72, 72, 1);
            
            CDPosOperatePayInfo *payInfo = [self.payInfos objectAtIndex:row - 1];
            itemCell.nameLabel.text = payInfo.statement_name;
            itemCell.valueLabel.text = [NSString stringWithFormat:@"%.2f",[payInfo.pay_amount floatValue]];
        }
        
        itemCell.lineImgView.hidden = false;
        if (row == self.payInfos.count) {
            itemCell.lineImgView.hidden = true;
        }
        return itemCell;
    }
    else if (section == kSection_Product)
    {
        if (row == 0) {
            PosOperateItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateItemCell"];
            itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            itemCell.nameLabel.font = [UIFont systemFontOfSize:13.0f];
            itemCell.valueLabel.font = [UIFont systemFontOfSize:13.0f];
            itemCell.nameLabel.textColor = [UIColor grayColor];
            itemCell.valueLabel.textColor = [UIColor grayColor];
            
            itemCell.nameLabel.text = [NSString stringWithFormat:@"全部商品(%d)",self.products.count];
            itemCell.valueLabel.text = @"";
            return itemCell;
        }
        else
        {
            PosOperateProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateProductCell"];
            CDPosProduct *product = [self.products objectAtIndex:indexPath.row - 1];
            
            if ([self hasAssignCommission:product]) {
                cell.assignImgView.hidden = true;
            }
            else
            {
                cell.assignImgView.hidden = false;
            }
            cell.posProduct = product;
            
            return cell;
        }
    }

    return nil;
}

- (Boolean) hasAssignCommission:(CDPosBaseProduct *)posProduct
{
    for (CDPosCommission *commission in self.operate.commissions.array) {
        if ([commission.product_id integerValue] == [posProduct.product_id integerValue]) {
            return true;
        }
    }
    return false;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == kSection_Detail) {
        if (row == 0) {
            return 170;
        }
        else
        {
            return 40;
        }
    }
    else if (section == kSection_PayInfo)
    {
        if (row == 0)
        {
            return 40;
        }
        else
        {
            return 50;
        }
    }
    else if (section == kSection_Product)
    {
        if (row == 0)
        {
            return 40;
        }
        else
        {
            return 142;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.backgroundColor = [UIColor clearColor];
    return imgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kSection_Detail) {
        if (row == 0 && ![self.operate.type isEqualToString:@"消费"]) {
            PosOperateAssignViewController *assignVC = [[PosOperateAssignViewController alloc] init];
            assignVC.operate = self.operate;
            [self.navigationController pushViewController:assignVC animated:YES];
        }
    }
    if (section == kSection_Product) {
        if (row > 0) {
            CDPosProduct *product = [self.products objectAtIndex:indexPath.row - 1];
            
            PosOperateAssignViewController *assignVC = [[PosOperateAssignViewController alloc] init];
            assignVC.product = product;
            assignVC.operate = self.operate;
            [self.navigationController pushViewController:assignVC animated:YES];
        }
    }
}

#pragma mark - btn action
- (IBAction)printBtnPressed:(id)sender {
    NSLog(@"打印小票");
    [[BSPrintPosOperateRequest alloc] printWithPosOperateID:self.operate.operate_id];
}

- (IBAction)giveBtnPressed:(id)sender {
    if (self.operate.member.isDefaultCustomer.boolValue) {
        [[[CBMessageView alloc] initWithTitle:@"散客无法赠送优惠券"] show];
        return;
    }
    PhoneGiveViewController *phoneGiveVC = [[PhoneGiveViewController alloc] init];
    phoneGiveVC.operate = self.operate;
    [self.navigationController pushViewController:phoneGiveVC animated:YES];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
