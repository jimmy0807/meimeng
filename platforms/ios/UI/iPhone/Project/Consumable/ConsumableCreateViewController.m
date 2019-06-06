//
//  ConsumableCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/11.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ConsumableCreateViewController.h"
#import "CBLoadingView.h"
#import "BSEditCell.h"
#import "BSConsumable.h"
#import "UomViewController.h"
#import "ProjectViewController.h"

typedef enum kConsumableSection
{
    kConsumableSectionInfo,
    kConsumableSectionCount
}kConsumableSection;

typedef enum kConsumableInfoRow
{
    kConsumableInfoItemName,
    kConsumableInfoIsStock,
    kConsumableInfoAmount,
    kConsumableInfoUom,
    kConsumableInfoRowCount
}kConsumableInfoRow;

#define kConsumableCellHeight       50.0

@interface ConsumableCreateViewController ()


@property (nonatomic, assign) NSInteger editIndex;
@property (nonatomic, assign) kConsumableEditType editType;
@property (nonatomic, strong) NSMutableArray *consumables;

@property (nonatomic, strong) BSConsumable *consumable;

@property (nonatomic, strong) UITableView *consumableTableView;

@end

@implementation ConsumableCreateViewController

- (id)initWithConsumables:(NSMutableArray *)consumables
{
    self = [super initWithNibName:NIBCT(@"ConsumableCreateViewController") bundle:nil];
    if (self != nil)
    {
        self.editIndex = -1;
        self.editType = kConsumableCreate;
        self.consumables = consumables;
        self.consumable = [[BSConsumable alloc] init];
        self.consumable.amount = 1;
        self.title = LS(@"ConsumableCreateTitle");
    }
    
    return self;
}

