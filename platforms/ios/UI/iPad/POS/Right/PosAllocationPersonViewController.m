//
//  PosAllocationPersonViewController.m
//  Boss
//
//  Created by lining on 15/11/18.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PosAllocationPersonViewController.h"
#import "BSFetchStaffRequest.h"
#import "CBLoadingView.h"
#import "UIView+Frame.h"
#import "UIImage+Resizable.h"
#import "PosAlloctionGiveViewController.h"
#import "CBMessageView.h"
#import "BSFetchCommissionRuleRequest.h"

#define kTB_tag         101
#define kTypeTB_tag     102
#define kNameTB_tag     103

#define kFieldTag_giftCount 1000
#define kFieldTag_count   1001
#define kFieldTag_money 1002

@interface PosAllocationPersonViewController ()<PosAllotGiveViewControllerDelegate>
{
    NSInteger section_gift,section_count,section_people,section_type,section_num;
//    bool gift;
//    int gift_count;
    
    NSInteger requestCount;
    
    bool type_expand;
    bool emplooy_expand;
    
    bool count_canEdit;
    bool isEdit;
}

@property(nonatomic, strong) NSArray *typeArray;
@property(nonatomic, strong) NSArray *staffs;
@property(nonatomic, assign) CGFloat orignMaxAssignMoney;

@end

@implementation PosAllocationPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tag = kTB_tag;
    self.noKeyboardNotification = true;
    
    self.orignMaxAssignMoney = self.maxAssignMoney;

    [self reloadTitle];
    
    [self initSection];
    
    [self initData];
    
    
    
    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self registerNofitificationForMainThread:kFetchCommissionRuleResponse];
   
//    [self sendFetchReqeust];
    
    
    
    if (self.type == PersonType_Technician && !self.allotObject.gift) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, self.view.height/2.0)];
        footView.backgroundColor = [UIColor clearColor];
        self.tableView.tableFooterView = footView;
        
        //self.tableView.contentOffset = CGPointMake(0, 140);
    }
    
}

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
        
        self.titleLabel.text = [NSString stringWithFormat:@"%@:￥%.2f",tip,self.maxAssignMoney];
    }
    else
    {
        self.titleLabel.text = [NSString stringWithFormat:@"%@:￥%.2f",@"可分配业绩",self.maxAssignMoney];
    }
    
}

- (void)sendFetchReqeust
{
//    BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
//    request.shopID = self.product.operate.operate_shop_id;
//    request.need_role_id = true;
//    [request execute];
//    requestCount++;
    
    BSFetchCommissionRuleRequest *ruleReqest = [[BSFetchCommissionRuleRequest alloc] init];
    [ruleReqest execute];
    requestCount++;
    
    [[CBLoadingView shareLoadingView] show];
}


- (void) initData
{
    self.typeArray = @[@"点单",@"轮单"];
    self.staffs = [[BSCoreDataManager currentManager] fetchStaffsWithShopID:self.operate.shop.storeID need_role_id:true];
    
    count_canEdit = true;
    if (self.type == PersonType_Sale) {
        if (self.product == nil) {
            count_canEdit = false;
        }
        if ([self.product.product.fixedCardDeduct integerValue] > 0 || [self.product.product.notFixedCardDeduct integerValue] > 0) {
            count_canEdit = false;
        }
    }
    else if (self.type == PersonType_Technician)
    {
        if ([self.product.product.doFixedPercent integerValue] > 0) {
            count_canEdit = false;
        }
    }
    
    if (self.allotObject == nil) {
        self.allotObject = [[AllotObject alloc] init];
//        self.allotObject.count = [NSNumber numberWithInteger:self.maxAssignCount];
        self.allotObject.money = [NSNumber numberWithFloat:self.maxAssignMoney];
        if (self.type == PersonType_Technician) {
            self.allotObject.techType = @"点单";
        }
        isEdit = false;
    }
    else
    {
        isEdit = true;
    }

}

