//
//  PosAlloctionViewController.m
//  Boss
//
//  Created by lining on 15/10/20.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PosAlloctionViewController.h"
#import "AllocationHeadView.h"
#import "AllocationCell.h"
#import "PosAlloctionGiveViewController.h"
#import "UIImage+Resizable.h"
#import "UIView+Frame.h"
#import "AllotObject.h"
#import "BSPosAssignCommissionRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "PosAllocationPersonViewController.h"


typedef enum KSection
{
    KSection_sale,
    KSection_technican,
    KSection_num,
    KSection_head,
}KSection;

@interface PosAlloctionViewController ()<AllocationHeadViewDelegate,AllocationCellDelegate,PosAlloctionPersonDelegate,PosAlloctionPersonDelegate,PosAllotGiveViewControllerDelegate>
{
    bool needGive; //是否赠送
    NSInteger giveCount; //赠送个数
//    NSInteger notAssignCount; //未分配个数
//    NSInteger notAssignMoney; //未分配金额
   
}
@property (nonatomic, strong) AllocationHeadView *headView;

@property (nonatomic, strong) NSMutableArray *saleArray;
@property (nonatomic, strong) NSMutableArray *techArray;

@property (nonatomic, strong) NSMutableArray *deleteItems;

@property(nonatomic, assign) float commissionRadio;//分配比例 成交价/原价

@end

@implementation PosAlloctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headView = [AllocationHeadView createView];
    self.headView.delegate = self;
//    self.tableView.tableHeaderView = headView;
    

    
    self.noKeyboardNotification = true;
    
    needGive = false;
    
    [self initData];
    
    self.deleteItems = [NSMutableArray array];
    
//    self.titleLabel.text = [NSString stringWithFormat:@"可分配业绩：%.2f",[self getNotAssignMoney]];
    self.titleLabel.text = @"分配业绩";
    
    if (self.product) {
        self.commissionRadio = self.product.money_total.floatValue/(self.product.product_qty.integerValue * self.product.product_price.floatValue);
    }
    else
    {
        self.commissionRadio = 1;
    }
    
    
    [self registerNofitificationForMainThread:kPosAssigncommissionResponse];
    [self registerNofitificationForMainThread:kFetchPosCommissionResponse];
    
}

