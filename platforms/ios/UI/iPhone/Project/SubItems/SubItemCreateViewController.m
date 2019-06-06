//
//  SubItemCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/11.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "SubItemCreateViewController.h"
#import "CBLoadingView.h"
#import "BSEditCell.h"
#import "BSItemAddCell.h"
#import "BSSectionFooter.h"
#import "BSSubItem.h"
#import "UomViewController.h"
#import "ProjectViewController.h"

typedef enum kSubItemSection
{
    kSubItemSectionInfo         = 0,
    kSubItemSectionUnlimited    = 1,
    kSubItemSectionNoSameCount  = 2,
    
    kSubItemSectionReplace      = 2,
    kSubItemSectionCount        = 3
}kSubItemSection;

typedef enum kSubItemInfoRow
{
    kSubItemInfoName,
    kSubItemInfoAmount,
    kSubItemInfoPrice,
    kSubItemInfoSetPrice,
    kSubItemInfoRowCount
}kSubItemInfoRow;

typedef enum kSubItemUnlimitedRow
{
    kSubItemUnlimitedSet        = 0,
    kSubItemUnlimitedFalseCount = 1,
    
    kSubItemUnlimitedDays       = 1,
    kSubItemUnlimitedTrueCount  = 2
}kSubItemUnlimitedRow;

typedef enum kSubItemReplaceRow
{
    kSubItemReplaceAdd
}kSubItemReplaceRow;


#define kSubItemCellHeight       50.0

@interface SubItemCreateViewController ()


@property (nonatomic, assign) kPadBornCategoryType projectType;
@property (nonatomic, assign) NSInteger editIndex;
@property (nonatomic, assign) kSubItemEditType editType;
@property (nonatomic, strong) NSMutableArray *subItems;

@property (nonatomic, strong) BSSubItem *subItem;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UITableView *subItemTableView;

@end

@implementation SubItemCreateViewController

- (id)initWithSubItems:(NSMutableArray *)subItems projectType:(kPadBornCategoryType)projectType
{
    self = [super initWithNibName:NIBCT(@"SubItemCreateViewController") bundle:nil];
    if (self != nil)
    {
        self.subItems = subItems;
        self.editIndex = -1;
        self.editType = kSubItemCreate;
        self.projectType = projectType;
        self.currentIndex = -1;
        
        self.subItem = [[BSSubItem alloc] init];
        self.subItem.sameItems = [NSMutableArray array];
        self.title = LS(@"SubItemCreateTitle");
    }
    
    return self;
}

