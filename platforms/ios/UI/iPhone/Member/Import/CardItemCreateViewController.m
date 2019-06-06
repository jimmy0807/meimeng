//
//  CardItemCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/8/20.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "CardItemCreateViewController.h"
#import "BSCardItem.h"
#import "BSEditCell.h"
#import "BSSectionFooter.h"
#import "ProjectViewController.h"
#import "NSObject+MainThreadNotification.h"
#import "CBMessageView.h"
#import "ProductProjectMainController.h"

#define kCardItemCellHeight       50.0

typedef enum kCardItemEditType
{
    kCardItemEdit,
    kCardItemCreate
}kCardItemEditType;

typedef enum kCardItemSection
{
    kCardItemSectionInfo,
    kCardItemSectionLimited,
    kCardItemSectionCount
}kCardItemSection;

typedef enum kCardItemInfoRow
{
    kCardItemInfoName,
    kCardItemInfoPrice,
    kCardItemInfoUnitPrice,
    kCardItemInfoImportQTY,
    kCardItemInfoRemark,
    kCardItemInfoRowCount
}kCardItemInfoRow;

typedef enum kCardItemLimitedRow
{
    kCardItemLimitedIsLimited       = 0,
    kCardItemNotLimitedRowCount     = 1,
    
    kCardItemLimitedLimitedDate     = 1,
    kCardItemLimitedRowCount        = 2
    
}kCardItemLimitedRow;

@interface CardItemCreateViewController ()

@property (nonatomic, assign) NSInteger editIndex;
@property (nonatomic, strong) NSMutableArray *cardItems;
@property (nonatomic, assign) kCardItemEditType editType;
@property (nonatomic, strong) BSCardItem *bsCardItem;

@property (nonatomic, strong) UIView *dateSelectView;
@property (nonatomic, strong) UITableView *cardItemTableView;

@end

@implementation CardItemCreateViewController

- (id)initWithCardItems:(NSMutableArray *)cardItems editIndex:(NSInteger)editIndex
{
    self = [super initWithNibName:NIBCT(@"CardItemViewController") bundle:nil];
    if (self)
    {
        self.editIndex = editIndex;
        self.cardItems = cardItems;
        self.bsCardItem = [[BSCardItem alloc] init];
        if (self.editIndex >= 0 && self.editIndex < self.cardItems.count)
        {
            self.editType = kCardItemEdit;
            
            BSCardItem *cardItem = [self.cardItems objectAtIndex:self.editIndex];
            self.bsCardItem.productID = cardItem.productID;
            self.bsCardItem.productPrice = cardItem.productPrice;
            self.bsCardItem.productName = cardItem.productName;
            self.bsCardItem.unitPrice = cardItem.unitPrice;
            self.bsCardItem.importQty = cardItem.importQty;
            self.bsCardItem.isLimited = cardItem.isLimited;
            self.bsCardItem.limitedDate = cardItem.limitedDate;
            self.bsCardItem.remark = cardItem.remark;
            
            self.title = self.bsCardItem.productName;
        }
        else
        {
            self.editType = kCardItemCreate;
            self.bsCardItem.isLimited = NO;
            self.bsCardItem.limitedDate = [NSDate date];
            self.bsCardItem.remark = @"";
            
            self.title = LS(@"CreateCardItem");
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.view.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:LS(@"Finish")];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self registerNofitificationForMainThread:kBSCardItemSelectFinish];
    
    self.cardItemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.cardItemTableView.backgroundColor = [UIColor clearColor];
    self.cardItemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cardItemTableView.delegate = self;
    self.cardItemTableView.dataSource = self;
    self.cardItemTableView.showsVerticalScrollIndicator = NO;
    self.cardItemTableView.showsHorizontalScrollIndicator = NO;
    self.cardItemTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.cardItemTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.cardItemTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.cardItemTableView.tableFooterView = footerView;
    
    self.dateSelectView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    self.dateSelectView.backgroundColor = [UIColor clearColor];
    self.dateSelectView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.dateSelectView];
    
    UIButton *contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contentButton.frame = self.dateSelectView.bounds;
    contentButton.backgroundColor = [UIColor blackColor];
    contentButton.alpha = 0.3;
    [contentButton addTarget:self action:@selector(didContentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.dateSelectView addSubview:contentButton];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
    datePicker.frame = CGRectMake(0.0, self.dateSelectView.frame.size.height - datePicker.frame.size.height, self.dateSelectView.frame.size.width, datePicker.frame.size.height);
    datePicker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minimumDate = [NSDate date];
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:60*12*31*24*60*60];
    [datePicker addTarget:self action:@selector(didDateValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.dateSelectView addSubview:datePicker];
    self.dateSelectView.hidden = YES;
    
//    [self registerNofitificationForMainThread:@"kSelectedImportProjectDone"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Required Methods

- (void)didRightBarButtonItemClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.bsCardItem.productID.integerValue == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"CardItemInfoIncomplete")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        return ;
    }
    
    if (self.editType == kCardItemEdit)
    {
        [self.cardItems replaceObjectAtIndex:self.editIndex withObject:self.bsCardItem];
    }
    else if (self.editType == kCardItemCreate)
    {
        [self.cardItems insertObject:self.bsCardItem atIndex:self.cardItems.count];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSCardItemCreateResult object:self.cardItems userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
    [[[CBMessageView alloc] initWithTitle:@"保存成功"] show];
}

