//
//  GiveTicketViewController.m
//  Boss
//
//  Created by lining on 15/10/29.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "GiveTicketViewController.h"
#import "GiveTicketProjectViewController.h"
#import "GiveCell.h"
#import "UIView+Frame.h"
#import "CouponProject.h"
#import "PadProjectDetailViewController.h"
#import "PadMaskView.h"
#import "PadProjectConstant.h"
#import "GiveRemarkViewController.h"
#import "Remark.h"
#import "CouponObject.h"
#import "BSGiveRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "BSFetchCardTemplateProductsRequest.h"
#import "BSTemplateGiveRequest.h"

typedef enum KSection
{
    KSection_project,   //项目
    KSection_availd,    //有效期
    KSection_mark,      //备注信息
    KSection_num,
    KSection_clause,    //使用条款
}TicketSection;

@interface GiveTicketViewController ()<TicketProjectSelectedDelegate,PadProjectDetailViewControllerDelegate,GiveRemarkDelegate,GiveCellDelegate>
{
    BOOL dateSelected;
}

@property (strong, nonatomic) PadMaskView *bgMaskView;
@property (strong, nonatomic) CouponProject *currentProject;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *remarks;
@property (strong, nonatomic) NSMutableArray *caluses;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSMutableArray *paramItems;
@property (strong, nonatomic) CouponObject *coupon;

@end

@implementation GiveTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.remarks = [NSMutableArray array];
    self.caluses = [NSMutableArray array];
    
//    self.cardTemplate.is_customize = @(1);

    self.coupon = [[CouponObject alloc] initWithTemplate:self.cardTemplate];
//    if (self.coupon.short_description.length > 0) {
//        Remark *remark = [[Remark alloc] init];
//        remark.text = self.coupon.short_description;
//        [self.remarks addObject:remark];
//    }

    
    
    self.bgMaskView = [[PadMaskView alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgMaskView];
    
    
   BSFetchCardTemplateProductsRequest *request =  [[BSFetchCardTemplateProductsRequest alloc] initWithTemplate:self.cardTemplate];
    [request execute];
    [[CBLoadingView shareLoadingView] showInView:self.view];
    
    [self initData];
    [self registerNofitificationForMainThread:kBSFetchCardTemplateProductResponse];
}


- (void) initData
{
    self.items = [NSMutableArray array];
    NSArray *templateItems = [[BSCoreDataManager currentManager] fetchCardTemplateProducts:self.cardTemplate];
    for (CDCardTemplateProduct *templateItem in templateItems) {
        CDProjectItem *item = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDProjectItem" withValue:templateItem.product_id forKey:@"itemID"];
        CouponProject *project = [[CouponProject alloc] initWithItem:item];
        [self.items addObject:project];
    }
}