- (void)initData
{
    self.saleArray = [NSMutableArray array];
    self.techArray = [NSMutableArray array];
    
    
    
    NSArray *commissions = [[BSCoreDataManager currentManager] fetchPosCommissionWithOperateID:self.operate.operate_id productID:self.product.product_id];
    if (commissions.count > 0) {
        CDPosCommission *posCommission = [commissions objectAtIndex:0];
        needGive = [posCommission.gift boolValue];
        giveCount = [posCommission.gift_count integerValue];
    }
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
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
            
            [self initData];
            [self.tableView reloadData];
        }
    }

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
    if (section == KSection_head) {
        if (needGive) {
            return 2;
        }
        else
        {
            return 1;
        }
        
    }
    else if (section == KSection_sale)
    {
        return self.saleArray.count + 1;
    }
    else if (section == KSection_technican)
    {
        return self.techArray.count + 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == KSection_head) {
        if (row == 0) {
            static NSString *identifier = @"identifier_row0";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 200, 57)];
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.font = [UIFont systemFontOfSize:17];
                nameLabel.text = @"选用赠送方案";
                nameLabel.tag = 101;
                [cell.contentView addSubview:nameLabel];
                
                
                UIImage *switch_img_n = [UIImage imageNamed:@"pos_switch_off.png"];
                UIImageView *switchImgView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width - switch_img_n.size.width - 20, (57 - switch_img_n.size.height)/2.0, switch_img_n.size.width, switch_img_n.size.height)];
                switchImgView.image = switch_img_n;
                switchImgView.highlightedImage = [UIImage imageNamed:@"pos_switch_on.png"];
                switchImgView.tag = 102;
                [cell.contentView addSubview:switchImgView];
                
                UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                switchBtn.frame = CGRectMake(tableView.frame.size.width - 80, 0, 80, 57);
                [switchBtn addTarget:self action:@selector(switchBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:switchBtn];
                
            }
            
            UIImageView *switchImgView = (UIImageView *)[cell.contentView viewWithTag:102];
            if (needGive) {
                switchImgView.highlighted = true;
                cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];

            }
            else
            {
                switchImgView.highlighted = false;
                cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
            }
            return cell;
        }
        else if (row == 1)
        {
            static NSString *identifier = @"identifier_row1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 200, 57)];
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.text = @"赠送件数";
//                nameLabel.tag = 101;
                nameLabel.font = [UIFont systemFontOfSize:17];
                [cell.contentView addSubview:nameLabel];
                
                
                UIImage *arrowImg = [UIImage imageNamed:@"pos_right_arrow.png"];
                UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.width - arrowImg.size.width - 20, (57 - arrowImg.size.height)/2.0, arrowImg.size.width, arrowImg.size.height)];
                arrowImgView.image = arrowImg;
                [cell.contentView addSubview:arrowImgView];
                
                UIImage *count_bg = [UIImage imageNamed:@"pos_count_bg.png"];
                
                UIImageView *count_bgView = [[UIImageView alloc] initWithImage:count_bg];
                count_bgView.y = (57 - count_bg.size.height)/2.0;
                count_bgView.right = arrowImgView.x - 2;
                [cell.contentView addSubview:count_bgView];
                
                UILabel *countLabel = [[UILabel alloc] initWithFrame:count_bgView.frame];
                countLabel.backgroundColor = [UIColor clearColor];
                countLabel.textAlignment = NSTextAlignmentCenter;
                countLabel.font = [UIFont systemFontOfSize:12];
                countLabel.tag = 101;
                countLabel.textColor = [UIColor whiteColor];
                [cell.contentView addSubview:countLabel];

            }
            UILabel *countLabel  = (UILabel *)[cell.contentView viewWithTag:101];
            
            countLabel.text = [NSString stringWithFormat:@" %d",giveCount];
            return cell;
        }
       
    }
    else
    {
        static NSString *identifier = @"AllocationCell";
        AllocationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSLog(@"新建Cell");
            cell = [AllocationCell createCell];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        else
        {
            
        }
        
        
        cell.indexPath = indexPath;
        cell.imgView.image = [UIImage imageNamed:@"pos_delete.png"];

        AllotObject *allotObject;
        NSInteger maxRow = 0;
        
        if (section == KSection_sale) {
            if (row < self.saleArray.count) {
                allotObject = [self.saleArray objectAtIndex:row];
            }

            maxRow = self.saleArray.count;
            cell.typeLabel.text = @"";
        }
        else if (section == KSection_technican)
        {
            if (row < self.techArray.count) {
                allotObject = [self.techArray objectAtIndex:row];
            }
            
            cell.typeLabel.text = allotObject.techType;
            maxRow = self.techArray.count ;
        }
//        cell.countLabel.text = [NSString stringWithFormat:@"%.2f件",[allotObject.count floatValue]];
        cell.countLabel.text = @"";
        cell.moneyLabel.text = [NSString stringWithFormat:@"%￥%.2f",allotObject.money.floatValue];
        cell.nameLabel.text = allotObject.employee_name;
        cell.removeBtn.hidden = false;
        
        if (row == maxRow ) {
            cell.imgView.image = [UIImage imageNamed:@"pos_add.png"];
            cell.nameLabel.text = @"添加";
            cell.typeLabel.text = @"";
            cell.countLabel.text = @"";
            cell.moneyLabel.text = @"";
            cell.removeBtn.hidden = true;
            
        }
        [self cellBg:cell withRow:row minRow:0 maxRow:maxRow];

        return cell;
    }
    return nil;
}


