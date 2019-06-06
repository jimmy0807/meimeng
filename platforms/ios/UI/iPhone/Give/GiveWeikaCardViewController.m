//
//  WeikaCardDetailViewController.m
//  Boss
//
//  Created by lining on 16/9/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GiveWeikaCardViewController.h"
#import "TextFieldCell.h"
#import "ItemArrowCell.h"
#import "TextViewCell.h"
#import "BSDatePickerView.h"
#import "CouponObject.h"
#import "NSDate+Formatter.h"
#import "BSTemplateGiveRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "BSSuccessViewController.h"

typedef enum Section
{
    Section_one,
    Section_two,
    Section_num
}Section;

typedef enum SectionOneRow
{
    SectionRow_money,
    SectionRow_date,
    SecctionOneRow_num
}SectionOneRow;

@interface GiveWeikaCardViewController ()<BSDatePickerViewDelegate,TextViewCellDelegate,UITextFieldDelegate>
@property (strong, nonatomic) CouponObject *coupon;
@property (strong, nonatomic) BSDatePickerView *datePickerView;
@property (strong, nonatomic) UIButton *hideKeyboardBtn;
@end

@implementation GiveWeikaCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.title = @"赠送礼品卡";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"TextFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemArrowCell" bundle:nil] forCellReuseIdentifier:@"ItemArrowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextViewCell" bundle:nil] forCellReuseIdentifier:@"TextViewCell"];
    
    self.hideKeyBoardWhenClickEmpty = true;
    
    self.coupon = [[CouponObject alloc] initWithTemplate:self.cardTemplate];
    
    self.datePickerView = [BSDatePickerView createView];
    self.datePickerView.delegate = self;
    
    self.hideKeyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hideKeyboardBtn addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    self.hideKeyboardBtn.hidden = true;
    [self.view addSubview:self.hideKeyboardBtn];
    [self.hideKeyboardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    [self registerNofitificationForMainThread:kBSGiveCardResponse];
    
}


#pragma mark - receivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [[CBLoadingView shareLoadingView] hide];
    NSInteger ret = [[notification.userInfo numberValueForKey:@"rc"] integerValue];
    if (ret == 0) {
        
        BSSuccessViewController *successVC  = [BSSuccessViewController createViewControllerWithTopTip:nil contentTitle:@"赠送成功" detailTitle:@"优惠券1张"];
        successVC.operate = self.givePeople.operate;
        successVC.member = self.givePeople.member;
//        successVC.delegate = self;
        successVC.style = ViewShowStyle_Give;
        [self.navigationController pushViewController:successVC animated:YES];
        
        CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"赠送礼品卡成功"];
        [messageView show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]];
        [messageView show];

    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return Section_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == Section_one) {
        return SecctionOneRow_num;
    }
    else
    {
        return 2;
    }
    return Section_num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == Section_one) {
        if (row == SectionRow_money) {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"卡内金额";
            cell.titleLabel.font = [UIFont systemFontOfSize:15];
            cell.titleLabel.textColor = [UIColor lightGrayColor];
            cell.valueTextFiled.clearsOnBeginEditing = true;
            cell.valueTextFiled.hidden = false;
            cell.valueTextFiled.delegate = self;
           
            cell.valueTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
            
            cell.valueTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            cell.valueTextFiled.placeholder = @"请输入";
            
            cell.valueTextFiled.text = [NSString stringWithFormat:@"￥%.2f",[self.coupon.money floatValue]];
            cell.valueTextFiled.textColor = [UIColor darkTextColor];
            if ([self.cardTemplate.is_customize boolValue]) {
                cell.valueTextFiled.enabled = true;
            }
            else
            {
                cell.valueTextFiled.enabled = false;
            }
            
            return cell;
        }
        else if (row == SectionRow_date)
        {
            ItemArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemArrowCell"];
            cell.nameLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.nameLabel.textColor = [UIColor lightGrayColor];
            cell.nameLabel.text = @"有效期";
            if (self.coupon.expiredDate.length > 0) {
                cell.valueLabel.text = self.coupon.expiredDate;
            }
            else
            {
                cell.valueLabel.text = @"请选择";
            }
            cell.valueLabel.textColor = [UIColor darkTextColor];
            cell.lineImgView.hidden = true;
            return cell;
        }
    }
    else
    {
        if (row == 0) {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"备注信息";
            cell.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.titleLabel.textColor = [UIColor lightGrayColor];
            cell.valueTextFiled.hidden = true;
            return cell;
            
        }
        else
        {
            TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextViewCell"];
            cell.textView.font = [UIFont systemFontOfSize:15];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.placeHolder = @"请输入备注.....";
            cell.text = self.coupon.remarks;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    if (section == Section_one) {
        return 50;
    }
    else if(section == Section_two)
    {
        if (row == 0) {
            return 40;
        }
        else
        {
            return 150;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == Section_one && indexPath.row == SectionRow_date) {
//        self.datePickerView.date = [
        NSDate *expireDate;
        if (self.coupon.expiredDate.length > 0) {
            expireDate = [NSDate dateFromString:self.coupon.expiredDate formatter:@"yyyy-MM-dd"];
        }
        else
        {
            expireDate = [NSDate date];
        }
        self.datePickerView.date = expireDate;
        [self.datePickerView show];
    }
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGFloat money = [textField.text floatValue];
    textField.text = [NSString stringWithFormat:@"¥%.2f",money];
    self.coupon.money = @(money);
}

#pragma mark - BSDatePickerViewDelegate
- (void)didDatePicker:(BSDatePickerView *)pickerView sureSelectedDate:(NSDate *)date
{
    self.coupon.expiredDate = [date dateStringWithFormatter:@"yyyy-MM-dd"];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SectionRow_date inSection:Section_one]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - TextViewCellDelegate
- (void)didTextViewBeginEdit:(UITextView *)textView;
{
    self.hideKeyboardBtn.hidden = false;
}

- (void)didTextViewEndEdit:(UITextView *)textView
{
    self.coupon.remarks = textView.text;
}

#pragma mark - hideKeyboard
- (void)hideKeyboard:(UIButton *)btn
{
    self.hideKeyboardBtn.hidden = true;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
#pragma mark - giveBtnPressed
- (IBAction)giveBtnPressed:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"template_id"] = self.cardTemplate.template_id;
    params[@"mobile"] = self.givePeople.mobile;
    params[@"member_name"] = self.givePeople.member_name;
    params[@"member_id"] = self.givePeople.member_id;
    params[@"shop_id"] = self.givePeople.shop_id;
    
    if ([self.cardTemplate.is_customize boolValue]) {
        if (fabs([self.coupon.money floatValue] - [self.cardTemplate.money floatValue]) > 0.01) {
            params[@"amount"] = self.coupon.money;
        }
        
        if (![self.coupon.expiredDate isEqualToString:self.cardTemplate.expire_date]) {
            params[@"invalid_date"] = self.coupon.expiredDate;
        }
        
        params[@"remark"] = self.coupon.remarks;
    }
    
    BSTemplateGiveRequest *request = [[BSTemplateGiveRequest alloc] initWithParams:params];
    request.type = TemplateType_card;
    [request execute];
    [[CBLoadingView shareLoadingView] show];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
