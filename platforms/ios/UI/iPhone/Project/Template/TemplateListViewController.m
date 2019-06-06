//
//  TemplateListViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "TemplateListViewController.h"
#import "CBLoadingView.h"
#import "CBIsNoneView.h"
#import "BSItemCell.h"
#import "BSEditCell.h"
#import "BSSectionFooter.h"
#import "BSProjectItem.h"
#import "BSProjectItemCreateRequest.h"

#define kItemInfoCellHeight         60.0
#define kItemDetailCellHeight       50.0

typedef enum kTemplateListItemRow
{
    kTemplateListItemInfo,
    kTemplateListItemBarCode,
    kTemplateListItemInternalNum,
    kTemplateListItemRowCount
}kTemplateListItemRow;

@interface TemplateListViewController ()

@property (nonatomic, strong) CDProjectTemplate *projectTemplate;
@property (nonatomic, strong) NSMutableArray *bsProjectItems;

@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) BOOL isRequestSuccess;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, assign) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSMutableDictionary *cachePicParams;

@property (nonatomic, strong) CBIsNoneView *isNoneView;
@property (nonatomic, strong) UITableView *templateTableView;

@end

@implementation TemplateListViewController

- (id)initWithProjectTemplate:(CDProjectTemplate *)projectTemplate
{
    self = [super initWithNibName:NIBCT(@"TemplateListViewController") bundle:nil];
    if (self != nil)
    {
        self.title = LS(@"TemplateItemList");
        self.projectTemplate = projectTemplate;
        self.bsProjectItems = [NSMutableArray array];
        for (int i = 0; i < self.projectTemplate.projectItems.count; i++)
        {
            CDProjectItem *projectItem = [self.projectTemplate.projectItems objectAtIndex:i];
            BSProjectItem *bsProjectItem = [[BSProjectItem alloc] init];
            bsProjectItem.projectID = projectItem.itemID;
            bsProjectItem.projectName = projectItem.itemName;
            bsProjectItem.projectPrice = projectItem.totalPrice.floatValue;
            bsProjectItem.projectType = projectItem.type;
            bsProjectItem.posCategory = projectItem.category;
            bsProjectItem.barcode = projectItem.barcode;
            bsProjectItem.defaultCode = projectItem.defaultCode;
            [self.bsProjectItems addObject:bsProjectItem];
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
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:LS(@"Save")];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.cachePicParams = [[NSMutableDictionary alloc] init];
    [self registerNofitificationForMainThread:kBSProjectItemCreateResponse];
    
    self.isNoneView = [[CBIsNoneView alloc] initWithImage:[UIImage imageNamed:@"template_is_null"] message:nil buttonTitle:nil];
    self.isNoneView.hidden = YES;
    [self.isNoneView showNoneViewInView:self.view];
    
    self.templateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.templateTableView.backgroundColor = [UIColor clearColor];
    self.templateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.templateTableView.delegate = self;
    self.templateTableView.dataSource = self;
    self.templateTableView.showsVerticalScrollIndicator = NO;
    self.templateTableView.showsHorizontalScrollIndicator = NO;
    self.templateTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.templateTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.templateTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.templateTableView.tableFooterView = footerView;
    if (self.bsProjectItems.count == 0)
    {
        self.isNoneView.hidden = NO;
        self.templateTableView.hidden = YES;
    }
    else
    {
        self.isNoneView.hidden = YES;
        self.templateTableView.hidden = NO;
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
    self.requestCount = 0;
    self.isRequestSuccess = YES;
    NSMutableArray *requests = [NSMutableArray array];
    for (int i = 0; i < self.projectTemplate.projectItems.count; i++)
    {
        CDProjectItem *projectItem = [self.projectTemplate.projectItems objectAtIndex:i];
        BSProjectItem *bsProjectItem = [self.bsProjectItems objectAtIndex:i];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (bsProjectItem.barcode.length != 0 && ![bsProjectItem.barcode isEqualToString:@"0"] && ![bsProjectItem.barcode isEqualToString:projectItem.barcode])
        {
            [params setObject:bsProjectItem.barcode forKey:@"barcode"];
        }
        if (bsProjectItem.defaultCode.length != 0 && ![bsProjectItem.defaultCode isEqualToString:@"0"] && ![bsProjectItem.defaultCode isEqualToString:projectItem.defaultCode])
        {
            [params setObject:bsProjectItem.defaultCode forKey:@"default_code"];
        }
        
        if (params.allKeys.count != 0)
        {
            [params setObject:self.projectTemplate.bornCategory forKey:@"born_category"];
            BSProjectItemCreateRequest *request = [[BSProjectItemCreateRequest alloc] initWithProjectItemID:bsProjectItem.projectID params:params];
            [requests addObject:request];
        }
    }
    
    self.requestCount = requests.count;
    if (self.requestCount != 0)
    {
        [[CBLoadingView shareLoadingView] show];
        for (BSProjectItemCreateRequest *request in requests)
        {
            [request execute];
        }
    }
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSProjectItemCreateResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.requestCount --;
        }
        else
        {
            self.requestCount --;
            self.isRequestSuccess = NO;
            [[CBLoadingView shareLoadingView] hide];
            if([[notification.userInfo stringValueForKey:@"rm"] length] != 0)
            {
                self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            }
        }
        
        if (self.requestCount == 0)
        {
            [[CBLoadingView shareLoadingView] hide];
            if (self.isRequestSuccess)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                if (self.errorMessage.length != 0)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:self.errorMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.bsProjectItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kTemplateListItemRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section != self.bsProjectItems.count - 1)
    {
        return kBSSectionFooterHeight;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kTemplateListItemInfo)
    {
        return kItemInfoCellHeight;
    }
    
    return kItemDetailCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != self.bsProjectItems.count - 1)
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kTemplateListItemInfo)
    {
        static NSString *CellIdentifier = @"BSItemCellCellIdentifier";
        BSItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[BSItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.arrowImageView.hidden = YES;
        
        CDProjectItem *projectItem = [self.projectTemplate.projectItems objectAtIndex:indexPath.section];
        [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:projectItem.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"project_item_default_48_36"]];
        cell.titleLabel.text = projectItem.itemName;
        NSString *categorystr = [NSString stringWithFormat:@"BornCategory%d", projectItem.projectTemplate.bornCategory.integerValue];
        cell.detailLabel.text = [NSString stringWithFormat:LS(@"ProjectItemDetail"), projectItem.totalPrice.doubleValue, projectItem.uomName, LS(categorystr), LS(projectItem.type)];
        
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentField.tag = indexPath.section * 100 + indexPath.row;
        cell.arrowImageView.alpha = 1.0;
        cell.arrowImageView.hidden = NO;
        cell.scanButton.hidden = YES;
        
        BSProjectItem *bsProjectItem = [self.bsProjectItems objectAtIndex:indexPath.section];
        if (indexPath.row == kTemplateListItemBarCode)
        {
            cell.scanButton.hidden = NO;
            cell.scanButton.tag = indexPath.section * 100 + indexPath.row;
            [cell.scanButton addTarget:self action:@selector(didScanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.arrowImageView.alpha = 0.0;
            cell.titleLabel.text = LS(@"ProjectDetailBarCodeTitle");
            cell.contentField.enabled = YES;
            cell.contentField.placeholder = LS(@"PleaseEnter");
            cell.contentField.text = bsProjectItem.barcode;
        }
        else if (indexPath.row == kTemplateListItemInternalNum)
        {
            cell.titleLabel.text = LS(@"ProjectDetailInternalNumTitle");
            cell.contentField.enabled = YES;
            cell.contentField.placeholder = LS(@"PleaseEnter");
            cell.contentField.text = bsProjectItem.defaultCode;
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    
    BSProjectItem *bsProjectItem = [self.bsProjectItems objectAtIndex:section];
    if (row == kTemplateListItemBarCode)
    {
        bsProjectItem.barcode = textField.text;
    }
    else if (row == kTemplateListItemInternalNum)
    {
        bsProjectItem.defaultCode = textField.text;
    }
}

- (void)didScanButtonClick:(id)sender
{
    UIButton *scanButton = (UIButton *)sender;
    
    NSInteger section = scanButton.tag / 100;
    NSInteger row = scanButton.tag % 100;
    self.currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    if (IS_SDK7)
    {
        BNScanCodeViewController *viewController = [[BNScanCodeViewController alloc] initWithDelegate:self];
        [self.navigationController pushViewController:viewController animated:NO];
    }
    else
    {
    }
}


#pragma mark -
#pragma mark QRCodeViewDelegate Methods

- (void)didQRBackButtonClick:(QRCodeView *)qrCodeView
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark -
#pragma mark BNScanCodeDelegate Methods

- (void)scanCodeViewController:(BNScanCodeViewController *)viewController didScanSuccess:(NSString *)result
{
    BSProjectItem *bsProjectItem = [self.bsProjectItems objectAtIndex:self.currentIndexPath.section];
    bsProjectItem.barcode = result;
    BSEditCell *cell = (BSEditCell *)[self.templateTableView cellForRowAtIndexPath:self.currentIndexPath];
    cell.contentField.text = result;
}


#pragma mark -
#pragma mark ZXingDelegate Methods


@end
