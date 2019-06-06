//
//  ImportEditViewDataSource.m
//  meim
//
//  Created by lining on 2016/12/14.
//
//

#import "ImportEditViewDataSource.h"
#import "ImportEditCell.h"
#import "SwitchCell.h"
#import "ItemArrowCell.h"
#import "BSCardItem.h"
#import "BSDatePickerView.h"
#import "NSDate+Formatter.h"

typedef enum InfoRow
{
    InfoRow_price,
    InfoRow_count,
    InfoRow_switch,
    InfoRow_date,
    InfoRow_num
}InfoRow;

@interface ImportEditViewDataSource ()<UITextFieldDelegate,SwitchCellDelegate,BSDatePickerViewDelegate>
@property (nonatomic, strong) BSCardItem *bsCardItem;
@property (nonatomic, strong) BSDatePickerView *datePickerView;

@end

@implementation ImportEditViewDataSource

@synthesize editView = _editView;
@synthesize editObject = _editObject;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.datePickerView = [BSDatePickerView createView];
        self.datePickerView.delegate = self;
    }
    return self;
}

- (void)setEditView:(BSEditView *)editView
{
    _editView = editView;
    [editView.tableView registerNib:[UINib nibWithNibName:@"ImportEditCell" bundle:nil] forCellReuseIdentifier:@"ImportEditCell"];
    [editView.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [editView.tableView registerNib:[UINib nibWithNibName:@"ItemArrowCell" bundle:nil] forCellReuseIdentifier:@"ItemArrowCell"];
}

- (BSEditView *)editView
{
    return _editView;
}

- (void)setEditObject:(NSObject *)editObject
{
    if ([editObject isKindOfClass:[BSCardItem class]]) {
//        _editObject = editObject;
        BSCardItem *cardItem = (BSCardItem *)editObject;
        self.bsCardItem = [[BSCardItem alloc] init];
        self.bsCardItem.productID = cardItem.productID;
        self.bsCardItem.productPrice = cardItem.productPrice;
        self.bsCardItem.unitPrice = cardItem.unitPrice;
        self.bsCardItem.productName = cardItem.productName;
        self.bsCardItem.unitPrice = cardItem.unitPrice;
        self.bsCardItem.importQty = cardItem.importQty;
        self.bsCardItem.isLimited = cardItem.isLimited;
        self.bsCardItem.limitedDate = cardItem.limitedDate;
        self.bsCardItem.remark = cardItem.remark;
        
        self.editView.titleLabel.text = cardItem.productName;
        if (self.bsCardItem.isLimited) {
            self.editView.tableViewHeight = 3*64 + 44;
        }
        else
        {
            self.editView.tableViewHeight = 3*64;
        }
        _editObject = self.bsCardItem;
        [self.editView.tableView reloadData];
    }
    else
    {
        NSLog(@"====ImportEditView error====");
    }
}

- (NSObject *)editObject
{
    return self.bsCardItem;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.bsCardItem.isLimited) {
        return InfoRow_num;
    }
    else
    {
        return InfoRow_date;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == InfoRow_price) {
        ImportEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImportEditCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = @"购买单价(¥)";
        cell.valueTextField.text = [NSString stringWithFormat:@"%.2f",self.bsCardItem.unitPrice];
        cell.valueTextField.clearsOnBeginEditing = true;
        cell.valueTextField.delegate = self;
        cell.valueTextField.tag = 101 + indexPath.row;
        return cell;
    }
    else if (indexPath.row == InfoRow_count)
    {
        ImportEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImportEditCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = @"剩余数量";
        cell.valueTextField.clearsOnBeginEditing = true;
        cell.valueTextField.delegate = self;
        cell.valueTextField.text = [NSString stringWithFormat:@"%d",self.bsCardItem.importQty];
    
        cell.valueTextField.tag = 101 + indexPath.row;
        return cell;
    }
    else if (indexPath.row == InfoRow_switch)
    {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.nameLabel.text = @"有效期内无限使用";
        cell.isOn = self.bsCardItem.isLimited;
        return cell;
    }
    else if (indexPath.row == InfoRow_date)
    {
        ItemArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemArrowCell"];
        cell.lineImgView.hidden = true;
        cell.nameLabel.font = [UIFont systemFontOfSize:14];
        cell.nameLabel.textColor = [UIColor grayColor];
        cell.nameLabel.text = @"有效期至";
        if (self.bsCardItem.limitedDate) {
            cell.valueLabel.text = [self.bsCardItem.limitedDate dateStringWithFormatter:@"yyyy-MM-dd"];
        }
        else
        {
            cell.valueLabel.text = @"请选择";
        }
        return cell;
    }
    return nil;
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == InfoRow_date) {
        return 44;
    }
    else
    {
        return 65;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == InfoRow_date) {
        [self.datePickerView show];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int row = textField.tag - 101;
    if (row == InfoRow_price) {
        CGFloat price = textField.text.floatValue;
        self.bsCardItem.unitPrice = price;
        
        textField.text = [NSString stringWithFormat:@"%.2f",price];
    }
    else if (row == InfoRow_count)
    {
        NSInteger count = textField.text.integerValue;
        self.bsCardItem.importQty = count;
        textField.text = [NSString stringWithFormat:@"%d",count];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

#pragma mark - SwitchCellDelegate

- (void)switchBtnValueChanged:(BOOL)isOn
{
    self.bsCardItem.isLimited = isOn;
    [self.editView.tableView reloadData];
    if (self.bsCardItem.isLimited) {
        self.editView.tableViewHeight = 3*64 + 44;
    }
    else
    {
        self.editView.tableViewHeight = 3*64;
    }
    
    if (self.bsCardItem.isLimited && self.bsCardItem.limitedDate == nil) {
        [self.datePickerView show];
    }
}

#pragma mark - BSDatePickerViewDelegate
- (void)didDatePicker:(BSDatePickerView *)pickerView sureSelectedDate:(NSDate *)date
{
    self.bsCardItem.limitedDate = date;
    [self.editView.tableView reloadData];
}

- (void)didDatePicker:(BSDatePickerView *)pickerView cancelSelectedDate:(NSDate *)orginDate
{
    self.bsCardItem.limitedDate = orginDate;
    [self.editView.tableView reloadData];
}



@end
