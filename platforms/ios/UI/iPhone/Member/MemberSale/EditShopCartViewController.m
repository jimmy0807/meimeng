//
//  EditShopCartViewController.m
//  Boss
//
//  Created by lining on 16/7/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "EditShopCartViewController.h"
#import "BSEditCell.h"
#import "TechnicianCell.h"
#import "CountCell.h"
#import "TextFieldCell.h"
#import "NSDate+Formatter.h"
#import "BSHandleBookRequest.h"
#import "CBLoadingView.h"
#import "BSSelectedView.h"
#import "BSPickerView.h"
#import "CBMessageView.h"
#import "OperateManager.h"


@interface EditShopCartViewController ()<CountCellDelegate,TechnicianCellDelegate,BSSelectedViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,BSPickerViewDelegate>
{
    NSInteger section_detail,section_subject,section_technician,section_num;
    
    NSInteger row_detail,row_total,row_count,row_discount,row_num;
}

@property (nonatomic, strong) CDProjectItem *item;
@property (nonatomic, assign) CGFloat totalMoney;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat discount;
@property (nonatomic, strong) CDStaff *technician;
@property (nonatomic, assign) NSDate *appointDate;
@property (nonatomic, assign) CGFloat priceUnit;
@property (nonatomic, strong) NSArray *technicians;

@property (nonatomic, strong) BSSelectedView *selectedView;
@property (nonatomic, strong) BSPickerView *pickerView;
@end

@implementation EditShopCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:@"确定"];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
//    CBRightBarButton *rightBtn = [

    self.title = @"详情";
    
    if (self.product) {
        self.item = self.product.product;
        self.priceUnit = self.product.product.totalPrice.floatValue;
        self.count = self.product.product_qty.integerValue;
        self.totalMoney = self.product.product_price.floatValue * self.count;
        
        self.discount = (self.product.product_discount == nil || self.product.product_discount.floatValue == 0) ? 10.0 : self.product.product_discount.floatValue;
        
        if (self.item.bornCategory.integerValue == kPadBornCategoryProject)
        {
            if (self.product.book.technician_id.integerValue != 0)
            {
                self.technician = [[BSCoreDataManager currentManager] findEntity:@"CDStaff" withValue:self.product.book.technician_id forKey:@"staffID"];
                if (self.technician)
                {
                    self.technician = [[BSCoreDataManager currentManager] insertEntity:@"CDStaff"];
                    self.technician.staffID = self.product.book.technician_id;
                    self.technician.name = self.product.book.technician_name;
                }
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            self.appointDate = [dateFormatter dateFromString:self.product.book.start_date];
        }
    }
    else if (self.useItem)
    {
        self.item = self.useItem.projectItem;
        self.count = self.useItem.useCount.integerValue;
        if (self.item.bornCategory.integerValue == kPadBornCategoryProject)
        {
            if (self.useItem.book.technician_id.integerValue != 0)
            {
                self.technician = [[BSCoreDataManager currentManager] findEntity:@"CDStaff" withValue:self.useItem.book.technician_id forKey:@"staffID"];
                if (self.technician)
                {
                    self.technician = [[BSCoreDataManager currentManager] insertEntity:@"CDStaff"];
                    self.technician.staffID = self.useItem.book.technician_id;
                    self.technician.name = self.useItem.book.technician_name;
                }
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            self.appointDate = [dateFormatter dateFromString:self.useItem.book.start_date];
        }
    }
    
    [self initSectionData];
    [self initFirstRowData];
    
    [self initView];
    
    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self registerNofitificationForMainThread:kBSCreateBookResponse];
    [self registerNofitificationForMainThread:kBSEditBookResponse];
    [self registerNofitificationForMainThread:kBSDeleteBookResponse];
}

#pragma mark - initData
- (void) initSectionData
{
    section_detail = 0;
    section_technician = -1;
    section_subject = -1;
   
    section_num = section_detail + 1;
    
    
    if (self.item.bornCategory.integerValue == kPadBornCategoryProject) {
        section_technician = section_num;
        section_num ++;
    }
    else
    {
        section_technician = -1;
    }
    
    if (self.item.bornCategory.integerValue == kPadBornCategoryCourses || self.item.bornCategory.integerValue == kPadBornCategoryPackage) {
        if (self.item.subRelateds.count > 0) {
            section_subject = section_num;
            section_num ++;
        }
        else
        {
            section_subject = -1;
        }
    }
    
}

- (void)initFirstRowData
{
    row_detail = 0;
    row_total = 1;
    row_count = 2;
    row_discount = 3;
    row_num = 4;
    
    if (self.useItem)
    {
        row_detail = 0;
        row_count = 1;
        row_num = 2;
        
        row_total = -1;
        row_discount = -1;
    }
}