- (void)switchBtnPressed:(UIButton *)btn
{
    needGive = !needGive;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:KSection_head] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)cellBg:(UITableViewCell *)cell withRow:(int)row minRow:(int)minRow maxRow:(int)maxRow
{
    if (minRow == maxRow) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
        return;
    }
    if (row == minRow) {
       cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
    }
    else if (row == maxRow)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
    }
    else
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_m.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
    }
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 57;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 20)];
    label.text = @"test";
    label.textColor = COLOR(153, 174, 175,1);
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    if (section ==KSection_head) {
        label.text = @"";
    }
    else if (section == KSection_sale)
    {
        label.text = @"销售业绩";
    }
    else
    {
        label.text = @"美疗师业绩";
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == KSection_head) {
        if (row == 1) {
            PosAlloctionGiveViewController *giveVC = [[PosAlloctionGiveViewController alloc] init];
            giveVC.delegate = self;
            giveVC.posProduct = self.product;
            giveVC.giveCount = giveCount;
            [self.navigationController pushViewController:giveVC animated:YES];
        }
    }
    else
    {
        NSInteger type;
        AllotObject *allotObj = nil;
        
        if (section == KSection_sale) {
            type = PersonType_Sale;
            if (row < self.saleArray.count) {
                allotObj = [self.saleArray objectAtIndex:row];
                
            }
        }
        else
        {
            type = PersonType_Technician;
            if (row < self.techArray.count) {
                allotObj = [self.techArray objectAtIndex:row];
                
            }
        }
        
        NSInteger notAssignCount = 0;
        CGFloat notAssignMoney = 0;
        if (type == PersonType_Sale) {
            notAssignCount = [self getSaleNotAssignCount];
            notAssignMoney = [self getSaleNotAssignMoney];
            
        }
        else if (type == PersonType_Technician)
        {
            notAssignCount = [self getTechNotAssignCount];
            notAssignMoney = [self getTechNotAssignMoney];
        }
        
        
        notAssignCount = notAssignCount + [allotObj.count integerValue];
        
        if ([allotObj.commissionRule.sale_price_sel isEqualToString:@"sale_price"]) {
            notAssignMoney = notAssignMoney + [allotObj.money floatValue];
        }
        else
        {
            notAssignMoney = notAssignMoney + [allotObj.money floatValue] *self.commissionRadio;
        }

        
//        if (notAssignMoney <= 0) {
//            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"现在可分配的业绩为0"];
//            [messageView showInView:self.view];
//            return;
//        }

        PosAllocationPersonViewController *alloctionPeopleVC = [[PosAllocationPersonViewController alloc] initWithNibName:@"PosAllocationPersonViewController" bundle:nil];
        alloctionPeopleVC.operate = self.operate;
        alloctionPeopleVC.product = self.product;
        alloctionPeopleVC.allotObject = allotObj;
        alloctionPeopleVC.delegate = self;
        alloctionPeopleVC.maxAssignCount = notAssignCount;
        alloctionPeopleVC.maxAssignMoney = notAssignMoney;
        alloctionPeopleVC.commissionRadio = self.commissionRadio;
        alloctionPeopleVC.type = type;
        [self.navigationController pushViewController:alloctionPeopleVC animated:YES];
    }
}


#pragma mark - get not assign count

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


- (NSInteger)getNotAssignCount
{
    NSInteger assignCount = 0;
    for (AllotObject *allotObj in self.saleArray) {
        assignCount += [allotObj.count integerValue];
    }
    
    for (AllotObject *allotObj in self.techArray) {
        assignCount += [allotObj.count integerValue] + [allotObj.giftCount integerValue];
    }
    
    
    return [self.product.product_qty integerValue] - assignCount;
}

#pragma mark - get not assign money
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

- (CGFloat)getNotAssignMoney
{
    CGFloat assignMoney = 0;
    for (AllotObject *allotObj in self.saleArray) {
        assignMoney += [allotObj.money floatValue];
    }
    
    for (AllotObject *allotObj in self.techArray) {
        assignMoney += [allotObj.money floatValue];
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

#pragma mark - button action
- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureBtnPressed:(UIButton *)sender {
    NSLog(@"确认");
    [self sendRequest];
    
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - PosAllotGiveViewControllerDelegate
- (void)didSureGiveCount:(NSInteger) count
{
    giveCount = count;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:KSection_head]] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - PosAlloctionPeopleDelegate
- (void)didSureAllotObject:(AllotObject *)object type:(PersonType)type edit:(BOOL)isEdit
{
    int section = 0;
    if (type == PersonType_Sale) {
        if (!isEdit) {
            [self.saleArray addObject:object];
        }
         section = KSection_sale;
    }
    else if (type == PersonType_Technician)
    {
        if (!isEdit) {
            [self.techArray addObject:object];
        }
        section = KSection_technican;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
//    CGFloat notAssingMoney = [self getNotAssignMoney];
//    self.titleLabel.text = [NSString stringWithFormat:@"可分配业绩：%.2f",[self getNotAssignMoney]];
    
}

#pragma mark - AllocationHeadViewDelegate
- (void) didGiveBtnPressed
{
    PosAlloctionGiveViewController *giveVC = [[PosAlloctionGiveViewController alloc] init];
    [self.navigationController pushViewController:giveVC animated:YES];
}


#pragma mark - AllocationCellDelegate
- (IBAction)deleteBtnPressed:(id)sender
{
    NSLog(@"deleteBtnPressed");
}

- (void)didDeleteBtnPressed:(NSIndexPath *)indexPath
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
    else if (section == KSection_technican)
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

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