- (void) initSection
{
    section_gift = -1;
    section_type = -1;
    section_people = 0;
    section_count = 1;
    section_num = 2;
    if (self.type == PersonType_Technician) {
        section_gift = 0;
        section_people = 1;
        section_type = 2;
        section_count = 3;
        section_num = 4;
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
    else if (section == section_people)
    {
        if (emplooy_expand) {
            return self.staffs.count + 1;
        }
        return 1;
    }
    else if (section == section_type)
    {
        if (type_expand) {
            return self.typeArray.count + 1;
        }
        return 1;
    }
    
    else if (section == section_count)
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
            static NSString *identifier = @"identifier_gift";
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
            if (self.allotObject.gift) {
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
                
                
//                UIImage *arrowImg = [UIImage imageNamed:@"pos_right_arrow.png"];
//                UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.width - arrowImg.size.width - 20, (57 - arrowImg.size.height)/2.0, arrowImg.size.width, arrowImg.size.height)];
//                arrowImgView.image = arrowImg;
//                [cell.contentView addSubview:arrowImgView];
//                
//                UIImage *count_bg = [UIImage imageNamed:@"pos_count_bg.png"];
//                
//                UIImageView *count_bgView = [[UIImageView alloc] initWithImage:count_bg];
//                count_bgView.y = (57 - count_bg.size.height)/2.0;
//                count_bgView.right = arrowImgView.x - 2;
//                [cell.contentView addSubview:count_bgView];
//                
//                UILabel *countLabel = [[UILabel alloc] initWithFrame:count_bgView.frame];
//                countLabel.backgroundColor = [UIColor clearColor];
//                countLabel.textAlignment = NSTextAlignmentCenter;
//                countLabel.font = [UIFont systemFontOfSize:12];
//                countLabel.tag = 101;
//                countLabel.textColor = [UIColor whiteColor];
//                [cell.contentView addSubview:countLabel];
                
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(self.tableView.width - 200 - 20, 0, 200, 57)];
                textField.borderStyle = UITextBorderStyleNone;
                textField.textAlignment = NSTextAlignmentRight;
                textField.tag = kFieldTag_giftCount;
                textField.delegate = self;
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                textField.clearsOnBeginEditing = true;
                [cell.contentView addSubview:textField];
                textField.placeholder = [NSString stringWithFormat:@"最大为%d",self.maxAssignCount];
                
            }
            UITextField *countLabel  = (UITextField *)[cell.contentView viewWithTag:kFieldTag_giftCount];
            
            countLabel.text = [NSString stringWithFormat:@" %.01f",self.allotObject.giftCount.floatValue];
            return cell;
        }
        
    }
    else if (section == section_count)
    {
        static NSString *identifier = @"identifier_count";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSLog(@"新建Cell");
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            for (int i = 0; i < 2; i++) {
//                CGFloat margin = 50;
//                CGFloat width = (self.tableView.width - 50)/2.0;
//                
//                CGFloat x = (margin + width) * i;
//
//                UIImageView *imgBgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
//                imgBgView.frame = CGRectMake(x, 0, width, 57);
//                [cell.contentView addSubview:imgBgView];
//                
//                UITextField *textField = [[UITextField alloc] initWithFrame:imgBgView.frame];
//                textField.borderStyle = UITextBorderStyleNone;
//                textField.textAlignment = NSTextAlignmentCenter;
//                textField.tag = 1001 + i;
//                textField.delegate = self;
//                textField.clearsOnBeginEditing = true;
//                [cell.contentView addSubview:textField];
//                textField.placeholder = @"请输入...";
//
//            }
            UIImageView *imgBgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
            imgBgView.frame = CGRectMake(0, 0, self.tableView.width, 57);
            [cell.contentView addSubview:imgBgView];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:imgBgView.frame];
            textField.borderStyle = UITextBorderStyleNone;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.tag = 1002;
            textField.delegate = self;
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            textField.clearsOnBeginEditing = true;
            [cell.contentView addSubview:textField];
            textField.placeholder = @"请输入...";

        }
        UITextField *countField = (UITextField *)[cell.contentView viewWithTag:1001];
        UITextField *moneyField = (UITextField *)[cell.contentView viewWithTag:1002];
        
        countField.text = [NSString stringWithFormat:@"%.2f",[self.allotObject.count floatValue]];
        if (count_canEdit) {
            countField.enabled= true;
            countField.textColor = [UIColor blackColor];
        }
        else
        {
            countField.enabled = false;
            countField.textColor = [UIColor grayColor];
        }
        
        moneyField.text = [NSString stringWithFormat:@"￥%.2f",[self.allotObject.money floatValue]];
        
        return cell;
    }
    else
    {
        
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSLog(@"新建Cell");
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor = [UIColor clearColor];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 52)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 101;
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.contentView addSubview:label];
        
        }
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:101];
        nameLabel.text = @"请选择...";
        int maxRow = 0;
        if (section == section_people) {
            if (emplooy_expand) {
                maxRow = self.staffs.count;
            }
            if (row == 0) {
                if (self.allotObject.employee_name) {
                    nameLabel.text = self.allotObject.employee_name;
                }
            }
            else
            {
                CDStaff *staff = self.staffs[row - 1];
                nameLabel.text = staff.name;
            }
        }
        else if (section == section_type)
        {
            if (type_expand) {
                maxRow = self.typeArray.count;
            }
            if (row == 0) {
                if (self.allotObject.techType) {
                    nameLabel.text = self.allotObject.techType;
                }
            }
            else
            {
                nameLabel.text = self.typeArray[row - 1];
            }

        }
        
        [self cellBg:cell withRow:row minRow:0 maxRow:maxRow];
        return cell;
    }
    
    return nil;
}


