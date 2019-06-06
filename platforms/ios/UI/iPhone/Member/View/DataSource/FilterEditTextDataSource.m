//
//  FilterEditTextDataSource.m
//  Boss
//
//  Created by lining on 16/5/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FilterEditTextDataSource.h"
#import "FilterEditCell.h"
#import "FilterBtnCell.h"
#import "BSDatePickerView.h"
#import "NSDate+Formatter.h"

@interface FilterEditTextDataSource ()<UITextFieldDelegate,FilterBtnCellDelegate,BSDatePickerViewDelegate>
{
    NSIndexPath *selectedIndexPath;
}
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) BSDatePickerView *pickerView;
@end

@implementation FilterEditTextDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (BSDatePickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [BSDatePickerView createView];
        _pickerView.datePicker.datePickerMode = UIDatePickerModeDate;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (CGFloat)getHeight
{
    return 50 * self.titles.count + 44;
}

- (NSInteger)numberOfRow
{
//    if ([self.type isEqualToString:FilterTypeShopCount]) {
//        return 1;
//    }
//    else
//    {
//        return 2;
//    }
    return self.titles.count + 1;

}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)setType:(NSString *)type
{
    _type = type;
    if ([self.type isEqualToString:FilterTypeShopCount]) {
        self.titles = @[@"多少天内未到店",@"多少天内到店"];
    }
    else if ([self.type isEqualToString:FilterTypeHuoyue]) {
        self.titles = @[@"活跃会员阀值"];
    }
    else if ([self.type isEqualToString:FilterTypeYue]) {
        self.titles = @[@"储值余额（大于）",@"储值余额（小于）"];
    }
    else if ([self.type isEqualToString:FilterTypeChongzhi]) {
        self.titles = @[@"累计充值（大于）",@"累计充值（小于）"];
    }
    else if ([self.type isEqualToString:FilterTypeConsume])
    {
        self.titles = @[@"累计消费（大于）",@"累计消费（小于）"];
    }
    else if ([self.type isEqualToString:FilterTypeZhuce]) {
        self.titles = @[@"注册日期（起始）",@"注册日期（结束）"];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRow];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.titles.count) {
        FilterBtnCell *btnCell = [tableView dequeueReusableCellWithIdentifier:@"FilterBtnCell"];
        if (btnCell == nil) {
            btnCell = [FilterBtnCell createCell];
        }
        btnCell.delegate = self;
        return btnCell;
    }
    else
    {
        FilterEditCell *editCell = [tableView dequeueReusableCellWithIdentifier:@"FilterEditCell"];
        if (editCell == nil) {
            editCell = [FilterEditCell createCell];
            editCell.selectionStyle = UITableViewCellSelectionStyleNone;
            editCell.backgroundColor = [UIColor clearColor];
            
            editCell.valueEditText.keyboardType = UIKeyboardTypeDecimalPad;
            editCell.valueEditText.returnKeyType = UIReturnKeyDone;
            editCell.valueEditText.tag = 101 + indexPath.row;
        }
        editCell.valueEditText.delegate = self;
        editCell.valueEditText.background = [UIImage imageNamed:@"member_filter_text_bg.png"];
        editCell.nameLabel.text = [self.titles objectAtIndex:indexPath.row];
        editCell.nameLabel.textColor = COLOR(72, 72, 72, 1);
        editCell.valueEditText.enabled = true;
        if ([self.type isEqualToString:FilterTypeZhuce]) {
            editCell.valueEditText.enabled = false;
            [self pickerView];
        }
        else if ([self.type isEqualToString:FilterTypeShopCount])
        {
            if (indexPath.row == 0) {
                if (self.maxValue.length > 0) {
                    editCell.valueEditText.enabled = false;
                    editCell.valueEditText.background = [UIImage imageNamed:@"member_filter_text_gray_bg.png"];
                    editCell.nameLabel.textColor = [UIColor grayColor];
                }
            }
            else if (indexPath.row == 1)
            {
                if (self.minValue.length > 0) {
                    editCell.valueEditText.enabled = false;
                    editCell.valueEditText.background = [UIImage imageNamed:@"member_filter_text_gray_bg.png"];
                    editCell.nameLabel.textColor = [UIColor grayColor];
                }
            }
            
        }
        if (indexPath.row == self.titles.count - 1) {
            editCell.cellLine.hidden = true;
        }
        else
        {
            editCell.cellLine.hidden = false;
        }
        
        if (indexPath.row == 0) {
            editCell.valueEditText.text = self.minValue;
        }
        else
        {
            editCell.valueEditText.text = self.maxValue;
        }
        return editCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.titles.count) {
        return 44;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type isEqualToString:FilterTypeZhuce]) {
        NSLog(@"indexPath");
        selectedIndexPath = indexPath;
        NSDate *date = nil;
        if (indexPath.row == 0) {
            self.pickerView.date = [NSDate dateFromString:self.minValue formatter:@"yyyy-MM-dd"];
        }
        else
        {
            date = [NSDate dateFromString:self.maxValue formatter:@"yyyy-MM-dd"];
        }
        self.pickerView.tag = 101 + indexPath.row;
        [self.pickerView show];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    NSLog(@"-------%s, %p--------",__FUNCTION__,textField);
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"replacementString: %@ - range: %@",string,NSStringFromRange(range));
    
    if ([self.type isEqualToString: FilterTypeShopCount]) {
        
        if (range.location == 0 && range.length == 1) {
            NSInteger idx = textField.tag - 101;
            if (idx == 0) {
                FilterEditCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                cell.valueEditText.enabled = true;
                cell.nameLabel.textColor = COLOR(72, 72, 72, 1);
                cell.valueEditText.background = [UIImage imageNamed:@"member_filter_text_bg.png"];
            }
            else
            {
                FilterEditCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.valueEditText.enabled = true;
                cell.nameLabel.textColor = COLOR(72, 72, 72, 1);
                
                cell.valueEditText.background = [UIImage imageNamed:@"member_filter_text_bg.png"];
            }
            
        }
        
        if (range.location == 0 && range.length == 0) {
             NSInteger idx = textField.tag - 101;
            if (idx == 0) {
                FilterEditCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                cell.valueEditText.enabled = false;
                cell.nameLabel.textColor = [UIColor grayColor];
                cell.valueEditText.background = [UIImage imageNamed:@"member_filter_text_gray_bg.png"];
            }
            else
            {
                FilterEditCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.valueEditText.enabled = false;
                cell.nameLabel.textColor = [UIColor grayColor];
                cell.valueEditText.background = [UIImage imageNamed:@"member_filter_text_gray_bg.png"];
            }
        }

    }
    
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger idx = textField.tag - 101;
    if (textField.text.length == 0) {
        if (idx == 0) {
            self.minValue = nil;
        }
        else
        {
            self.maxValue = nil;
        }
        if ([self.type isEqualToString: FilterTypeShopCount]) {
//            [self.tableView reloadData];
        }
        return;
    }
    if ([self.type isEqualToString: FilterTypeShopCount] || [self.type isEqualToString:FilterTypeHuoyue]) {
        textField.text = [NSString stringWithFormat:@"%d",[textField.text integerValue]];
    }
    else
    {
        textField.text = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
    }
   
    
    if (idx == 0) {
        self.minValue = textField.text;
    }
    else
    {
        self.maxValue = textField.text;
    }
    
    if ([self.type isEqualToString: FilterTypeShopCount]) {
//        [[UIApplication sharedApplication].keyWindow endEditing:YES];
//        [self.tableView reloadData];
    }

}