#pragma mark - initView
- (void)initView
{
    self.selectedView = [BSSelectedView createViewWithTitle:@"请选择技师"];
    self.selectedView.delegate = self;
    
    self.pickerView = [BSPickerView createViewWithTitle:@"选择上钟时间"];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    [self reloadSelectedView];
    [self reloadPickerView];
    
}

- (void)reloadSelectedView
{
    self.technicians = [[BSCoreDataManager currentManager] fetchBookStaffs];
    for (int i = 0; i < self.technicians.count; i++)
    {
        CDStaff *staff = [self.technicians objectAtIndex:i];
        NSArray *books = [[BSCoreDataManager currentManager] fetchLatestBooksWithTechnician:staff];
        staff.latestBookTime = LS(@"PadTechnicianNoReservation");
        if (books.count != 0)
        {
            CDBook *latestBook = [books objectAtIndex:0];
            if (latestBook && latestBook.start_date.length >= 16 && latestBook.end_date.length >= 16)
            {
                staff.latestBookTime = [NSString stringWithFormat:LS(@"PadTechnicianLatestReservation"), [latestBook.start_date substringWithRange:NSMakeRange(11, 5)], [latestBook.end_date substringWithRange:NSMakeRange(11, 5)]];
            }
        }
    }
    
    NSMutableArray *stringArray = [NSMutableArray array];
    NSInteger currentIdx = -1;
    for (CDStaff *staff in self.technicians) {
        NSString *string = [NSString stringWithFormat:@"%@(%@)", staff.name, staff.latestBookTime];
        [stringArray addObject:string];
       
        if (self.technician.staffID.integerValue == staff.staffID.integerValue)
        {
            currentIdx = [self.technicians indexOfObject:staff];
            
            
        }
    }
    self.selectedView.currentSelectedIdx = currentIdx;
    self.selectedView.stringArray = stringArray;
}

- (void)reloadPickerView
{
    NSDate *date = [NSDate date];
    if (self.appointDate)
    {
        date = self.appointDate;
    }
//    [cell reloadPickerViewWithDateAndTime:date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *datestr = [dateFormatter stringFromDate:date];
    NSString *hourstr = [datestr substringWithRange:NSMakeRange(11, 2)];
    NSString *minutestr = [datestr substringWithRange:NSMakeRange(14, 2)];
    [self.pickerView.pickerView selectRow:hourstr.integerValue inComponent:0 animated:NO];
    [self.pickerView.pickerView selectRow:minutestr.integerValue inComponent:1 animated:NO];
}
#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    if (![self handleBook]) {
        [self saveItem];
    }
}


- (BOOL)handleBook
{
    if (self.member && self.item.bornCategory.integerValue == kPadBornCategoryProject) {
        CDBook *book;
        HandleBookType type;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSInteger projectTime = 0;
        if (self.useItem)
        {
            book = self.useItem.book;
            projectTime = self.useItem.projectItem.time.integerValue;
        }
        else
        {
            book = self.product.book;
            projectTime = self.product.product.time.integerValue;
        }
        
        if (book) {
            if (self.technician == nil || self.appointDate == nil)
            {
                type = HandleBookType_delete;
            }
            else
            {
                type = HandleBookType_edit;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                params[@"start_date"] = [dateFormatter stringFromDate:self.appointDate];
                NSTimeInterval startInterval = [self.appointDate timeIntervalSince1970];
                NSTimeInterval endInterval = startInterval + ((projectTime != 0) ? (projectTime * 60) : (60.0 * 60.0));
                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endInterval];
                params[@"end_date"] = [dateFormatter stringFromDate:endDate];
                params[@"technician_id"] = self.technician.staffID;
            }
        }
        else
        {
            if (self.technician == nil || self.appointDate == nil)
            {
                return false;
            }
            book = [[BSCoreDataManager currentManager] insertEntity:@"CDBook"];
            type = HandleBookType_create;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            params[@"start_date"] = [dateFormatter stringFromDate:self.appointDate];
            NSTimeInterval startInterval = [self.appointDate timeIntervalSince1970];
            NSTimeInterval endInterval = startInterval + ((projectTime != 0) ? (projectTime * 60) : (60.0 * 60.0));
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endInterval];
            params[@"end_date"] = [dateFormatter stringFromDate:endDate];
            params[@"telephone"] = self.member.mobile;
            params[@"member_name"] = self.member.memberName;
            params[@"technician_id"] = self.technician.staffID;
            params[@"product_ids"] = @[@[@(kBSDataExist), @(NO), @[self.item.itemID]]];
            params[@"active"] = [NSNumber numberWithBool:YES];
            params[@"state"] = @"approved";
            [params setObject:@(YES) forKey:@"is_reservation_bill"];
        }
        
        BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:book];
        request.type = type;
        request.params = params;
        [request execute];
        [[CBLoadingView shareLoadingView] show];
        return true;
    }
    return false;
}

