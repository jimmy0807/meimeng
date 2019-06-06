//
//  GiveCardViewController.m
//  Boss
//
//  Created by lining on 15/10/29.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "GiveCardViewController.h"
#import "GiveCell.h"
#import "UIView+Frame.h"

#import "PadProjectConstant.h"
#import "GiveRemarkViewController.h"
#import "Remark.h"
#import "CouponObject.h"
#import "BSGiveRequest.h"
#import "CBLoadingView.h"
#import "BSTemplateGiveRequest.h"

typedef enum KSection
{
    KSection_money,
    KSection_availd,
    KSection_mark,
    KSection_num,
    KSection_clause,
}TicketSection;
@interface GiveCardViewController ()<UITableViewDataSource,UITableViewDelegate,GiveCellDelegate,GiveRemarkDelegate>
{
    BOOL dateSelected;
}
@property (strong, nonatomic) NSMutableArray *remarks;
@property (strong, nonatomic) NSMutableArray *caluses;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) CouponObject *coupon;
@end

@implementation GiveCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.remarks = [NSMutableArray array];
    self.caluses = [NSMutableArray array];
    
    self.coupon = [[CouponObject alloc] initWithTemplate:self.cardTemplate];
    
//    if (self.coupon.short_description.length > 0) {
//        Remark *remark = [[Remark alloc] init];
//        remark.text = self.coupon.short_description;
//        [self.remarks addObject:remark];
//    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return KSection_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == KSection_money) {
        return 1;
    }
    else if (section == KSection_availd)
    {
        return 1;
    }
    else if (section == KSection_mark)
    {
        if ([self.cardTemplate.is_customize boolValue]) {
            return self.remarks.count + 1;
        }
        else
        {
            return self.remarks.count;
        }
    }
    else if (section == KSection_clause)
    {
        return self.caluses.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == KSection_money) {
        NSString *identifier = @"money_cell";
        UITableViewCell *money_cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (money_cell == nil) {
            money_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            money_cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 57)];
            textField.delegate = self;
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            textField.borderStyle = UITextBorderStyleNone;
            textField.backgroundColor = [UIColor clearColor];
            textField.font = [UIFont systemFontOfSize:15];
            textField.tag = 101;
            textField.textColor = COLOR(166, 166, 166, 1);
            textField.textAlignment = NSTextAlignmentCenter;
            textField.clearsOnBeginEditing = true;
            
            [money_cell.contentView addSubview:textField];
        }
        UITextField *textField = (UITextField *)[money_cell.contentView viewWithTag:101];
        textField.text = [NSString stringWithFormat:@"￥%.2f",[self.coupon.money floatValue]];
        [self cellBg:money_cell withRow:row minRow:0 maxRow:0];
        if ([self.cardTemplate.is_customize boolValue]) {
            textField.enabled = true;
        }
        else
        {
            textField.enabled = false;
        }
        
        return money_cell;
    }
    else if (section == KSection_availd)
    {
        NSString *availd_identifier = @"availd_cell";
        UITableViewCell *availd_cell = [tableView dequeueReusableCellWithIdentifier:availd_identifier];
        if (availd_cell == nil) {
            availd_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:availd_identifier];
            availd_cell.backgroundColor = [UIColor clearColor];
            availd_cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 57)];
            dateLabel.backgroundColor = [UIColor clearColor];
            dateLabel.font = [UIFont systemFontOfSize:15];
            dateLabel.tag = 101;
            dateLabel.textColor = COLOR(166, 166, 166, 1);
            dateLabel.textAlignment = NSTextAlignmentCenter;
            [availd_cell.contentView addSubview:dateLabel];
            
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            datePicker.y = 57;
            datePicker.x = (tableView.frame.size.width - datePicker.frame.size.width)/2.0;
            datePicker.tag = 102;
            
            datePicker.datePickerMode = UIDatePickerModeDate;
            [availd_cell.contentView addSubview:datePicker];
            
        }
        UILabel *dateLabel = (UILabel *)[availd_cell.contentView viewWithTag:101];
        UIDatePicker *datePicker = (UIDatePicker *)[availd_cell.contentView viewWithTag:102];
        [datePicker addTarget:self action:@selector(didDateValueChanged:) forControlEvents:UIControlEventValueChanged];
        if (dateSelected) {
            datePicker.hidden = false;
        }
        else
        {
            datePicker.hidden = true;
        }
        
        if (self.coupon.expiredDate == nil) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            self.coupon.expiredDate = [dateFormatter stringFromDate:[NSDate date]];
        }
        
        dateLabel.text = self.coupon.expiredDate;
        [self cellBg:availd_cell withRow:row minRow:0 maxRow:0];

        return availd_cell;
    }
    else
    {
        static NSString *identifier = @"GiveCell";
        GiveCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSLog(@"新建Cell");
            cell = [GiveCell createCell];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            NSLog(@"重用");
        }
        if (section == KSection_mark)
        {
            if (row == self.remarks.count) {
                [cell lastItem];
            }
            else
            {
                Remark *remark = [self.remarks objectAtIndex:row];
                [cell itemWithName:remark.text];
            }
            
            
            [self cellBg:cell withRow:row minRow:0 maxRow:self.remarks.count];
        }
        else if (section == KSection_clause)
        {
            if (row == self.caluses.count) {
                [cell lastItem];
            }
            else
            {
                Remark *caluse = [self.caluses objectAtIndex:row];
                [cell itemWithName:caluse.text];
            }
            
            
            [self cellBg:cell withRow:row minRow:0 maxRow:self.caluses.count];
        }
        return cell;
    }
    
    return nil;
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
    if (indexPath.section == KSection_availd) {
        if (dateSelected) {
            return 216 + 57;
        }
        else
        {
            return 57;
        }
    }
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
    label.textColor = COLOR(153, 174, 175,1);
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    if (section == KSection_money) {
        label.text = @"卡内金额";
    }
    else if (section == KSection_availd)
    {
        label.text = @"有效期";
    }
    else if (section == KSection_mark)
    {
        label.text = @"备注信息";
    }
    else if (section == KSection_clause)
    {
        label.text = @"使用条款";
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
//    if (![self.cardTemplate.is_customize boolValue]) {
//        return;
//    }
    
    if (section == KSection_money) {
    }
    else if (section == KSection_availd)
    {
        dateSelected = !dateSelected;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (section == KSection_mark)
    {
        GiveRemarkViewController *giveRemarkVC = [[GiveRemarkViewController alloc] initWithNibName:@"GiveRemarkViewController" bundle:nil];
        if (row < self.remarks.count) {
            giveRemarkVC.remark = [self.remarks objectAtIndex:row];
        }
        giveRemarkVC.delegate = self;
        giveRemarkVC.type = kRemarkType_remark;
        [self.navigationController pushViewController:giveRemarkVC animated:YES];
    }
    else if (section == KSection_clause)
    {
        GiveRemarkViewController *giveRemarkVC = [[GiveRemarkViewController alloc] initWithNibName:@"GiveRemarkViewController" bundle:nil];
        if (row < self.caluses.count) {
            giveRemarkVC.remark = [self.caluses objectAtIndex:row];
        }
        giveRemarkVC.delegate = self;
        giveRemarkVC.type = kRemarkType_clause;
        [self.navigationController pushViewController:giveRemarkVC animated:YES];
    }

}


#pragma mark - date value changed
- (void)didDateValueChanged:(UIDatePicker *)datePicker
{
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:KSection_availd]];
    UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:101];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.coupon.expiredDate = [dateFormatter stringFromDate:datePicker.date];
    dateLabel.text = self.coupon.expiredDate;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.coupon.money = @([textField.text floatValue]);
    textField.text = [NSString stringWithFormat:@"￥%.2f",[self.coupon.money floatValue]];
}