#pragma mark- received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [[CBLoadingView shareLoadingView] hide];
    [self initData];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return KSection_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == KSection_project) {
        if ([self.cardTemplate.is_customize boolValue]) {
            return self.items.count + 1;
        }
        else
        {
            return self.items.count;
        }
       
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
        if ([self.cardTemplate.is_customize boolValue]) {
            return self.caluses.count;
        }
        else
        {
            return self.caluses.count + 1;
        }
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == KSection_availd)
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
            cell.delegate = self;
        }
        else
        {
            NSLog(@"重用");
        }
        
        cell.indexPath = indexPath;
        if (section == KSection_project) {
            if (row == self.items.count) {
                [cell lastItem];
            }
            else
            {
                CouponProject *project = [self.items objectAtIndex:row];
                [cell itemWithName:project.item.itemName count:[NSString stringWithFormat:@"x%d",project.count]];
                [cell hideDeleteView:![_cardTemplate.is_customize boolValue]];
            }
            NSInteger maxRow;
            if ([self.cardTemplate.is_customize boolValue]) {
                maxRow = self.items.count;
            }
            else
            {
                maxRow = self.items.count - 1;
            }
            [self cellBg:cell withRow:row minRow:0 maxRow:maxRow];
        }
        
        else if (section == KSection_mark)
        {
            if (row == self.remarks.count) {
                [cell lastItem];
            }
            else
            {
                Remark *remark = [self.remarks objectAtIndex:row];
                [cell itemWithName:remark.text];
                
                [cell hideDeleteView:![_cardTemplate.is_customize boolValue]];
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
                [cell hideDeleteView:![_cardTemplate.is_customize boolValue]];
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
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    if (section == KSection_project) {
        label.text = @"券内项目";
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
//    if (![self.cardTemplate.is_customize boolValue]) {
//        return;
//    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == KSection_project) {
        if (row == self.items.count) {
            GiveTicketProjectViewController *ticketProjectVC = [[GiveTicketProjectViewController alloc] init];
            ticketProjectVC.delegate = self;
            NSMutableArray *existIds = [NSMutableArray array];
            for (CouponProject *item in self.items) {
                [existIds addObject:item.item.itemID];
            }
            ticketProjectVC.existIds = existIds;
            
            [self.navigationController pushViewController:ticketProjectVC animated:YES];
        }
        else
        {
            CouponProject *project = [self.items objectAtIndex:row];
            self.currentProject = project;
            PadProjectDetailViewController *viewController = [[PadProjectDetailViewController alloc] initWithProjectItem:project.item quantity:project.count];
            viewController.isFromGift = YES;
            viewController.delegate = self;
            viewController.maskView = self.bgMaskView;
            self.bgMaskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
            self.bgMaskView.navi.navigationBarHidden = YES;
            self.bgMaskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
            [self.bgMaskView addSubview:self.bgMaskView.navi.view];
            [self.bgMaskView show];
        }
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


#pragma mark - GiveCellDelegate
- (void)didDeleteBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == KSection_project) {
        [self.items removeObjectAtIndex:row];
    }
    else if (section == KSection_mark)
    {
        [self.remarks removeObjectAtIndex:row];
    }
    else if (section == KSection_clause)
    {
        [self.caluses removeObjectAtIndex:row];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - TicketProjectSelectedDelegate
- (void)didSureSeletedItems:(NSArray *)items
{
    
    for (CDProjectItem *item in items) {
        CouponProject *project = [[CouponProject alloc] initWithItem:item];
        [self.items addObject:project];
    }

    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:KSection_project] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - PadProjectDetailViewControllerDelegate
- (void)didPadProjectItemDelete:(CDProjectItem *)item
{
    [self.items removeObject:self.currentProject];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:KSection_project] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)didPadProjectItemConfirm:(CDProjectItem *)item quantity:(NSInteger)quantity
{
    self.currentProject.count = quantity;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:KSection_project] withRowAnimation:UITableViewRowAnimationAutomatic];
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
//        [self.remarks addObject:remark];
        section = KSection_mark;
       
    }
    else if (type == kRemarkType_clause)
    {
        
//        [self.caluses addObject:remark];
        section = KSection_clause;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 
- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendBtnPressed:(UIButton *)sender {
    
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
            [marks appendFormat:@"%@\n",mark.text];
        }
        params[@"remark"] = marks;
        
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
    request.type = TemplateType_coupon;
    [request execute];
    [[CBLoadingView shareLoadingView] show];
    
//    CGFloat courseMoney = 0.0;
//    self.paramItems = [NSMutableArray array];
//    for (CouponProject *item in self.items) {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[@"id"] = item.item.itemID;
//        dict[@"productId"] = item.item.itemID;
//        dict[@"productName"] = item.item.itemName;
//        dict[@"buyQty"] = [NSNumber numberWithInteger:item.count];
//        dict[@"qty"] = [NSNumber numberWithInteger:item.count];
//        dict[@"bornUuid"] = [PersonalProfile currentProfile].companyUUID;
//        dict[@"consumeQty"] = @0;
//        dict[@"price"] = item.item.totalPrice;
//        dict[@"code"] = item.item.defaultCode;
//        [self.paramItems addObject:dict];
//        
//        courseMoney += item.count * [item.item.totalPrice floatValue];
//    }
//    self.coupon.courseMoney = [NSNumber numberWithFloat:courseMoney];
//    
//    NSString *marks = [NSString string];
//    for (NSString *mark in self.remarks) {
//        marks = [marks stringByAppendingFormat:@"\n%@",mark];
//    }
//    
//    for (NSString *caulse  in self.caluses) {
//        marks = [marks stringByAppendingFormat:@"\n%@",caulse];
//    }
//    
//    self.coupon.remarks = marks;
////    self.coupon.remarks = @"中文";
//    
//    [[CBLoadingView shareLoadingView] show];
//    BSGiveRequest *request = [[BSGiveRequest alloc] initWithOperate:self.operate coupon:self.coupon];
//    request.items = self.paramItems;
//    [request execute];
}

- (void)dealloc
{
    [self.bgMaskView removeFromSuperview];
}
@end
