//
//  GiveWeikaCouponViewController.m
//  Boss
//
//  Created by lining on 16/9/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GiveWeikaCouponViewController.h"
#import "TextFieldCell.h"
#import "ItemArrowCell.h"
#import "TextViewCell.h"
#import "BSDatePickerView.h"
#import "CouponObject.h"
#import "NSDate+Formatter.h"
#import "BSTemplateGiveRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "CouponProject.h"
#import "BSFetchCardTemplateProductsRequest.h"
#import "GiveCouponSelectedProductViewController.h"

#import "ItemArrowCell.h"
#import "PosOperateAddCell.h"
#import "TextFieldCell.h"

#import "GiveProjectCountEditView.h"
#import "BSSuccessViewController.h"


typedef enum Section
{
    Section_project,
    Section_date,
    Section_mark,
    Section_num
}Section;



@interface GiveWeikaCouponViewController ()<BSDatePickerViewDelegate,TextViewCellDelegate,UITextFieldDelegate,CouponSelectedProjectDelegate,GiveProjectCountEditDelegate>
@property (strong, nonatomic) CouponObject *coupon;
@property (strong, nonatomic) BSDatePickerView *datePickerView;
@property (strong, nonatomic) UIButton *hideKeyboardBtn;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) GiveProjectCountEditView *editView;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation GiveWeikaCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.title = @"赠送礼品券";
    
    self.editView = [GiveProjectCountEditView createViewAddInSuperView:self.view];
    self.editView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"TextFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemArrowCell" bundle:nil] forCellReuseIdentifier:@"ItemArrowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextViewCell" bundle:nil] forCellReuseIdentifier:@"TextViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PosOperateAddCell" bundle:nil] forCellReuseIdentifier:@"PosOperateAddCell"];
    
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
    
    BSFetchCardTemplateProductsRequest *request =  [[BSFetchCardTemplateProductsRequest alloc] initWithTemplate:self.cardTemplate];
    [request execute];
    
    
    [self registerNofitificationForMainThread:kBSGiveTicketResponse];
    [self registerNofitificationForMainThread:kBSFetchCardTemplateProductResponse];
    
    [self initData];
}

- (void)initData
{
    self.items = [NSMutableArray array];
    NSArray *templateItems = [[BSCoreDataManager currentManager] fetchCardTemplateProducts:self.cardTemplate];
    for (CDCardTemplateProduct *templateItem in templateItems) {
        CDProjectItem *item = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDProjectItem" withValue:templateItem.product_id forKey:@"itemID"];
        item.itemName = templateItem.product_name;
        CouponProject *project = [[CouponProject alloc] initWithItem:item];
        project.count = templateItem.qty.integerValue;
        [self.items addObject:project];
    }

}

