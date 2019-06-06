//
//  UomCategoryCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "UomCategoryCreateViewController.h"
#import "CBLoadingView.h"
#import "BSEditCell.h"
#import "BSUomCategoryCreateRequest.h"

typedef enum kUomCategorySection
{
    kUomCategorySectionInfo,
    kUomCategorySectionCount
}kUomCategorySection;

typedef enum kUomCategoryInfoRow
{
    kUomCategoryInfoName,
    kUomCategoryInfoRowCount
}kUomCategoryInfoRow;

#define kUomCategoryCellHeight       50.0


@interface UomCategoryCreateViewController ()

@property (nonatomic, assign) kUomCategoryEditType editType;
@property (nonatomic, strong) CDProjectUomCategory *uomCategory;

@property (nonatomic, strong) NSString *uomCategoryName;

@property (nonatomic, strong) UITableView *uomTableView;

@end

@implementation UomCategoryCreateViewController

- (id)initWithType:(kUomCategoryEditType)editType
{
    self = [super initWithNibName:NIBCT(@"UomCategoryCreateViewController") bundle:nil];
    if (self != nil)
    {
        self.editType = editType;
        if (self.editType == kUomCategoryCreate)
        {
            self.title = LS(@"UomCategoryCreateTitle");
        }
    }
    
    return self;
}

- (id)initWithUomCategory:(CDProjectUomCategory *)uomCategory
{
    self = [super initWithNibName:NIBCT(@"UomCategoryCreateViewController") bundle:nil];
    if (self != nil)
    {
        self.uomCategory = uomCategory;
        self.editType = kUomCategoryEdit;
        self.title = self.uomCategory.uomCategoryName;
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
    
    [self registerNofitificationForMainThread:kBSUomCategoryCreateResponse];
    
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
    if (self.uomCategoryName.length == 0)
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
        CDProjectUomCategory *uomCategory = [[BSCoreDataManager currentManager] findEntity:@"CDProjectUomCategory" withValue:self.uomCategoryName forKey:@"uomCategoryName"];
        if (uomCategory)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSUomCategoryEditFinish object:uomCategory userInfo:nil];
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
            [self.navigationController popToViewController:viewController animated:YES];
            
            return;
        }
    }
    
    BSUomCategoryCreateRequest *request = [[BSUomCategoryCreateRequest alloc] initWithUomCategoryName:self.uomCategoryName];
    [request execute];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSUomCategoryCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            CDProjectUomCategory *uomCategory = (CDProjectUomCategory *)[notification.userInfo objectForKey:@"object"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSUomCategoryEditFinish object:uomCategory userInfo:nil];
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
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kUomCategorySectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kUomCategoryInfoRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kUomCategoryCellHeight;
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
    
    if (indexPath.row == kUomCategoryInfoName)
    {
        cell.titleLabel.text = LS(@"UomCategoryName");
        cell.contentField.enabled = YES;
        cell.contentField.placeholder = LS(@"PleaseEnter");
        cell.contentField.text = self.uomCategoryName;
    }
    
    return cell;
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
    self.uomCategoryName = textField.text;
}


@end
