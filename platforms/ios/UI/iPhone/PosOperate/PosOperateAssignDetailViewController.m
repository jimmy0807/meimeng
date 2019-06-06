//
//  PosOperateAssignDetailViewController.m
//  Boss
//
//  Created by lining on 16/9/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PosOperateAssignDetailViewController.h"
#import "PosOperateItemCell.h"
#import "PosOperateBtnCell.h"
#import "PosOperateSwitchCell.h"
#import "TextFieldCell.h"
#import "ItemArrowCell.h"
#import "BSFetchStaffRequest.h"
#import "BSSelectedView.h"
#import "CBMessageView.h"

typedef enum kRow
{
    kRow_people,
    kRow_money,
    kRow_num
}kRow;

@interface PosOperateAssignDetailViewController ()<BtnCellDelegate,SwitchCellDelegate,BSSelectedViewDelegate>
{
    int section_gift,section_assign,section_btn,section_num;
    bool isEdit;
}

@property (strong, nonatomic) NSArray *staffs;
@property (strong, nonatomic) BSSelectedView *selectedView;
@property(nonatomic, assign) CGFloat orignMaxAssignMoney;

@end

@implementation PosOperateAssignDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.orignMaxAssignMoney = self.maxAssignMoney;

//    self.title = [NSString stringWithFormat:@"可分配:¥%.2f",self.maxAssignMoney];
    [self reloadTitle];
    self.hideKeyBoardWhenClickEmpty = true;
    
    if (self.allotObject) {
        isEdit = true;
    }
    else
    {
        isEdit = false;
        
        self.allotObject = [[AllotObject alloc] init];
        self.allotObject.money = [NSNumber numberWithFloat:self.maxAssignMoney];
        if (self.peopleType == PeopleType_Technician) {
            self.allotObject.techType = @"点单";
        }
    }
    

    [self initView];
    [self initSection];
    
    if (self.peopleType == PeopleType_Technician && !self.allotObject.gift) {
//        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, self.view.height/2.0)];
//        footView.backgroundColor = [UIColor clearColor];
//        self.tableView.tableFooterView = footView;
//        
//        self.tableView.contentOffset = CGPointMake(0, 140);
    }
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"TextFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemArrowCell" bundle:nil] forCellReuseIdentifier:@"ItemArrowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PosOperateBtnCell" bundle:nil] forCellReuseIdentifier:@"PosOperateBtnCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PosOperateSwitchCell" bundle:nil] forCellReuseIdentifier:@"PosOperateSwitchCell"];
    
    
    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self sendRequest];
    
}

#pragma mark - init

- (void)reloadTitle
{
    if (self.allotObject) {
        NSString *tip;
        if ([self.allotObject.commissionRule.sale_price_sel  isEqualToString:@"sale_price"]) {
            self.maxAssignMoney = self.orignMaxAssignMoney;
            tip = @"(按成交价)可分配业绩";
        }
        else
        {
            self.maxAssignMoney = self.orignMaxAssignMoney / self.commissionRadio;
            tip = @"(按原价)可分配业绩";
        }
        
        self.title = [NSString stringWithFormat:@"%@:￥%.2f",tip,self.maxAssignMoney];
    }
    else
    {
        self.title = [NSString stringWithFormat:@"%@:￥%.2f",@"可分配业绩",self.maxAssignMoney];
    }
    
}


- (void)initView
{
    self.selectedView = [BSSelectedView createViewWithTitle:self.peopleType == PeopleType_Sale ? @"请选择销售":@"请选择技师"];
    self.selectedView.delegate = self;
    [self reloadSelectedView];
}

- (void)initSection
{
    section_gift = -1;
    section_assign = 0;
    section_btn = 1;
    section_num = 2;
    if (self.peopleType == PeopleType_Technician) {
        section_gift = 0;
        section_assign = 1;
        section_btn = 2;
        section_num = 3;
    }
}

#pragma mark - reloadSelectedView
- (void)reloadSelectedView
{
    self.staffs = [[BSCoreDataManager currentManager] fetchStaffsWithShopID:self.product.shop_id need_role_id:true];
    
    NSMutableArray *stringArray = [NSMutableArray array];
    NSInteger currentIdx = -1;

    for (CDStaff *staff in self.staffs) {
        if (staff.staffID.integerValue == self.allotObject.employee_id.integerValue) {
            currentIdx = [self.staffs indexOfObject:staff];
            
        }
        [stringArray addObject:staff.name];
    }
    
    self.selectedView.currentSelectedIdx = currentIdx;
    self.selectedView.stringArray = stringArray;
}

#pragma mark - sendReqeust
- (void)sendRequest
{
//    BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
//    request.shopID = self.operate.operate_shop_id;
//    request.need_role_id = true;
//    [request execute];
}