- (void)didContentButtonClick:(id)sender
{
    self.dateSelectView.hidden = YES;
}

- (void)didDateValueChange:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    self.bsCardItem.limitedDate = datePicker.date;
    BSEditCell *cell = (BSEditCell *)[self.cardItemTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kCardItemLimitedLimitedDate inSection:kCardItemSectionLimited]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    cell.contentField.text = [dateFormatter stringFromDate:self.bsCardItem.limitedDate];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSCardItemSelectFinish])
    {
        CDProjectItem *item = (CDProjectItem *)notification.object;
        self.bsCardItem.productID = item.itemID;
        self.bsCardItem.productName = item.itemName;
        self.bsCardItem.productPrice = item.totalPrice.floatValue;
        self.bsCardItem.unitPrice = item.totalPrice.floatValue;
        [self.cardItemTableView reloadData];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kCardItemSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kCardItemSectionInfo)
    {
        return kCardItemInfoRowCount;
    }
    else if (section == kCardItemSectionLimited)
    {
        if (self.bsCardItem.isLimited)
        {
            return kCardItemLimitedRowCount;
        }
        else
        {
            return kCardItemNotLimitedRowCount;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCardItemCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kCardItemSectionInfo)
    {
        static NSString *CellIdentifier = @"BSEditCellIdentifier";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.contentField.delegate = self;
        }
        
        cell.contentField.tag = 100 * indexPath.section + indexPath.row;
        cell.arrowImageView.hidden = NO;
        if (indexPath.row == kCardItemInfoName)
        {
            cell.titleLabel.text = @"项目";
            cell.contentField.enabled = NO;
            cell.contentField.placeholder = LS(@"PleaseSelect");
            cell.contentField.text = self.bsCardItem.productName;
            cell.arrowImageView.hidden = YES;
        }
        else if (indexPath.row == kCardItemInfoPrice)
        {
            cell.titleLabel.text = LS(@"CardItemInfoPrice");
            cell.contentField.enabled = NO;
            cell.contentField.placeholder = @"";
            cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.bsCardItem.productPrice];
            cell.arrowImageView.hidden = YES;
        }
        else if (indexPath.row == kCardItemInfoImportQTY)
        {
            cell.titleLabel.text = LS(@"CardItemInfoImportQTY");
            cell.contentField.enabled = YES;
            cell.contentField.placeholder = LS(@"PleaseEnter");
            cell.contentField.text = [NSString stringWithFormat:@"%d", self.bsCardItem.importQty];
        }
        else if (indexPath.row == kCardItemInfoUnitPrice)
        {
            cell.titleLabel.text = LS(@"CardItemInfoUnitPrice");
            cell.contentField.enabled = YES;
            cell.contentField.placeholder = LS(@"PleaseEnter");
            cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.bsCardItem.unitPrice];
        }
        else if (indexPath.row == kCardItemInfoRemark)
        {
            cell.titleLabel.text = LS(@"CardItemInfoRemark");
            cell.contentField.enabled = YES;
            cell.contentField.placeholder = LS(@"PleaseEnter");
            cell.contentField.text = self.bsCardItem.remark;
        }
        
        return cell;
    }
    else if (indexPath.section == kCardItemSectionLimited)
    {
        if (indexPath.row == kCardItemLimitedIsLimited)
        {
            static NSString *CellIdentifier = @"BSSwitchCellIdentifier";
            BSSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[BSSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
            }
            
            cell.indexPath = indexPath;
            cell.titleLabel.text = LS(@"CardItemLimitedIsLimited");
            cell.isSwitchOn = self.bsCardItem.isLimited;
            
            return cell;
        }
        else if (indexPath.row == kCardItemLimitedLimitedDate)
        {
            static NSString *CellIdentifier = @"BSEditCellIdentifier";
            BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.contentField.delegate = self;
            }
            
            cell.titleLabel.text = LS(@"CardItemLimitedLimitedDate");
            cell.contentField.enabled = NO;
            cell.contentField.placeholder = LS(@"PleaseSelect");
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            cell.contentField.text = [dateFormatter stringFromDate:self.bsCardItem.limitedDate];
            
            return cell;
        }
        
        return nil;
    }
    
    return nil;
}