#pragma mark - FilterBtnCellDelegate
- (void)didCancelBtnPressed:(UIButton *)btn
{
    NSLog(@"%s",__FUNCTION__);
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    self.maxValue = nil;
    self.minValue = nil;
    if ([self.delegate respondsToSelector:@selector(didFilterCancelBtnPressed:)]) {
        [self.delegate didFilterCancelBtnPressed:self];
    }
}

- (void)didSureBtnPressed:(UIButton *)btn
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(didFilterSureBtnPressed:)]) {
        [self.delegate didFilterSureBtnPressed:self];
    }
}

#pragma mark - BSDatePickerViewDelegate
- (void)didDatePicker:(BSDatePickerView *)pickerView sureSelectedDate:(NSDate *)date
{
    if (pickerView.tag - 101 == 0) {
        self.minValue = [date dateStringWithFormatter:@"yyyy-MM-dd"];
    }
    else if (pickerView.tag - 101 == 1)
    {
        self.maxValue = [date dateStringWithFormatter:@"yyyy-MM-dd"];
    }
    [self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didDatePicker:(BSDatePickerView *)pickerView cancelSelectedDate:(NSDate *)orginDate
{
    if (pickerView.tag - 101 == 0) {
        self.minValue = [orginDate dateStringWithFormatter:@"yyyy-MM-dd"];
    }
    else if (pickerView.tag - 101 == 1)
    {
        self.maxValue = [orginDate dateStringWithFormatter:@"yyyy-MM-dd"];
    }
    [self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}
@end
