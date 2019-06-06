//
//  PosOperateAssignViewController.m
//  Boss
//
//  Created by lining on 16/9/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateAssignViewController.h"
#import "PosOperateAssignDetailViewController.h"
#import "BSPosAssignCommissionRequest.h"
#import "PosOperateItemCell.h"
#import "PosOperateAddCell.h"
#import "AllotObject.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "CancelItemArrowCell.h"
#import "BSFetchStaffRequest.h"
#import "BSFetchCommissionRuleRequest.h"

typedef enum KSeciton
{
    KSection_sale,
    KSection_technician,
    KSection_num
}KSeciton;
@interface PosOperateAssignViewController ()<PosOperateAssignDetailVCDelegate,CancelItemArrowCellDelegate>
{
    NSInteger requestCount;
}
@property (nonatomic, strong) NSMutableArray *saleArray;
@property (nonatomic, strong) NSMutableArray *techArray;

@property (nonatomic, strong) NSMutableArray *deleteItems;
@property(nonatomic, assign) float commissionRadio;//分配比例 成交价/原价

@end

@implementation PosOperateAssignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.title = @"分配业绩";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CancelItemArrowCell" bundle:nil] forCellReuseIdentifier:@"CancelItemArrowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PosOperateAddCell" bundle:nil] forCellReuseIdentifier:@"PosOperateAddCell"];
    
    self.deleteItems = [NSMutableArray array];
    [self reloadData];
    
    [self fetchRequest];
    
    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self registerNofitificationForMainThread:kFetchCommissionRuleResponse];
    
    [self registerNofitificationForMainThread:kPosAssigncommissionResponse];
    [self registerNofitificationForMainThread:kFetchPosCommissionResponse];
    
    if (self.product) {
        self.commissionRadio = self.product.money_total.floatValue/(self.product.product_qty.integerValue * self.product.product_price.floatValue);
    }
    else
    {
        self.commissionRadio = 1;
    }
}

#pragma mark - FetchReqeust
- (void)fetchRequest
{
//    BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
//    [request execute];
//    requestCount++;
    
    BSFetchCommissionRuleRequest *ruleRequest = [[BSFetchCommissionRuleRequest alloc] init];
    [ruleRequest execute];
    requestCount++;
    
    [[CBLoadingView shareLoadingView] show];
}


#pragma mark - receivedNotificattion
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchStaffResponse] || [notification.name isEqualToString:kFetchCommissionRuleResponse]) {
        requestCount--;
        if (requestCount <= 0) {
            [[CBLoadingView shareLoadingView] hide];
        }
    }
    
    if ([notification.name isEqualToString:kPosAssigncommissionResponse]) {
        [[CBLoadingView shareLoadingView] hide];
        NSNumber *ret = [notification.userInfo numberValueForKey:@"rc"];
        if (ret.integerValue == 0) {
            [[[CBMessageView alloc] initWithTitle:@"业绩分配成功"] show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:@"业绩分配失败，请稍后重试"] show];
        }
    }
    else if ([notification.name isEqualToString:kFetchPosCommissionResponse])
    {
        NSNumber *ret = [notification.userInfo numberValueForKey:@"rc"];
        if (ret.integerValue == 0) {
            
            [self reloadData];
        }
    }
}



