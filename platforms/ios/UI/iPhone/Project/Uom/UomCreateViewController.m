//
//  UomCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "UomCreateViewController.h"
#import "CBLoadingView.h"
#import "BSEditCell.h"
#import "BSUomCreateRequest.h"
#import "BSOptionViewController.h"
#import "UomCategoryViewController.h"

typedef enum kUomSection
{
    kUomSectionInfo,
    kUomSectionCount
}kUomSection;

typedef enum kUomInfoRow
{
    kUomInfoName,
    kUomInfoCategory,
    kUomInfoType,
    kUomInfoRowCount
}kProjectImageRow;

#define kUomCellHeight       50.0


@interface UomCreateViewController ()

@property (nonatomic, assign) kUomEditType editType;
@property (nonatomic, strong) CDProjectUom *projectUom;

@property (nonatomic, strong) NSString *uomName;
@property (nonatomic, strong) NSString *uomType;
@property (nonatomic, strong) NSNumber *uomCategoryId;
@property (nonatomic, strong) NSString *uomCategoryName;

@property (nonatomic, strong) UITableView *uomTableView;

@end

@implementation UomCreateViewController

- (id)initWithType:(kUomEditType)editType
{
    self = [super initWithNibName:NIBCT(@"UomCreateViewController") bundle:nil];
    if (self != nil)
    {
        self.editType = editType;
        if (self.editType == kUomCreate)
        {
            self.uomType = @"reference";
            self.title = LS(@"UomCreateTitle");
        }
    }
    
    return self;
}

- (id)initWithUom:(CDProjectUom *)projectUom
{
    self = [super initWithNibName:NIBCT(@"UomCreateViewController") bundle:nil];
    if (self != nil)
    {
        self.projectUom = projectUom;
        self.editType = kUomEdit;
        self.title = self.projectUom.uomName;
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
    
    [self registerNofitificationForMainThread:kBSUomCreateResponse];
    [self registerNofitificationForMainThread:kBSUomCategoryEditFinish];
    [self registerNofitificationForMainThread:kBSPorjectUomInfoTypeSelected];
    
    self.uomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.uomTableView.backgroundColor = [UIColor clearColor];
    self.uomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.uomTableView.delegate = self;
    self.uomTableView.dataSource = self;
    self.uomTableView.showsVerticalScrollIndicator = NO;
    self.uomTableView.showsHorizontalScrollIndicator = NO;
    self.uomTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.uomTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.uomTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.uomTableView.tableFooterView = footerView;
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
    if (self.uomName.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"UomNameCanNotBeNULL")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    else if (self.uomCategoryId.integerValue == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"UomCategoryNameCanNotBeNULL")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    else
    {
        CDProjectUom *uom = [[BSCoreDataManager currentManager] findEntity:@"CDProjectUom" withValue:self.uomName forKey:[NSString stringWithFormat:@"uomCategoryID == %@ and uomName", self.uomCategoryId]];
        if (uom)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectUomEditFinish object:uom userInfo:nil];
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
            [self.navigationController popToViewController:viewController animated:YES];
            
            return;
        }
    }
    
    BSUomCreateRequest *request = [[BSUomCreateRequest alloc] initWithUomName:self.uomName uomType:self.uomType uomCategoryId:self.uomCategoryId uomCategoryName:self.uomCategoryName];
    [request execute];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSUomCategoryEditFinish])
    {
        CDProjectUomCategory *uomCategory = (CDProjectUomCategory *)notification.object;
        self.uomCategoryId = uomCategory.uomCategoryID;
        self.uomCategoryName = uomCategory.uomCategoryName;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kUomInfoCategory inSection:kUomSectionInfo];
        BSEditCell *cell = (BSEditCell *)[self.uomTableView cellForRowAtIndexPath:indexPath];
        cell.contentField.text = self.uomCategoryName;
    }
    else if ([notification.name isEqualToString:kBSUomCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            CDProjectUom *uom = (CDProjectUom *)[notification.userInfo objectForKey:@"object"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectUomEditFinish object:uom userInfo:nil];
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
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
    else if ([notification.name isEqualToString:kBSPorjectUomInfoTypeSelected])
    {
        self.uomType = (NSString *)notification.object;;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kUomInfoType inSection:kUomSectionInfo];
        BSEditCell *cell = (BSEditCell *)[self.uomTableView cellForRowAtIndexPath:indexPath];
        cell.contentField.text = LS(self.uomType);
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kUomSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kUomInfoRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kUomCellHeight;
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
    
    if (indexPath.row == kUomInfoName)
    {
        cell.titleLabel.text = LS(@"UomInfoUomName");
        cell.contentField.enabled = YES;
        cell.contentField.placeholder = LS(@"PleaseEnter");
        cell.contentField.text = self.uomName;
    }
    else if (indexPath.row == kUomInfoCategory)
    {
        cell.titleLabel.text = LS(@"UomInfoUomCategory");
        cell.contentField.enabled = NO;
        cell.contentField.placeholder = LS(@"PleaseSelect");
        cell.contentField.text = self.uomCategoryName;
    }
    else if (indexPath.row == kUomInfoType)
    {
        cell.titleLabel.text = LS(@"UomInfoUomType");
        cell.contentField.enabled = NO;
        cell.contentField.placeholder = LS(@"PleaseSelect");
        cell.contentField.text = LS(self.uomType);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == kUomInfoCategory)
    {
        UomCategoryViewController *viewController = [[UomCategoryViewController alloc] initWithProjectUomCategoryID:self.uomCategoryId];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == kUomInfoType)
    {
        NSArray *options = [NSArray arrayWithObjects:@"bigger", @"reference", @"smaller", nil];
        BSOptionViewController *viewController = [[BSOptionViewController alloc] initWithTitle:LS(@"UomInfoUomType") options:options selectedstr:self.uomType notification:kBSPorjectUomInfoTypeSelected];
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.uomName = textField.text;
}


@end