#pragma mark - GiveCellDelegate
- (void)didDeleteBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == KSection_mark)
    {
        [self.remarks removeObjectAtIndex:row];
    }
    else if (section == KSection_clause)
    {
        [self.caluses removeObjectAtIndex:row];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - GiveRemarkDelegate
- (void)didSureAddRemark:(Remark *)remark type:(kRemarkType) type
{
    NSInteger section = 0;
    if (type == kRemarkType_remark) {
        [self.remarks addObject:remark];
        section = KSection_mark;
    }
    else if (type == kRemarkType_clause)
    {
        [self.caluses addObject:remark];
        section = KSection_clause;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didSureEditRemark:(Remark *)remark type:(kRemarkType) type
{
    NSInteger section = 0;
    if (type == kRemarkType_remark) {

        section = KSection_mark;
        
    }
    else if (type == kRemarkType_clause)
    {

        section = KSection_clause;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendBtnPressed:(UIButton *)sender {
//    NSString *marks = [NSString string];
    
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
        else if ( self.cardTemplate.expire_date.length > 1 )
        {
            params[@"invalid_date"] = self.cardTemplate.expire_date;
        }
        else
        {
            if ( self.coupon.expiredDate.length < 2 )
            {
                UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请选择日期" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [v show];
                return;
            }

        }
        
        NSMutableString *marks = [NSMutableString string];
        for (Remark *mark in self.remarks) {
            [marks stringByAppendingFormat:@"%@\n",mark.text];
        }
    
        params[@"remark"] = marks;
    }
    else
    {
        if ( self.cardTemplate.expire_date.length > 1 )
        {
            params[@"invalid_date"] = self.cardTemplate.expire_date;
        }
        else
        {
            if ( self.coupon.expiredDate.length < 2 )
            {
                UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请选择日期" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [v show];
                return;
            }
            
        }
    }
    BSTemplateGiveRequest *request = [[BSTemplateGiveRequest alloc] initWithParams:params];
    request.type = TemplateType_card;
    [request execute];
    [[CBLoadingView shareLoadingView] show];
    
//    for (NSString *mark in self.remarks) {
//        marks = [marks stringByAppendingFormat:@"\n%@",mark];
//    }
//    
//    for (NSString *caulse  in self.caluses) {
//        marks = [marks stringByAppendingFormat:@"\n%@",caulse];
//    }
//    
//    self.coupon.remarks = marks;
//    [[CBLoadingView shareLoadingView] show];
//    BSGiveRequest *request = [[BSGiveRequest alloc] initWithOperate:self.operate coupon:self.coupon];
////    request.items = self.paramItems;
//    [request execute];
}

@end