- (void)saveItem
{
    if (self.useItem) {
        self.useItem.useCount = [NSNumber numberWithInteger:self.count];
        if (self.technician)
        {
            self.useItem.book.technician_id = self.technician.staffID;
            self.useItem.book.technician_name = self.technician.name;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            self.useItem.book.start_date = [dateFormatter stringFromDate:self.appointDate];
        }
        
    }
    else if (self.product)
    {
        self.product.product_qty = [NSNumber numberWithInteger:self.count];
        self.product.product_discount = [NSNumber numberWithFloat:self.discount];
        self.product.product_price = [NSNumber numberWithFloat:self.totalMoney/self.count];
        if (self.technician)
        {
            self.product.book.technician_id = self.technician.staffID;
            self.product.book.technician_name = self.technician.name;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            self.product.book.start_date = [dateFormatter stringFromDate:self.appointDate];
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kShopCartDataChanged" object:nil];
}

#pragma mark - NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchStaffResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.technicians = [[BSCoreDataManager currentManager] fetchBookStaffs];
//            if (isTechnician)
//            {
//                [self.detailTableView reloadSections:[NSIndexSet indexSetWithIndex:kProjectDetailSectionTechnician] withRowAnimation:UITableViewRowAnimationNone];
//            }
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
    else if ([notification.name isEqualToString:kBSCreateBookResponse] || [notification.name isEqualToString:kBSEditBookResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            CDBook *book = [[BSCoreDataManager currentManager] findEntity:@"CDBook" withValue:notification.object forKey:@"book_id"];
            book.isUsed = [NSNumber numberWithBool:YES];
            
            BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:book];
            request.type = HandleBookType_billed;
            [request execute];
            
            if (self.useItem)
            {
                self.useItem.book = book;
            }
            else
            {
                self.product.book = book;
            }
            [self saveItem];
        }
        else
        {
//            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
//            if(message.length != 0)
//            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
//                                                                    message:message
//                                                                   delegate:nil
//                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
//                                                          otherButtonTitles:nil, nil];
//                [alertView show];
//            }
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"预约失败"];
            [messageView show];
            [self saveItem];
        }
    }
    else if ([notification.name isEqualToString:kBSDeleteBookResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            if (self.useItem)
            {
                self.useItem.book = nil;
            }
            else
            {
                self.product.book = nil;
            }
//            [self saveItem];
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
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
    if (section == section_detail) {
        return row_num;
    }
    else if (section == section_technician)
    {
        return 1;
    }
    else if (section == section_subject)
    {
        return self.item.subRelateds.count + 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == section_detail && row == row_count) {
        CountCell *countCell = [tableView dequeueReusableCellWithIdentifier:@"CountCell"];
        
        if (countCell == nil) {
            countCell = [CountCell createCell];
            countCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        countCell.minCount = 1;
        countCell.count = self.count;
        countCell.delegate = self;
        if (self.useItem) {
            countCell.maxCount = self.useItem.totalCount.integerValue;
        }
        return countCell;
    }
    else if (section == section_technician)
    {
        TechnicianCell *technicianCell = [tableView dequeueReusableCellWithIdentifier:@"TechnicianCell"];
        if (technicianCell == nil) {
            technicianCell = [TechnicianCell createCell];
            technicianCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        technicianCell.delegate = self;
        if (self.technician.name.length > 0) {
            technicianCell.nameLabel.text = self.technician.name;
        }
        else
        {
            technicianCell.nameLabel.text = @"请选择";
        }
        
        if (self.appointDate) {
            technicianCell.dateLabel.text = [self.appointDate dateStringWithFormatter:@"yyyy-MM-dd HH:mm"];
            
        }
        else
        {
            technicianCell.dateLabel.text = @"上钟时间";
        }
        
        return technicianCell;
    }
    else
    {
        TextFieldCell *editCell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
        if (editCell == nil) {
            editCell = [TextFieldCell createCell];
        }
        editCell.valueTextFiled.tag = 1000*section + row;
        editCell.valueTextFiled.delegate = self;
        editCell.valueTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
        editCell.valueTextFiled.enabled = false;
        editCell.valueTextFiled.text = @"";
        editCell.titleLabel.textColor = COLOR(72, 72, 72, 1);
        editCell.titleLabel.font = [UIFont systemFontOfSize:15];
        if (section == section_detail) {
            if (row == row_detail) {
                editCell.titleLabel.textColor = [UIColor lightGrayColor];
                if (self.product) {
                     editCell.titleLabel.text = [NSString stringWithFormat:@"%@(单价:￥%.2f)",self.item.itemName,self.item.totalPrice.floatValue];
                }
                else
                {
                    editCell.titleLabel.text = [NSString stringWithFormat:@"%@",self.item.itemName];
                }
            }
            if (row == row_total) {
                editCell.titleLabel.text = @"总价(￥)";
                editCell.valueTextFiled.enabled = true;
                editCell.valueTextFiled.text = [NSString stringWithFormat:@"%.2f",self.totalMoney];
            }
            else if (row == row_discount)
            {
                editCell.titleLabel.text = @"折扣";
                editCell.valueTextFiled.enabled = true;
                editCell.valueTextFiled.text = [NSString stringWithFormat:@"%.2f",self.discount];
            }
        }
        else if (section == section_subject)
        {
            if (row == 0) {
                editCell.titleLabel.text = @"项目";
                editCell.titleLabel.textColor = [UIColor lightGrayColor];
            }
            else
            {
                CDProjectRelated *related = [self.item.subRelateds.allObjects objectAtIndex:row - 1];
                editCell.titleLabel.text = related.productName;
                editCell.valueTextFiled.text = [NSString stringWithFormat:@"x%d",related.quantity.integerValue];
            }
        }
        return editCell;
    }
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger row = textField.tag % 1000;
    NSInteger section = textField.tag / 1000;
    if (section == section_detail) {
        if (row == row_discount) {
            self.discount = [textField.text floatValue];
            self.totalMoney = self.priceUnit * self.count * self.discount/10.0;
            [self.tableView reloadData];
        }
        else if (row == row_total)
        {
            self.totalMoney = [textField.text floatValue];
        }
        
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == section_technician) {
        return 90;
    }
    if (indexPath.section == section_detail && indexPath.row == row_detail) {
        return 40;
    }
    
    if (indexPath.section == section_subject && indexPath.row == 0) {
        return 40;
    }
    
    return 50;
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

#pragma mark - TechnicianCellDelegate
- (void)didTechnicianArrowBtnSelected:(BOOL)selected
{
//    if (selected) {
//        [self.selectedView show];
//    }
//    else
//    {
//        [self.selectedView hide];
//    }
    [self.selectedView show];
}

- (void)didDateBtnSelected:(BOOL)selected
{
//    if (selected) {
//        
//    }
    [self.pickerView show];
}

#pragma mark - CountCellDelegate
- (void)didCountChanged:(NSInteger)count
{
    self.count = count;
    self.totalMoney = self.priceUnit * count * self.discount/10.0;
    [self.tableView reloadData];
}

#pragma mark - btn action
- (IBAction)deleteBtnPressed:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    
    CDBook *book;
    if (self.useItem) {
        if (self.useItem.book)
        {
            self.useItem.book.isUsed = @(NO);
            book = self.useItem.book;
        }
        
        NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[OperateManager shareManager].posOperate.useItems];
        [mutableSet removeObject:self.useItem];
        [OperateManager shareManager].posOperate.useItems = mutableSet;
       
    }
    else if (self.product)
    {
        if (self.product.book)
        {
            self.product.book.isUsed = @(NO);
            book = self.product.book;
        }

        NSMutableOrderedSet *mutableOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[OperateManager shareManager].posOperate.products];
        [mutableOrderedSet removeObject:self.product];
        [OperateManager shareManager].posOperate.products = mutableOrderedSet;
    }
    if (book.is_reservation_bill.boolValue)
    {
        BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:book];
        request.type = HandleBookType_delete;
        [request execute];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kShopCartDataChanged" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - BSPickerViewDelegate
- (void)didSureBtnPressed
{
    NSString *datestr = [[NSDate date] dateStringWithFormatter:@"yyyy-MM-dd"];
    datestr = [NSString stringWithFormat:@"%@ %d:%d:00", datestr, [self.pickerView.pickerView selectedRowInComponent:0], [self.pickerView.pickerView selectedRowInComponent:1]];
    //    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    self.appointDate = [NSDate dateFromString:datestr];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section_technician] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 24;
    }
    else if (component == 1)
    {
        return 60;
    }
    return 0;
}


#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%d点",row];
    }
    else if (component == 1)
    {
        return [NSString stringWithFormat:@"%d分",row];
    }
    return nil;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NSString *datestr = [[NSDate date] dateStringWithFormatter:@"yyyy-MM-dd"];
//    datestr = [NSString stringWithFormat:@"%@ %d:%d:00", datestr, [self.pickerView.pickerView selectedRowInComponent:0], [self.pickerView.pickerView selectedRowInComponent:1]];
////    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    
//    self.appointDate = [NSDate dateFromString:datestr];
    
}



#pragma mark - BSSelectedViewDelegate
- (void)didSelectedAtIndex:(NSInteger)index
{
    NSLog(@"--");
    self.technician = [self.technicians objectAtIndex:index];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section_technician] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