#pragma mark - reloadData
- (void)reloadData
{
    NSArray *commissions = [[BSCoreDataManager currentManager] fetchPosCommissionWithOperateID:self.operate.operate_id productID:self.product.product_id];
    
    self.saleArray = [NSMutableArray array];
    self.techArray = [NSMutableArray array];

    for (CDPosCommission *commission in commissions) {
        AllotObject *allotObj = [[AllotObject alloc] init];
        allotObj.commission = commission;
        allotObj.employee_id = commission.employee_id;
        allotObj.employee_name = commission.employee_name;
        allotObj.rule_id = commission.rule_id;
        allotObj.rule_name = commission.rule_name;
//        allotObj.count = commission.point_count;
        allotObj.gift = commission.gift.boolValue;
        allotObj.giftCount = commission.gift_count;
        allotObj.money = commission.base_amount;
        allotObj.is_dian_dan = commission.is_dian_dan;
        if ([commission.sale_or_do isEqualToString:@"sale"]) {
            [self.saleArray addObject:allotObj];
        }
        else if ([commission.sale_or_do isEqualToString:@"do"])
        {
            if ([commission.is_dian_dan boolValue]) {
                allotObj.techType = @"点单";
            }
            else
            {
                allotObj.techType = @"轮单";
            }
            [self.techArray addObject:allotObj];
        }
    }
    
    [self.tableView reloadData];
}



#pragma mark - getNotAssignMoney
- (CGFloat)getSaleNotAssignMoney
{
    CGFloat assignMoney = 0;
    //"sale_price 成交价"  "open_price"原价
    for (AllotObject *allotObj in self.saleArray) {
        if ([allotObj.staff.commissionRule.sale_price_sel isEqualToString:@"sale_price"]) {
            assignMoney += [allotObj.money floatValue];
        }
        else
        {
            assignMoney += [allotObj.money floatValue] * self.commissionRadio;
        }
        
    }
    CGFloat sumMoney;
    if (self.product) {
        sumMoney = [self.product.money_total floatValue];
    }
    else
    {
        sumMoney = [self.operate.amount floatValue];
    }
    return sumMoney - assignMoney;
}

- (CGFloat)getTechNotAssignMoney
{
    CGFloat assignMoney = 0;
    for (AllotObject *allotObj in self.techArray) {
        if ([allotObj.commissionRule.sale_price_sel isEqualToString:@"sale_price"]) {
            assignMoney += [allotObj.money floatValue];
        }
        else
        {
            assignMoney += [allotObj.money floatValue] * self.commissionRadio;
        }
    }
    
    CGFloat sumMoney;
    if (self.product) {
        sumMoney = [self.product.money_total floatValue];
    }
    else
    {
        sumMoney = [self.operate.amount floatValue];
    }
    return sumMoney - assignMoney;
}


#pragma mark - getNotAssignCount

- (NSInteger)getSaleNotAssignCount
{
    NSInteger assignCount = 0;
    for (AllotObject *allotObj in self.saleArray) {
        assignCount += [allotObj.count integerValue];
    }
    return [self.product.product_qty integerValue] - assignCount;
}