#pragma mark - receivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSGiveTicketResponse]) {
        [[CBLoadingView shareLoadingView] hide];
        NSInteger ret = [[notification.userInfo numberValueForKey:@"rc"] integerValue];
        if (ret == 0) {
            if (self.isFromMember) {
                CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"赠送礼品券成功"];
                [messageView show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                BSSuccessViewController *successVC  = [BSSuccessViewController createViewControllerWithTopTip:nil contentTitle:@"赠送成功" detailTitle:@"优惠券1张"];
                successVC.operate = self.givePeople.operate;
                successVC.member = self.givePeople.member;
                //        successVC.delegate = self;
                successVC.style = ViewShowStyle_Give;
                [self.navigationController pushViewController:successVC animated:YES];
            }
            
        }
        else
        {
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]];
            [messageView show];
        }
    }
    else if([notification.name isEqualToString:kBSFetchCardTemplateProductResponse])
    {
        [self initData];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return Section_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == Section_project) {
        if ([self.cardTemplate.is_customize boolValue]) {
            return self.items.count + 1 + 1;// +1券内项目 +1添加
        }
        else
        {
            return self.items.count + 1;// +1券内项目
        }
    }
    else if (section == Section_date)
    {
        return 1;
    }
    else if (section == Section_mark)
    {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == Section_project) {
        if (row == 0) {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"券内项目";
            cell.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.titleLabel.textColor = [UIColor lightGrayColor];
            cell.valueTextFiled.hidden = true;
            return cell;
        }
        else if (row == self.items.count + 1)
        {
            PosOperateAddCell *addCell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateAddCell"];
            return addCell;
        }
        else
        {
            ItemArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemArrowCell"];
            cell.nameLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.valueLabel.font = [UIFont systemFontOfSize:13];
            CouponProject *project = [self.items objectAtIndex:row - 1];
            cell.nameLabel.textColor = [UIColor darkTextColor];
            cell.nameLabel.text = project.item.itemName;
            cell.valueLabel.text = [NSString stringWithFormat:@"x%d",project.count];
            cell.valueLabel.textColor = [UIColor lightGrayColor];
            cell.lineImgView.hidden = false;
            return cell;
        }
    }
    else if (section == Section_date)
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
        cell.valueLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.lineImgView.hidden = true;
        return cell;
    }
    else if(section == Section_mark)
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
    if (section == Section_project) {
        if (row == 0) {
            return 40;
        }
        return 50;
    }
    else if(section == Section_date)
    {
        return 50;
    }
    else if (section == Section_mark)
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
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == Section_project) {
        if (row == 0) {
            return;
        }
        if (row == self.items.count + 1) {
            NSLog(@"添加");
            GiveCouponSelectedProductViewController *selectedProductVC = [[GiveCouponSelectedProductViewController alloc] init];
            NSMutableArray *existIds = [NSMutableArray array];
            for (CouponProject *item in self.items) {
                [existIds addObject:item.item.itemID];
            }
            selectedProductVC.existIds = existIds;
            selectedProductVC.delegate = self;
            [self.navigationController pushViewController:selectedProductVC animated:YES];
            return;
        }
        if (row - 1 < self.items.count) {
            NSLog(@"------");
            self.selectedIndexPath = indexPath;
            CouponProject *couponProject = [self.items objectAtIndex: row - 1];
            self.editView.couponProject = couponProject;
            [self.editView show];
        }
    }
    else if (section == Section_date) {
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

#pragma mark - GiveProjectCountEditDelegate
- (void)didFinishChanged
{
    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.selectedIndexPath = nil;
}

- (void)didDeleteBtnPressed
{
    [self.items removeObjectAtIndex:self.selectedIndexPath.row - 1];
    [self.tableView deleteRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - CouponSelectedProjectDelegate
- (void)didSureSeletedItems:(NSArray *)items
{
    for (CDProjectItem *item in items) {
        CouponProject *project = [[CouponProject alloc] initWithItem:item];
        [self.items addObject:project];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:Section_project] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - BSDatePickerViewDelegate
- (void)didDatePicker:(BSDatePickerView *)pickerView sureSelectedDate:(NSDate *)date
{
    self.coupon.expiredDate = [date dateStringWithFormatter:@"yyyy-MM-dd"];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:Section_date] withRowAnimation:UITableViewRowAnimationFade];
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
        if (![self.coupon.expiredDate isEqualToString:self.cardTemplate.expire_date]) {
            params[@"invalid_date"] = self.coupon.expiredDate;
        }
        
        params[@"remark"] = self.coupon.remarks;
        
        if (self.items.count == 0) {
            [[[CBMessageView alloc] initWithTitle:@"赠送的礼品券里的项目不能为空\n请先选择赠送的项目"] show];
            return;
        }
        
        NSMutableArray *productList = [NSMutableArray array];
        for (CouponProject *project in self.items) {
            NSMutableArray *items = [NSMutableArray array];
            [items addObject:[NSNumber numberWithBool:kBSDataAdded]];
            [items addObject:[NSNumber numberWithBool:false]];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"product_id"] = project.item.itemID;
            dict[@"price_unit"] = project.item.totalPrice;
            dict[@"qty"] = @(project.count);
            [items addObject:dict];
            [productList addObject:items];
        }
        params[@"product_ids"] = productList;
    }
    else
    {
        
    }
    
    BSTemplateGiveRequest *request = [[BSTemplateGiveRequest alloc] initWithParams:params];
    request.type = TemplateType_coupon;
    [request execute];
    [[CBLoadingView shareLoadingView] show];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
