//
//  MemberCardInfoDataSource.m
//  Boss
//
//  Created by lining on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardInfoDataSource.h"
#import "MemberCheckboxCell.h"
#import "BSEditCell.h"
//
//@implementation Item
//
//@end


@interface MemberCardInfoDataSource ()<CheckBoxCellDelegate>
@property (nonatomic, strong) NSMutableDictionary *params;

//记录最原始的数据,修改前的
@property (nonatomic, assign) bool is_sign;
@property (nonatomic, assign) bool is_employee_card;
@property (nonatomic, assign) bool is_share;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *default_code;
@end

@implementation MemberCardInfoDataSource


- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([PersonalProfile currentProfile].roleOption == RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0) {
            self.canEdit = false;
        }
        else
        {
            self.canEdit = true;
        }
    }
    
    return self;
}

- (void)setMemberCard:(CDMemberCard *)memberCard
{
    _memberCard = memberCard;
    self.params = [NSMutableDictionary dictionary];
    
    self.is_sign = [memberCard.is_sign boolValue];
    self.is_employee_card = [memberCard.is_employee_card boolValue];
    self.is_share = [memberCard.is_share boolValue];
    
    self.password = memberCard.password;
    self.default_code = memberCard.default_code;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kCardInfoSectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kCardInfoSectionOne) {
        return CardInfoSectionOne_row_num;
    }
    else if (section == kCardInfoSectionTwo)
    {
        return CardInfoSectionTwo_row_num;
    }
    else if (section == kCardInfoSectionThree)
    {
        return CardInfoSectionThree_row_num;
    }
    else if (section == kCardInfoSectionFour)
    {
        return CardInfoSectionFourRow_row_num;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == kCardInfoSectionFour && ((row == CardInfoSectionFourRow_row_qiandao) || (row == CardInfoSectionFourRow_row_yuangong) || (row == CardInfoSectionFourRow_row_kuadian))){
        static NSString *check_cell = @"check_cell";
        MemberCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:check_cell];
        if(cell==nil)
        {
            cell = [MemberCheckboxCell createCell];
            cell.canEdit = self.canEdit;
            cell.delegate = self;
        }
        cell.indexPath = indexPath;
        if (row == CardInfoSectionFourRow_row_qiandao) {
            cell.titleLabel.text = @"签到卡";
            cell.checkBoxImg.highlighted =[self.memberCard.is_sign boolValue];
        }
        else if (row == CardInfoSectionFourRow_row_yuangong)
        {
            cell.titleLabel.text = @"是否是员工卡";
            cell.checkBoxImg.highlighted =[self.memberCard.is_employee_card boolValue];
        }
        else if (row == CardInfoSectionFourRow_row_kuadian)
        {
            cell.titleLabel.text = @"是否可以跨店消费";
            cell.checkBoxImg.highlighted =[self.memberCard.is_share boolValue];
        }
        
        return cell;
    }
    else
    {
        static NSString *other_cell = @"other_cell";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:other_cell];
        if(cell==nil)
        {
            cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:other_cell];

            cell.contentField.delegate = self;
        }
        cell.contentField.enabled = false;
        cell.contentField.secureTextEntry = false;
        cell.contentField.tag = indexPath.section * 100 + indexPath.row;
        cell.arrowImageView.hidden = true;

        if (section == kCardInfoSectionOne) {
            if (row == CardInfoSectionOne_row_jilu) {
                cell.titleLabel.text = @"我的卡记录";
                cell.contentField.text = @"";
                cell.contentField.placeholder = @"";
                cell.contentField.enabled = false;
                cell.arrowImageView.hidden = false;
            }
            if (row == CardInfoSectionOne_row_yue) {
                cell.titleLabel.text = @"储值余额";
                cell.contentField.text = [NSString stringWithFormat:@"￥%.2f",[self.memberCard.amount floatValue]];
                cell.contentField.enabled = false;
            }
            else if (row == CardInfoSectionOne_row_jifen)
            {
                cell.titleLabel.text = @"积分";
                cell.contentField.text = [NSString stringWithFormat:@"%@",self.memberCard.points];
            }
        }
        else if (section == kCardInfoSectionTwo)
        {
            if (row == CardInfoSectionTwo_row_chongzhi) {
                cell.titleLabel.text = @"累计充值金额";
                cell.contentField.text = [NSString stringWithFormat:@"￥%.2f",[self.memberCard.recharge_amount floatValue]];
                cell.contentField.enabled = false;
            }
            else if (row == CardInfoSectionTwo_row_chongzhiqiankuan)
            {
                cell.titleLabel.text = @"充值欠款";
                cell.contentField.text = [NSString stringWithFormat:@"￥%.2f",[self.memberCard.arrearsAmount floatValue]];
            }
            else if (row == CardInfoSectionTwo_row_xiaofeiqiankuan)
            {
                cell.titleLabel.text = @"消费欠款";
                cell.contentField.text = [NSString stringWithFormat:@"￥%.2f",[self.memberCard.courseArrearsAmount floatValue]];
            }
            else if (row == CardInfoSectionTwo_row_sale)
            {
                cell.titleLabel.text = @"产品销售";
                cell.contentField.text = [NSString stringWithFormat:@"￥%.2f",[self.memberCard.product_consume_amount floatValue]];
            }
            else if (row == CardInfoSectionTwo_row_xiaohao)
            {
                cell.titleLabel.text = @"项目消耗";
                cell.contentField.text = [NSString stringWithFormat:@"￥%.2f",[self.memberCard.item_consume_amount floatValue]];
            }
           
        }
        else if (section == kCardInfoSectionThree)
        {
            if (row == CardInfoSectionThree_row_shop) {
                cell.titleLabel.text = @"门店";
                cell.contentField.text = self.memberCard.storeName;
            }
        }
        else if (section == kCardInfoSectionFour)
        {
            if (row == CardInfoSectionFourRow_row_pwd) {
                cell.titleLabel.text = @"会员卡支付密码";
                cell.contentField.enabled = true;
                cell.contentField.placeholder = @"请输入";
                cell.contentField.secureTextEntry = true;
                cell.contentField.text = (self.memberCard.password.length > 0 && ![self.memberCard.password isEqualToString:@"0"])? self.memberCard.password : nil;
                
            }
            else if (row == CardInfoSectionFourRow_row_defaultCode)
            {
                cell.titleLabel.text = @"实体卡编码";
                cell.contentField.enabled = true;
                cell.contentField.placeholder = @"请输入";
                cell.contentField.text = (self.memberCard.default_code.length > 0 && ![self.memberCard.default_code isEqualToString:@"0"]) > 0 ? self.memberCard.default_code : nil;
            }
        }
        
        if (!self.canEdit) {
            cell.contentField.enabled = false;
            cell.contentField.placeholder = @"暂无";
            cell.arrowImageView.hidden = true;
        }
        return cell;
    }
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger row = indexPath.row;
//    NSInteger section = indexPath.section;
    return 50;
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self.delegate respondsToSelector:@selector(didSelectedItemAtIndexPath:)]) {
        [self.delegate didSelectedItemAtIndexPath:indexPath];
    }
}