- (NSInteger) getTechNotAssignCount
{
    NSInteger assignCount = 0;
    for (AllotObject *allotObj in self.techArray) {
        assignCount += [allotObj.count integerValue] + [allotObj.giftCount integerValue];
    }
    
    
    return [self.product.product_qty integerValue] - assignCount;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger category = [self.product.product.bornCategory integerValue];
    
    if (category == 2) //项目
    {
        return KSection_num;
    }
    else
    {
        return KSection_num - 1;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == KSection_sale)
    {
        return self.saleArray.count + 1;
    }
    else if (section == KSection_technician)
    {
        return self.techArray.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == KSection_sale) {
        if (row == self.saleArray.count) {
            PosOperateAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateAddCell"];
            
            return cell;
        }
        else
        {
            CancelItemArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CancelItemArrowCell"];
            AllotObject *allot = [self.saleArray objectAtIndex:row];
            cell.titleLabel.text = allot.employee_name;
            cell.middleLabel.text = @"";
            cell.valueLabel.text = [NSString stringWithFormat:@"%￥%.2f",allot.money.floatValue];
            cell.delegate = self;
            cell.indexPath = indexPath;
            return cell;
        }
    }
    else if (section == KSection_technician)
    {
        if (row == self.techArray.count) {
            PosOperateAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateAddCell"];
            
            return cell;
        }
        else
        {
            CancelItemArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CancelItemArrowCell"];
            AllotObject *allot = [self.techArray objectAtIndex:row];
            cell.titleLabel .text = allot.employee_name;
            cell.middleLabel.text = allot.techType;
            cell.valueLabel.text = [NSString stringWithFormat:@"%￥%.2f",allot.money.floatValue];
            cell.delegate = self;
            cell.indexPath = indexPath;
            return cell;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.backgroundColor = COLOR(245, 245, 245, 1);
    
    UILabel *label = [[UILabel alloc] init];
    [imgView addSubview:label];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.leading.offset(20);
    }];
    if (section == KSection_sale) {
        label.text = @"销售业绩";
    }
    else if(section == KSection_technician)
    {
        label.text = @"美疗师业绩";
    }
    return imgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    AllotObject * allotObject = nil;
    PeopleType peopleType = 0;
    
    
    if (section == KSection_sale) {
        if (row < self.saleArray.count) {
            allotObject = [self.saleArray objectAtIndex:row];
        }
        peopleType = PeopleType_Sale;
        
    }
    else if (section == KSection_technician)
    {
        if (row < self.techArray.count) {
            allotObject = [self.techArray objectAtIndex:row];
        }
        peopleType = PeopleType_Technician;
       
    }
    
    NSInteger notAssignCount = 0;
    CGFloat notAssignMoney = 0;
    
    if (peopleType == PeopleType_Sale) {
        notAssignCount = [self getSaleNotAssignCount];
        notAssignMoney = [self getSaleNotAssignMoney];
        
    }
    else if (peopleType == PeopleType_Technician)
    {
        notAssignCount = [self getTechNotAssignCount];
        notAssignMoney = [self getTechNotAssignMoney];
    }
    
    
    notAssignCount = notAssignCount + [allotObject.count integerValue];
    
    if ([allotObject.commissionRule.sale_price_sel isEqualToString:@"sale_price"]) {
        notAssignMoney = notAssignMoney + [allotObject.money floatValue];
    }
    else
    {
        notAssignMoney = notAssignMoney + [allotObject.money floatValue] *self.commissionRadio;
    }
    

    
    
    PosOperateAssignDetailViewController *assignDetailVC = [[PosOperateAssignDetailViewController alloc] init];
    assignDetailVC.delegate = self;
    assignDetailVC.product = self.product;
    assignDetailVC.peopleType = peopleType;
    assignDetailVC.allotObject = allotObject;
    assignDetailVC.maxAssignMoney = notAssignMoney;
    assignDetailVC.maxAssignCount = notAssignCount;
    assignDetailVC.commissionRadio = self.commissionRadio;
    
    [self.navigationController pushViewController:assignDetailVC animated:YES];
}

#pragma mark - PosOperateAssignDetailVCDelegate
- (void)didSureAllotObject:(AllotObject *)object type:(PeopleType)type edit:(BOOL)isEdit
{
    int section = 0;
    if (type == PeopleType_Sale) {
        if (!isEdit) {
            [self.saleArray addObject:object];
        }
        section = KSection_sale;
    }
    else if (type == PeopleType_Technician)
    {
        if (!isEdit) {
            [self.techArray addObject:object];
        }
        section = KSection_technician;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - CancelItemArrowCellDelegate
- (void)didCancelBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did delete at indexPath : %@",indexPath);
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == KSection_sale) {
        if (row < self.saleArray.count) {
            AllotObject *obj = [self.saleArray objectAtIndex:row];
            if (obj.commission) {
                [self.deleteItems addObject:obj];
            }
            [self.saleArray removeObjectAtIndex:row];
        }
    }
    else if (section == KSection_technician)
    {
        if (row < self.techArray.count) {
            AllotObject *obj = [self.techArray objectAtIndex:row];
            if (obj.commission) {
                [self.deleteItems addObject:obj];
            }
            [self.techArray removeObjectAtIndex:row];
        }
    }
    
    //    self.titleLabel.text = [NSString stringWithFormat:@"可分配业绩：%.2f",[self getNotAssignMoney]];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Request & Params
- (void) sendRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *paramsArray = [NSMutableArray array];
    
    [self assignParamsArray:paramsArray withDataArray:self.saleArray];
    [self assignParamsArray:paramsArray withDataArray:self.techArray];
    
    for (AllotObject *obj in self.deleteItems) {
        //删除
        NSArray *subArray = @[[NSNumber numberWithInteger:kBSDataDelete],obj.commission.commission_id,[NSNumber numberWithBool:false]];
        [paramsArray addObject:subArray];
    }
    
    params[@"commission_ids"] = paramsArray;
    
    BSPosAssignCommissionRequest *assignRequest = [[BSPosAssignCommissionRequest alloc] initWithPosOperate:self.operate params:params];
    [assignRequest execute];
    [[CBLoadingView shareLoadingView] show];
}