- (id)initWithConsumables:(NSMutableArray *)consumables editIndex:(NSInteger)editIndex
{
    self = [super initWithNibName:NIBCT(@"ConsumableCreateViewController") bundle:nil];
    if (self != nil)
    {
        self.editIndex = editIndex;
        self.editType = kConsumableEdit;
        self.consumables = consumables;
        BSConsumable *consumable = [self.consumables objectAtIndex:self.editIndex];
        self.consumable = [[BSConsumable alloc] init];
        self.consumable.consumableID = consumable.consumableID;
        self.consumable.productID = consumable.productID;
        self.consumable.productName = consumable.productName;
        self.consumable.baseProductID = consumable.baseProductID;
        self.consumable.baseProductName = consumable.baseProductName;
        self.consumable.isStock = consumable.isStock;
        self.consumable.uomID = consumable.uomID;
        self.consumable.uomName = consumable.uomName;
        self.consumable.amount = consumable.amount;
        
        self.title = self.consumable.productName;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"self.consumables-----%@",self.consumables);
    [self forbidSwipGesture];
    self.view.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:LS(@"Finish")];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self registerNofitificationForMainThread:kBSConsumableItemSelectFinish];
    [self registerNofitificationForMainThread:kBSProjectUomEditFinish];
    [self registerNofitificationForMainThread:kBSUomCreateResponse];
    [self registerNofitificationForMainThread:kBSConsumableCreateResponse];
    
    self.consumableTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.consumableTableView.backgroundColor = [UIColor clearColor];
    self.consumableTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.consumableTableView.delegate = self;
    self.consumableTableView.dataSource = self;
    self.consumableTableView.showsVerticalScrollIndicator = NO;
    self.consumableTableView.showsHorizontalScrollIndicator = NO;
    self.consumableTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.consumableTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.consumableTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.consumableTableView.tableFooterView = footerView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.consumable.productName.length != 0)
    {
        self.title = self.consumable.productName;
    }
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
    if (self.consumable == nil || self.consumable.productID.integerValue == 0 || self.consumable.uomID.integerValue == 0 || self.consumable.amount == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"ConsumableInfoIncomplete")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    if (self.editType == kConsumableEdit)
    {
        [self.consumables replaceObjectAtIndex:self.editIndex withObject:self.consumable];
    }
    else if (self.editType == kConsumableCreate)
    {
        [self.consumables insertObject:self.consumable atIndex:self.consumables.count];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSConsumablesEditFinish object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSConsumableItemSelectFinish])
    {
        CDProjectItem *item = (CDProjectItem *)notification.object;
        self.consumable.productID = [NSNumber numberWithInteger:item.itemID.integerValue];
        self.consumable.productName = item.itemName;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kConsumableInfoItemName inSection:kConsumableSectionInfo];
        BSEditCell *cell = (BSEditCell *)[self.consumableTableView cellForRowAtIndexPath:indexPath];
        cell.contentField.text = self.consumable.productName;
    }
    else if ([notification.name isEqualToString:kBSProjectUomEditFinish])
    {
        CDProjectUom *uom = (CDProjectUom *)notification.object;
        self.consumable.uomID = [NSNumber numberWithInteger:uom.uomID.integerValue];
        self.consumable.uomName = uom.uomName;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kConsumableInfoUom inSection:kConsumableSectionInfo];
        BSEditCell *cell = (BSEditCell *)[self.consumableTableView cellForRowAtIndexPath:indexPath];
        cell.contentField.text = self.consumable.uomName;
    }
    else if ([notification.name isEqualToString:kBSConsumableCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
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


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kConsumableSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kConsumableInfoRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kConsumableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kConsumableInfoIsStock)
    {
        static NSString *CellIdentifier = @"BSSwitchCellIdentifier";
        BSSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[BSSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        
        cell.indexPath = indexPath;
        cell.titleLabel.text = LS(@"ConsumableInfoIsStock");
        cell.isSwitchOn = self.consumable.isStock;
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"BSEditCellIdentifier";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.contentField.delegate = self;
        }
        
        if (indexPath.row == kConsumableInfoItemName)
        {
            cell.titleLabel.text = LS(@"ConsumableItemName");
            cell.contentField.enabled = NO;
            cell.contentField.placeholder = LS(@"PleaseSelect");
            cell.contentField.text = self.consumable.productName;
        }
        else if (indexPath.row == kConsumableInfoAmount)
        {
            cell.titleLabel.text = LS(@"ConsumableInfoAmount");
            cell.contentField.enabled = YES;
            cell.contentField.placeholder = LS(@"PleaseEnter");
            cell.contentField.text = [NSString stringWithFormat:@"%d", self.consumable.amount];
        }
        else if (indexPath.row == kConsumableInfoUom)
        {
            cell.titleLabel.text = LS(@"ConsumableInfoUom");
            cell.contentField.enabled = NO;
            cell.contentField.placeholder = LS(@"PleaseSelect");
            cell.contentField.text = self.consumable.uomName;
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == kConsumableInfoItemName)
    {
        NSMutableArray *itemIds = [NSMutableArray array];
        for (int i = 0; i < self.consumables.count; i++)
        {
            if (self.editIndex != i)
            {
                BSConsumable *consumable = [self.consumables objectAtIndex:i];
                [itemIds addObject:consumable.productID];
            }
        }
        
        if (self.consumable.productID.integerValue != 0)
        {
            [itemIds addObject:self.consumable.productID];
        }
        
        ProjectViewController *viewController = [[ProjectViewController alloc] initWithViewType:kProjectSelectConsumable existItemIds:itemIds];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == kConsumableInfoUom)
    {
        UomViewController *viewController = [[UomViewController alloc] initWithProjectUomID:self.consumable.uomID];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark -
#pragma mark BSSwitchCellDelegate Methods

- (void)didSwitchCellSwitchButtonClick:(BSSwitchCell *)switchCell
{
    NSIndexPath *indexPath = switchCell.indexPath;
    if (indexPath.row == kConsumableInfoIsStock)
    {
        self.consumable.isStock = switchCell.isSwitchOn;
    }
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
    if (textField.text.integerValue == 0)
    {
        textField.text = @"";
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    self.consumable.amount = textField.text.integerValue;
    if (self.consumable.amount <= 0)
    {
        self.consumable.amount = 1;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kConsumableInfoAmount inSection:kConsumableSectionInfo];
    BSEditCell *cell = (BSEditCell *)[self.consumableTableView cellForRowAtIndexPath:indexPath];
    cell.contentField.text = [NSString stringWithFormat:@"%d", self.consumable.amount];
}


@end