#pragma mark - CheckBoxCellDelegate
- (void)didCheckboxSelected:(bool)selected indexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kCardInfoSectionFour) {
        if (row == CardInfoSectionFourRow_row_qiandao) {
           
            self.memberCard.is_sign = [NSNumber numberWithBool:selected];
            if (self.is_sign != [self.memberCard.is_sign boolValue]) {
                [self.params setObject:self.memberCard.is_sign forKey:@"is_sign"];
            }
            else
            {
                [self.params removeObjectForKey:@"is_sign"];
            }
        }
        else if (row == CardInfoSectionFourRow_row_yuangong)
        {
            self.memberCard.is_employee_card = [NSNumber numberWithBool:selected];
            if (self.is_employee_card != [self.memberCard.is_employee_card boolValue]) {
                [self.params setObject:self.memberCard.is_employee_card forKey:@"is_employee_card"];
            }
            else
            {
                [self.params removeObjectForKey:@"is_employee_card"];
            }
        }
        else if (row == CardInfoSectionFourRow_row_kuadian)
        {
            self.memberCard.is_share = [NSNumber numberWithBool:selected];
            if (self.is_share != [self.memberCard.is_share boolValue]) {
                [self.params setObject:self.memberCard.is_share forKey:@"is_share"];
            }
            else
            {
                [self.params removeObjectForKey:@"is_share"];
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(didEditParams:)]) {
        [self.delegate didEditParams:self.params];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;

    if (section == kCardInfoSectionFour)
    {
        if (row == CardInfoSectionFourRow_row_pwd)
        {
            if (![self.memberCard.password isEqualToString:textField.text])
            {
                self.memberCard.password = textField.text;
                if ([self.memberCard.password isEqualToString:self.password])
                {
                    [self.params removeObjectForKey:@"password"];
                }
                else
                {
                    [self.params setObject:self.memberCard.password forKey:@"password"];
                }
            }
        }
        else if (row == CardInfoSectionFourRow_row_defaultCode)
        {
            if (![self.memberCard.default_code isEqualToString:textField.text])
            {
                self.memberCard.default_code = textField.text;
                if ([self.memberCard.default_code isEqualToString:self.default_code]) {
                    [self.params removeObjectForKey:@"default_code"];
                }
                else
                {
                    [self.params setObject:self.memberCard.default_code forKey:@"default_code"];
                }
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(didEditParams:)]) {
            [self.delegate didEditParams:self.params];
        }
    }
}


#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

@end