#pragma mark -
#pragma mark BSSwitchCellDelegate Methods

- (void)didSwitchCellSwitchButtonClick:(BSSwitchCell *)switchCell
{
    NSIndexPath *indexPath = switchCell.indexPath;
    if (indexPath.section == kCardItemSectionLimited && indexPath.row == kCardItemLimitedIsLimited)
    {
        self.bsCardItem.isLimited = switchCell.isSwitchOn;
    }
    
    [self.cardItemTableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == kCardItemSectionInfo)
    {
        if (indexPath.row == kCardItemInfoName)
        {
//            NSMutableArray *itemIds = [NSMutableArray array];
//            for (int i = 0; i < self.cardItems.count; i++)
//            {
//                BSCardItem *cardItem = [self.cardItems objectAtIndex:i];
//                [itemIds addObject:cardItem.productID];
//            }
////            ProjectViewController *viewController = [[ProjectViewController alloc] initWithViewType:kProjectSelectCardItem existItemIds:itemIds];
////            [self.navigationController pushViewController:viewController animated:YES];
//            
//            ProductProjectMainController *productProjectMainVC = [[ProductProjectMainController alloc] init];
//            productProjectMainVC.controllerType = ProductControllerType_Import;
//            [self.navigationController pushViewController:productProjectMainVC animated:YES];
            
            
        }
    }
    else if (indexPath.section == kCardItemSectionLimited)
    {
        if (indexPath.row == kCardItemLimitedLimitedDate)
        {
            self.dateSelectView.hidden = NO;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == kCardItemSectionInfo)
    {
        return kBSSectionFooterHeight;
    }
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == kCardItemSectionInfo)
    {
        static NSString *CellIdentifier = @"BSSectionFooterIdentifier";
        BSSectionFooter *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[BSSectionFooter alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    
    return nil;
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    if (section == kCardItemSectionInfo)
    {
        if (row == kCardItemInfoImportQTY)
        {
            if (textField.text.integerValue == 0)
            {
                textField.text = @"";
            }
        }
        else if (row == kCardItemInfoUnitPrice)
        {
            if (textField.text.floatValue == 0)
            {
                textField.text = @"";
            }
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    BSEditCell *cell = (BSEditCell *)[self.cardItemTableView cellForRowAtIndexPath:indexPath];
    
    if (section == kCardItemSectionInfo)
    {
        if (row == kCardItemInfoImportQTY)
        {
            self.bsCardItem.importQty = textField.text.integerValue;
            cell.contentField.text = [NSString stringWithFormat:@"%d", self.bsCardItem.importQty];
        }
        else if (row == kCardItemInfoUnitPrice)
        {
            self.bsCardItem.unitPrice = textField.text.floatValue;
            cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.bsCardItem.unitPrice];
        }
        else if (row == kCardItemInfoRemark)
        {
            self.bsCardItem.remark = textField.text;
            cell.contentField.text = self.bsCardItem.remark;
        }
    }
}

@end