#pragma mark - receivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchStaffResponse]) {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            [self reloadSelectedView];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return section_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == section_gift) {
        if (self.allotObject.gift) {
            return 2;
        }
        else
        {
            return 1;
        }
    }
    else if (section == section_assign)
    {
        return kRow_num;
    }
    else if (section == section_btn)
    {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == section_gift) {
        if (row == 0) {
            PosOperateSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateSwitchCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.switchBtn.on = self.allotObject.gift;
            cell.delegate = self;
            cell.lineImgView.hidden = !self.allotObject.gift;
            return cell;
        }
        else if (row == 1)
        {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            cell.titleLabel.text = @"赠送件数";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.font = [UIFont systemFontOfSize:15];
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.valueTextFiled.placeholder = [NSString stringWithFormat:@"最大赠送件数%d",self.maxAssignCount];
            cell.valueTextFiled.clearsOnBeginEditing = true;
            cell.valueTextFiled.keyboardType = UIKeyboardTypeNumberPad;
            cell.valueTextFiled.delegate = self;
            cell.valueTextFiled.tag = 1000 * section + row;
            cell.valueTextFiled.textColor = [UIColor grayColor];
            cell.lineImgView.hidden = true;
            cell.valueTextFiled.text = [NSString stringWithFormat:@"%d",self.allotObject.giftCount.integerValue];
            return cell;
        }
    }
    else if (section == section_assign)
    {
        if (row == kRow_people) {
           ItemArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemArrowCell"];
            if (self.peopleType == PeopleType_Technician) {
                cell.nameLabel.text = @"技师";
            }
            else
            {
                cell.nameLabel.text = @"销售";
            }
            
            cell.valueLabel.text = self.allotObject.employee_name.length > 0 ? self.allotObject.employee_name:@"请选择";
            return cell;
        }
        else if (row == kRow_money)
        {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"业绩";
            cell.titleLabel.font = [UIFont systemFontOfSize:15];
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.lineImgView.hidden = true;
            cell.valueTextFiled.placeholder = @"请输入";
            cell.valueTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
            cell.valueTextFiled.clearsOnBeginEditing = true;
            cell.valueTextFiled.delegate = self;
            cell.valueTextFiled.tag = 1000 * section + row;
            cell.valueTextFiled.textColor = [UIColor grayColor];
            cell.valueTextFiled.text = [NSString stringWithFormat:@"¥%.2f",self.maxAssignMoney];
            return cell;
        }
    }
    else if (section == section_btn)
    {
        PosOperateBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateBtnCell"];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.delegate = self;
        return cell;
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
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.backgroundColor = [UIColor clearColor];

    return imgView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == section_assign && row == kRow_people) {
        [self.selectedView show];
    }
    
}

#pragma mark - BSSelectedViewDelegate
- (void)didSelectedAtIndex:(NSInteger)index
{
    CDStaff *staff = [self.staffs objectAtIndex:index];
    self.allotObject.staff = staff;
    self.allotObject.employee_id = staff.staffID;
    self.allotObject.employee_name = staff.name;
    self.allotObject.rule_id = staff.rule_id;
    self.allotObject.rule_name = staff.rule_name;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kRow_people inSection:section_assign]] withRowAnimation:UITableViewRowAnimationFade];
    
    [self reloadTitle];
//    [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0];

}

- (void)showKeyboard
{
    TextFieldCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section_assign]];
    [cell.valueTextFiled becomeFirstResponder];
}



#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 1000;
    NSInteger row = textField.tag % 1000;
    if (section == section_gift) {
        if (row == 1) {
            NSInteger count = textField.text.integerValue;
            if (count > self.maxAssignCount) {
                CBMessageView  *messageView = [[CBMessageView alloc] initWithTitle:@"超出了可赠送件数，请重新输入"];
                [messageView showInView:self.view];
                textField.text = @"";
                
            }
            else
            {
               self.allotObject.giftCount = @(count);
            }
        }
    }
    else if (section == section_assign)
    {
        if (row == kRow_money) {
            CGFloat money = textField.text.floatValue;
            if (money > 0 && self.maxAssignMoney - money < 0 && self.product.buy_price.floatValue > 0) {
                CBMessageView  *messageView = [[CBMessageView alloc] initWithTitle:@"超出了可分配金额，请重新输入"];
                [messageView showInView:self.view];
                textField.text = @"";
                
            }
            else
            {
                textField.text = [NSString stringWithFormat:@"￥%.2f",money];
                self.allotObject.money = @(money);
            }
        }
    }
    
}

#pragma mark - BtnCellDelegate
- (void)didBtnPressed
{
//    NSLog(@"添加");
    if (self.allotObject.employee_name.length == 0) {
        CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"要分配的人员不能为空"];
        [messageView showInView:self.view];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didSureAllotObject:type:edit:)]) {
        [self.delegate didSureAllotObject:self.allotObject type:self.peopleType edit:isEdit];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SwitchCellDelegate
- (void)didSwitchValueChanged:(BOOL)changed
{
    self.allotObject.gift = changed;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section_gift] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