- (NSMutableArray *)assignParamsArray:(NSMutableArray *)paramsArray withDataArray:(NSArray *)dataAry
{
    for (AllotObject *obj in dataAry)
    {
        if (obj.commission == nil) //新建
        {
            NSMutableArray *subArray = [NSMutableArray array];
            [subArray addObject:[NSNumber numberWithInteger:kBSDataAdded]];
            [subArray addObject:[NSNumber numberWithBool:false]];
            
            NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
            subDict[@"product_id"] = self.product.product_id;
            subDict[@"price_unit"] = self.product.buy_price;
            subDict[@"gift"] = [NSNumber numberWithBool:obj.gift];
            subDict[@"gift_qty"] = obj.giftCount;
            subDict[@"employee_id"] = obj.employee_id;
            //            subDict[@"point"] = obj.count;
            subDict[@"base_amount"] = obj.money;
            subDict[@"discount_base_amount"] =  (self.product == nil) ? self.operate.amount:self.product.money_total;
            subDict[@"commission_rule_id"] = obj.rule_id;
            subDict[@"named"] = obj.is_dian_dan;
            if (obj.techType) {
                subDict[@"sale_or_do"] = @"do";
            }
            else
            {
                subDict[@"sale_or_do"] = @"sale";
            }
            
            [subArray addObject:subDict];
            
            [paramsArray addObject:subArray];
            
        }
        else
        {
            NSArray *subArray = [NSMutableArray array];
            NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
            if ([obj.commission.gift boolValue] != obj.gift)
            {
                subDict[@"gift"] = [NSNumber numberWithBool:obj.gift];
            }
            if (![obj.commission.gift_count isEqual:obj.giftCount]) {
                subDict[@"gift_qty"] = obj.giftCount;
            }
            
            if ([obj.commission.employee_id integerValue] != [obj.employee_id integerValue]) {
                subDict[@"employee_id"] = obj.employee_id;
            }
            
            if ([obj.commission.rule_id integerValue] != [obj.rule_id integerValue]) {
                subDict[@"commission_rule_id"] = obj.rule_id;
            }
            
            if ([obj.commission.point_count integerValue] != [obj.count integerValue]) {
                //                subDict[@"point"] = obj.count;
            }
            
            if ([obj.commission.base_amount floatValue] != [obj.money floatValue]) {
                subDict[@"base_amount"] = obj.money;
            }
            
            if ([obj.commission.is_dian_dan boolValue] != [obj.is_dian_dan boolValue])
            {
                subDict[@"named"] = obj.is_dian_dan;
            }
            
            if (subDict.allKeys.count > 0) {
                //编辑
                
                subArray = @[[NSNumber numberWithInteger:kBSDataUpdate],obj.commission.commission_id,subDict];
            }
            else
            {
                //不变
                subArray = @[[NSNumber numberWithInteger:kBSDataLinked],obj.commission.commission_id,[NSNumber numberWithBool:false]];
                
            }
            [paramsArray addObject:subArray];
        }
        
    }
    return paramsArray;
}

#pragma mark - btn action
- (IBAction)sureBtnPressed:(id)sender {
    [self sendRequest];
}



#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