- (void)switchBtnPressed:(UIButton *)btn
{
    if (!self.product.product.isGiftHasCommission.boolValue) {
        [[[CBMessageView alloc] initWithTitle:@"此产品无赠送业绩"] showInView:self.view];
        return;
    }
    if (self.maxAssignCount <= [self.allotObject.count floatValue] && [self.allotObject.giftCount floatValue] <= 0) {
        [[[CBMessageView alloc] initWithTitle:@"已没有可赠送的件数，请重新分配"] showInView:self.view];
        return;
    }
    self.allotObject.gift = !self.allotObject.gift;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section_gift] withRowAnimation:UITableViewRowAnimationAutomatic];
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

    
    CGFloat margin = 50;
    CGFloat width = (tableView.width - margin - 4)/2.0;
    
    
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(2, 30, width, 20)];
    label1.text = @"test";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = COLOR(153, 174, 175,1);
    label1.backgroundColor = [UIColor clearColor];
    [view addSubview:label1];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.x + width + margin, label1.y, width, 20)];
    label2.text = @"";
    label2.textColor = COLOR(153, 174, 175,1);
    label2.font = [UIFont systemFontOfSize:12];
    label2.backgroundColor = [UIColor clearColor];
    [view addSubview:label2];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.tableView.width, 1)];
    lineView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [view addSubview:lineView];

    
    if (section == 0) {
        lineView.hidden = true;
    }
    
    if (section ==section_gift) {
        label1.text = @"";
    }
    else if (section == section_people)
    {
        if (self.type == PersonType_Sale) {
            label1.text = @"销售";
        }
        else
        {
            label1.text = @"美疗师业绩";
        }
        
    }
    else if (section == section_type)
    {
        label1.text = @"手工类型";
    }
    else if (section == section_count)
    {
//        label1.text = @"件数";
//        label2.text = @"业绩";
        label1.text = @"业绩";
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == section_gift) {
        if (row == 1) {
            PosAlloctionGiveViewController *giveVC = [[PosAlloctionGiveViewController alloc] init];
            giveVC.delegate = self;
            giveVC.posProduct = self.product;
            giveVC.maxGiveCount = self.maxAssignCount - [self.allotObject.count integerValue];
            giveVC.giveCount = self.allotObject.giftCount.floatValue;
            [self.navigationController pushViewController:giveVC animated:YES];
        }
    }
    else if (section == section_type)
    {
        type_expand = !type_expand;
        if (row == 0) {
            
        }
        else
        {
            NSString *techString = self.typeArray[indexPath.row - 1];
            self.allotObject.techType = techString;
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (section == section_people)
    {
        emplooy_expand = !emplooy_expand;
        if (row == 0) {
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
        }
        else
        {
            CDStaff *staff = [self.staffs objectAtIndex:indexPath.row - 1];
            self.allotObject.staff = staff;
            self.allotObject.employee_id = staff.staffID;
            self.allotObject.employee_name = staff.name;
            self.allotObject.rule_id = staff.rule_id;
            self.allotObject.rule_name = staff.rule_name;
            
            [self reloadTitle];
            
            [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0];
            
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (section == section_count)
    {
        
    }
    else
    {
       
    }
}

- (void)showKeyboard
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section_count]];
    UITextField *textField = [cell.contentView viewWithTag:1002];
    [textField becomeFirstResponder];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"contentOffset: %@",NSStringFromCGPoint(scrollView.contentOffset));
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == kFieldTag_giftCount) {
        CGFloat count = [textField.text floatValue];
        if (count > self.maxAssignCount) {
            CBMessageView  *messageView = [[CBMessageView alloc] initWithTitle:@"超出了可分配件数，请重新输入"];
            [messageView showInView:self.view];
            count = 0;
        }
        self.allotObject.giftCount = @(count);
        textField.text = [NSString stringWithFormat:@"%@",self.allotObject.giftCount];
    }
    else if (textField.tag == kFieldTag_count)
    {
        CGFloat count = [textField.text floatValue];
        if (count > self.maxAssignCount) {
            CBMessageView  *messageView = [[CBMessageView alloc] initWithTitle:@"超出了可分配件数，请重新输入"];
            [messageView showInView:self.view];
            count = 0;
        }
        self.allotObject.count = [NSNumber numberWithFloat:count];
        textField.text = [NSString stringWithFormat:@"%.2f",count];
    }
    else if (textField.tag == kFieldTag_money) {
        CGFloat money = [textField.text floatValue];
        if (money > self.maxAssignMoney && self.product.buy_price.floatValue > 0) {
            CBMessageView  *messageView = [[CBMessageView alloc] initWithTitle:@"超出了可分配金额，请重新输入"];
            [messageView showInView:self.view];
            money = 0;
        }
        self.allotObject.money = [NSNumber numberWithFloat:money];
        textField.text = [NSString stringWithFormat:@"￥%.2f",money];
        if (!count_canEdit) {
            
            CGFloat count = self.allotObject.money.floatValue / self.product.buy_price.floatValue;
            if (count > self.maxAssignCount || self.product == nil) {
                count = 0;
            }
            self.allotObject.count = [NSNumber numberWithFloat:count];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section_count] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - PosAllotGiveViewControllerDelegate
- (void)didSureGiveCount:(NSInteger) count
{
    self.allotObject.giftCount = [NSNumber numberWithInteger:count];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:section_gift]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - received nofication
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    
    if ([notification.name isEqualToString:kBSFetchStaffResponse]) {
        requestCount --;
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            self.staffs = [[BSCoreDataManager currentManager] fetchStaffsWithShopID:self.operate.shop.storeID need_role_id:true];
            [self.tableView reloadData];
        }
    }
    else if ([notification.name isEqualToString:kFetchCommissionRuleResponse])
    {
        requestCount --;
    }
    if (requestCount == 0) {
        [[CBLoadingView shareLoadingView] hide];
    }
}


- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureBtnPressed:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.allotObject.employee_name.length == 0) {
        CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"要分配的人员不能为空"];
        [messageView showInView:self.view];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didSureAllotObject:type:edit:)]) {
        [self.delegate didSureAllotObject:self.allotObject type:self.type edit:isEdit];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