- (id)initWithSubItems:(NSMutableArray *)subItems editIndex:(NSInteger)editIndex projectType:(kPadBornCategoryType)projectType
{
    self = [super initWithNibName:NIBCT(@"SubItemCreateViewController") bundle:nil];
    if (self != nil)
    {
        self.subItems = subItems;
        self.editIndex = editIndex;
        self.editType = kSubItemEdit;
        self.projectType = projectType;
        
        BSSubItem *subItem = [self.subItems objectAtIndex:self.editIndex];
        self.subItem = [[BSSubItem alloc] init];
        self.subItem.relatedID = subItem.relatedID;
        self.subItem.itemID = subItem.itemID;
        self.subItem.itemName = subItem.itemName;
        self.subItem.amount = subItem.amount;
        self.subItem.itemPrice = subItem.itemPrice;
        self.subItem.itemSetPrice = subItem.itemSetPrice;
        self.subItem.projectType = subItem.projectType;
        self.subItem.isUnlimited = subItem.isUnlimited;
        self.subItem.unlimitedDays = subItem.unlimitedDays;
        self.subItem.sameItems = [NSMutableArray arrayWithArray:subItem.sameItems];
        self.title = self.subItem.itemName;
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
    
    [self registerNofitificationForMainThread:kBSSubItemSelectFinish];
    [self registerNofitificationForMainThread:kBSSameItemSelectFinish];
    
    self.subItemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.subItemTableView.backgroundColor = [UIColor clearColor];
    self.subItemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.subItemTableView.delegate = self;
    self.subItemTableView.dataSource = self;
    self.subItemTableView.showsVerticalScrollIndicator = NO;
    self.subItemTableView.showsHorizontalScrollIndicator = NO;
    self.subItemTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.subItemTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.subItemTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.subItemTableView.tableFooterView = footerView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.subItem.itemName.length != 0)
    {
        self.title = self.subItem.itemName;
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
    if (self.subItem == nil || self.subItem.itemID.integerValue == 0 || self.subItem.amount == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"SubItemInfoIncomplete")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    if (self.editType == kSubItemEdit)
    {
        [self.subItems replaceObjectAtIndex:self.editIndex withObject:self.subItem];
    }
    else if (self.editType == kSubItemCreate)
    {
        [self.subItems insertObject:self.subItem atIndex:self.subItems.count];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectSubItemEditFinish object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSSubItemSelectFinish])
    {
        CDProjectItem *item = (CDProjectItem *)notification.object;
        self.subItem.itemID = [NSNumber numberWithInteger:item.itemID.integerValue];
        self.subItem.itemName = item.itemName;
        self.subItem.amount = 1;
        self.subItem.itemPrice = item.totalPrice.floatValue;
        self.subItem.itemSetPrice = item.totalPrice.floatValue;
        self.subItem.projectType = item.projectTemplate.bornCategory.integerValue;
        [self.subItem.sameItems removeAllObjects];
        
        [self.subItemTableView reloadData];
    }
    else if ([notification.name isEqualToString:kBSSameItemSelectFinish])
    {
        CDProjectItem *item = (CDProjectItem *)notification.object;
        if (self.currentIndex >= 0 && self.currentIndex < self.subItem.sameItems.count)
        {
            [self.subItem.sameItems replaceObjectAtIndex:self.currentIndex withObject:item];
        }
        else
        {
            [self.subItem.sameItems addObject:item];
        }
        
        [self.subItemTableView reloadSections:[NSIndexSet indexSetWithIndex:kSubItemSectionReplace] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.subItem.projectType == kPadBornCategoryProject)
    {
        return kSubItemSectionCount;
    }
    else
    {
        return kSubItemSectionNoSameCount;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSubItemSectionInfo)
    {
        return kSubItemInfoRowCount;
    }
    else if (section == kSubItemSectionUnlimited)
    {
        if (self.subItem.isUnlimited)
        {
            return kSubItemUnlimitedTrueCount;
        }
        else
        {
            return kSubItemUnlimitedFalseCount;
        }
    }
    else if (section == kSubItemSectionReplace)
    {
        return self.subItem.sameItems.count + 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSubItemCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kSubItemSectionInfo)
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
        if (indexPath.row == kSubItemInfoName)
        {
            cell.titleLabel.text = LS(@"SubItemInfoName");
            cell.contentField.enabled = NO;
            cell.contentField.placeholder = LS(@"PleaseSelect");
            cell.contentField.text = self.subItem.itemName;
        }
        else if (indexPath.row == kSubItemInfoAmount)
        {
            cell.titleLabel.text = LS(@"SubItemInfoAmount");
            cell.contentField.enabled = YES;
            cell.contentField.placeholder = LS(@"PleaseEnter");
            cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
            if (self.subItem.amount <= 0)
            {
                if (self.subItem.itemID.integerValue != 0)
                {
                    self.subItem.amount = 1;
                }
                else
                {
                    cell.contentField.text = @"";
                }
            }
            else
            {
                cell.contentField.text = [NSString stringWithFormat:@"%d", self.subItem.amount];
            }
        }
        else if (indexPath.row == kSubItemInfoPrice)
        {
            cell.titleLabel.text = LS(@"SubItemInfoPrice");
            cell.contentField.enabled = NO;
            cell.arrowImageView.hidden = YES;
            cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.subItem.itemPrice];
        }
        else if (indexPath.row == kSubItemInfoSetPrice)
        {
            cell.titleLabel.text = LS(@"SubItemInfoSetPrice");
            cell.contentField.enabled = YES;
            cell.contentField.placeholder = LS(@"PleaseEnter");
            cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
            cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.subItem.itemSetPrice];
        }
        
        return cell;
    }
    else if (indexPath.section == kSubItemSectionUnlimited)
    {
        if (indexPath.row == kSubItemUnlimitedSet)
        {
            static NSString *CellIdentifier = @"BSSwitchCellIdentifier";
            BSSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[BSSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
            }
            
            cell.indexPath = indexPath;
            cell.titleLabel.text = LS(@"UnlimitedInValidity");
            cell.isSwitchOn = self.subItem.isUnlimited;
            
            return cell;
        }
        else if (indexPath.row == kSubItemUnlimitedDays)
        {
            static NSString *CellIdentifier = @"BSEditCellIdentifier";
            BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.contentField.delegate = self;
            }
            cell.contentField.tag = 100 * indexPath.section + indexPath.row;
            
            cell.titleLabel.text = LS(@"UnlimitedDays");
            cell.contentField.enabled = YES;
            cell.contentField.placeholder = LS(@"PleaseEnter");
            cell.contentField.text = [NSString stringWithFormat:@"%d", self.subItem.unlimitedDays];
            
            return cell;
        }
        
        return nil;
    }
    else if (indexPath.section == kSubItemSectionReplace)
    {
        static NSString *CellIdentifier = @"BSItemAddCellIdentifier";
        BSItemAddCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[BSItemAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 0)
        {
            [cell setTitle:LS(@"SubItemReplaceItem") addImageViewHidden:NO];
        }
        else
        {
            CDProjectItem *sameItem = [self.subItem.sameItems objectAtIndex:indexPath.row - 1];
            [cell setTitle:sameItem.itemName addImageViewHidden:YES];
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == kSubItemSectionInfo)
    {
        if (indexPath.row == kSubItemInfoName)
        {
            NSMutableArray *itemIds = [NSMutableArray array];
            for (int i = 0; i < self.subItems.count; i++)
            {
                if (self.editIndex != i)
                {
                    BSSubItem *subItem = [self.subItems objectAtIndex:i];
                    [itemIds addObject:subItem.itemID];
                }
            }
            
            if (self.subItem.itemID.integerValue != 0)
            {
                [itemIds addObject:self.subItem.itemID];
            }
            
            ProjectViewController *viewController = [[ProjectViewController alloc] initWithViewType:kProjectSelectSubItem projectType:self.projectType existItemIds:itemIds];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else if (indexPath.section == kSubItemSectionReplace)
    {
        NSMutableArray *itemIds = [NSMutableArray array];
        for (int i = 0; i < self.subItems.count; i++)
        {
            if (self.editIndex != i)
            {
                BSSubItem *subItem = [self.subItems objectAtIndex:i];
                [itemIds addObject:subItem.itemID];
            }
        }
        
        if (self.subItem.itemID.integerValue != 0)
        {
            [itemIds addObject:self.subItem.itemID];
        }
        
        for (int i = 0; i < self.subItem.sameItems.count; i++)
        {
            CDProjectItem *sameItem = [self.subItem.sameItems objectAtIndex:i];
            [itemIds addObject:sameItem.itemID];
        }
        
        if (indexPath.row == kSubItemReplaceAdd)
        {
            self.currentIndex = -1;
        }
        else
        {
            self.currentIndex = indexPath.row - 1;
        }
        
        ProjectViewController *viewController = [[ProjectViewController alloc] initWithViewType:kProjectSelectSameItem existItemIds:itemIds];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.subItem.projectType == kPadBornCategoryProject)
    {
        if (section == kSubItemSectionInfo || section == kSubItemSectionUnlimited)
        {
            return kBSSectionFooterHeight;
        }
    }
    else
    {
        if (section == kSubItemSectionInfo)
        {
            return kBSSectionFooterHeight;
        }
    }
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"BSSectionFooterIdentifier";
    BSSectionFooter *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSSectionFooter alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kSubItemSectionReplace && indexPath.row != 0)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.subItem.sameItems removeObjectAtIndex:indexPath.row - 1];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark -
#pragma mark BSSwitchCellDelegate Methods

- (void)didSwitchCellSwitchButtonClick:(BSSwitchCell *)switchCell
{
    NSIndexPath *indexPath = switchCell.indexPath;
    if (indexPath.section == kSubItemSectionUnlimited && indexPath.row == kSubItemUnlimitedSet)
    {
        self.subItem.isUnlimited = switchCell.isSwitchOn;
    }
    
    if (!self.subItem.isUnlimited)
    {
        self.subItem.unlimitedDays = 0;
    }
    
    [self.subItemTableView reloadData];
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
    if (section == kSubItemSectionInfo)
    {
        if (row == kSubItemInfoAmount)
        {
            if (textField.text.integerValue == 0)
            {
                textField.text = @"";
            }
        }
        else if (row == kSubItemInfoSetPrice)
        {
            if (textField.text.floatValue == 0)
            {
                textField.text = @"";
            }
        }
    }
    else if (section == kSubItemSectionUnlimited)
    {
        if (row == kSubItemUnlimitedDays)
        {
            if (textField.text.integerValue == 0)
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
    if (section == kSubItemSectionInfo)
    {
        if (row == kSubItemInfoAmount)
        {
            self.subItem.amount = textField.text.integerValue;
            if (self.subItem.amount <= 0)
            {
                self.subItem.amount = 1;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kSubItemInfoAmount inSection:kSubItemSectionInfo];
            BSEditCell *cell = (BSEditCell *)[self.subItemTableView cellForRowAtIndexPath:indexPath];
            if (self.subItem.amount <= 0)
            {
                if (self.subItem.itemID.integerValue != 0)
                {
                    self.subItem.amount = 1;
                }
                else
                {
                    cell.contentField.text = @"";
                }
            }
            else
            {
                cell.contentField.text = [NSString stringWithFormat:@"%d", self.subItem.amount];
            }
        }
        else if (row == kSubItemInfoSetPrice)
        {
            self.subItem.itemSetPrice = textField.text.floatValue;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kSubItemInfoSetPrice inSection:kSubItemSectionInfo];
            BSEditCell *cell = (BSEditCell *)[self.subItemTableView cellForRowAtIndexPath:indexPath];
            cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.subItem.itemSetPrice];
        }
    }
    else if (section == kSubItemSectionUnlimited)
    {
        if (row == kSubItemUnlimitedDays)
        {
            self.subItem.unlimitedDays = textField.text.integerValue;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kSubItemUnlimitedDays inSection:kSubItemSectionUnlimited];
            BSEditCell *cell = (BSEditCell *)[self.subItemTableView cellForRowAtIndexPath:indexPath];
            cell.contentField.text = [NSString stringWithFormat:@"%d", self.subItem.unlimitedDays];
        }
    }
}


@end
