//
//  PosCategoryCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "PosCategoryCreateViewController.h"
#import "NSObject+MainThreadNotification.h"
#import "CBLoadingView.h"
#import "PosCategoryViewController.h"
#import "BSPosCategoryCreateRequest.h"

typedef enum kPosCategoryRow
{
    kPosCategoryName        = 0,
    kPosCategoryParent      = 1,
    kPosCategorySequence    = 2,
    kPosCategoryRowCount    = 3,
    
    kPosCategoryParentSequence  = 1,
    kPosCategoryParentCount     = 2,
    
    kPosCategorySubCount        = 3,
    
    kPosCategoryEditCount       = 3
}kPosCategoryRow;

#define kPosCategoryCellHeight      50.0


@interface PosCategoryCreateViewController ()

@property (nonatomic, assign) kPosCategoryEditType editType;
@property (nonatomic, strong) CDProjectCategory *posCategory;

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) CDProjectCategory *parentCategory;
@property (nonatomic, strong) NSNumber *sequence;

@property (nonatomic, strong) UITableView *categoryTableView;

@end

@implementation PosCategoryCreateViewController

- (id)initWithType:(kPosCategoryEditType)editType posCategory:(CDProjectCategory *)category
{
    self = [super initWithNibName:NIBCT(@"PosCategoryCreateViewController") bundle:nil];
    if (self != nil)
    {
        self.editType = editType;
        self.sequence = [NSNumber numberWithInteger:0];
        if (self.editType == kPosCategoryEdit)
        {
            self.posCategory = category;
            self.title = self.posCategory.categoryName;
            self.categoryName = self.posCategory.categoryName;
            self.parentCategory = self.posCategory.parent;
        }
        else
        {
            self.title = LS(@"PosCategoryCreateTitle");
            if (self.editType == kPosCategoryCreateSub)
            {
                self.parentCategory = category;
            }
            else if (self.editType == kPosCategoryCreateParent)
            {
                self.title = LS(@"PosCategoryCreateParentTitle");
            }
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
    
    [self registerNofitificationForMainThread:kBSPosCategoryCreateResponse];
    [self registerNofitificationForMainThread:kBSParentPosCategoryEditFinish];
    
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.categoryTableView.backgroundColor = [UIColor clearColor];
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    self.categoryTableView.showsVerticalScrollIndicator = NO;
    self.categoryTableView.showsHorizontalScrollIndicator = NO;
    self.categoryTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.categoryTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.categoryTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.categoryTableView.tableFooterView = footerView;
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
    if (self.categoryName.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"PosCategoryNameCanNotBeNULL")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    else
    {
        CDProjectCategory *category = [[BSCoreDataManager currentManager] findEntity:@"CDProjectCategory" withValue:self.categoryName forKey:[NSString stringWithFormat:@"parentID == %@ and categoryName", [NSNumber numberWithInteger:self.parentCategory.categoryID.integerValue]]];
        if (category)
        {
            UIViewController *viewController = nil;
            if (self.editType == kPosCategoryCreate)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectPosCategoryEditFinish object:category userInfo:nil];
                viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
            }
            else if (self.editType == kPosCategoryCreateParent)
            {
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSParentPosCategoryEditFinish object:category userInfo:nil];
                viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
            }
            else if (self.editType == kPosCategoryCreateSub)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectPosCategoryEditFinish object:category userInfo:nil];
                viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 4)];
            }
            [self.navigationController popToViewController:viewController animated:YES];
            
            return;
        }
    }
    
    [[CBLoadingView shareLoadingView] show];
    if (self.editType == kPosCategoryCreate || self.editType == kPosCategoryCreateParent || self.editType == kPosCategoryCreateSub)
    {
        BSPosCategoryCreateRequest *request = [[BSPosCategoryCreateRequest alloc] initWithPosCategoryName:self.categoryName parent:self.parentCategory sequence:self.sequence];
        [request execute];
    }
    else if (self.editType == kPosCategoryEdit)
    {
        BSPosCategoryCreateRequest *request = [[BSPosCategoryCreateRequest alloc] initWithPosCategoryID:self.posCategory.categoryID categoryName:self.categoryName parent:self.parentCategory sequence:self.sequence];
        [request execute];
    }
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSPosCategoryCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            CDProjectCategory *category = (CDProjectCategory *)[notification.userInfo objectForKey:@"object"];
            UIViewController *viewController = nil;
            if (self.editType == kPosCategoryCreate)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectPosCategoryEditFinish object:category userInfo:nil];
                viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
            }
            else if (self.editType == kPosCategoryCreateParent)
            {
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSParentPosCategoryEditFinish object:category userInfo:nil];
                viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
            }
            else if (self.editType == kPosCategoryCreateSub)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectPosCategoryEditFinish object:category userInfo:nil];
                viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 4)];
            }
            [self.navigationController popToViewController:viewController animated:YES];
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
    else if ([notification.name isEqualToString:kBSParentPosCategoryEditFinish])
    {
        self.parentCategory = (CDProjectCategory *)notification.object;
        BSEditCell *cell = (BSEditCell *)[self.categoryTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kPosCategoryParent inSection:0]];
        cell.contentField.text = self.parentCategory.categoryName;
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.editType == kPosCategoryCreate)
    {
        return kPosCategoryRowCount;
    }
    else if (self.editType == kPosCategoryCreateParent)
    {
        return kPosCategoryParentCount;
    }
    else if (self.editType == kPosCategoryCreateSub)
    {
        return kPosCategorySubCount;
    }
    else if (self.editType == kPosCategoryEdit)
    {
        return kPosCategoryEditCount;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPosCategoryCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSEditCellIdentifier";
    BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentField.delegate = self;
    }
    
    cell.contentField.tag = indexPath.section * 100 + indexPath.row;
    
    cell.arrowImageView.hidden = NO;
    if (indexPath.row == kPosCategoryName)
    {
        cell.titleLabel.text = LS(@"PosCategoryName");
        cell.contentField.enabled = YES;
        cell.contentField.placeholder = LS(@"PleaseEnter");
        cell.contentField.text = self.categoryName;
    }
    else
    {
        if (self.editType == kPosCategoryCreate || self.editType == kPosCategoryCreateSub || self.editType == kPosCategoryEdit)
        {
            if (indexPath.row == kPosCategoryParent)
            {
                cell.titleLabel.text = LS(@"ParentPosCategory");
                cell.contentField.enabled = NO;
                cell.contentField.placeholder = LS(@"PleaseSelect");
                if (self.parentCategory != nil)
                {
                    cell.contentField.text = self.parentCategory.categoryName;
                }
                else
                {
                    cell.contentField.text = @"";
                }
                
                if (self.editType == kPosCategoryCreateSub)
                {
                    cell.arrowImageView.hidden = YES;
                }
            }
            else if (indexPath.row == kPosCategorySequence)
            {
                cell.titleLabel.text = LS(@"PosCategorySequence");
                cell.contentField.enabled = YES;
                cell.contentField.placeholder = LS(@"PleaseEnter");
                cell.contentField.text = [self.sequence stringValue];
            }
        }
        else if (self.editType == kPosCategoryCreateParent)
        {
            if (indexPath.row == kPosCategoryParentSequence)
            {
                cell.titleLabel.text = LS(@"PosCategorySequence");
                cell.contentField.enabled = YES;
                cell.contentField.placeholder = LS(@"PleaseEnter");
                cell.contentField.text = [self.sequence stringValue];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (self.editType == kPosCategoryCreate && indexPath.row == kPosCategoryParent)
    {
        PosCategoryViewController *viewController = [[PosCategoryViewController alloc] initWithPosCategoryType:kPosCategoryJustParent posCategory:self.parentCategory];
        [self.navigationController pushViewController:viewController animated:YES];
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
    NSInteger row = textField.tag % 100;
    if (row != kPosCategoryName)
    {
        if (self.editType == kPosCategoryCreate)
        {
            if (row == kPosCategorySequence)
            {
                if (textField.text.integerValue == 0)
                {
                    textField.text = @"";
                }
            }
        }
        else if (self.editType == kPosCategoryCreateParent)
        {
            if (row == kPosCategoryParentSequence)
            {
                if (textField.text.integerValue == 0)
                {
                    textField.text = @"";
                }
            }
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger row = textField.tag % 100;
    if (row == kPosCategoryName)
    {
        self.categoryName = textField.text;
    }
    else
    {
        if (self.editType == kPosCategoryCreate)
        {
            if (row == kPosCategorySequence)
            {
                self.sequence = [NSNumber numberWithInteger:[textField.text integerValue]];
            }
        }
        else if (self.editType == kPosCategoryCreateParent)
        {
            if (row == kPosCategoryParentSequence)
            {
                self.sequence = [NSNumber numberWithInteger:[textField.text integerValue]];
            }
        }
    }
}


@end
