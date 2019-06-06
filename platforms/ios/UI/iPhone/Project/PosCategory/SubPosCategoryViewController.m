//
//  SubPosCategoryViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "SubPosCategoryViewController.h"
#import "CBIsNoneView.h"
#import "BSSelectCell.h"
#import "PosCategoryCreateViewController.h"

#define kSubPosCategoryCellHeight      50.0

@interface SubPosCategoryViewController ()

@property (nonatomic, strong) CDProjectCategory *parentCategory;
@property (nonatomic, strong) CDProjectCategory *posCategory;//选中的那个

@property (nonatomic, strong) NSArray *subCategoryArray;
@property (nonatomic, strong) UITableView *subCategoryTableView;
@property (nonatomic, strong) CBIsNoneView *isNoneView;

@end

@implementation SubPosCategoryViewController

- (id)initWithParentCategory:(CDProjectCategory *)parentCategory posCategory:(CDProjectCategory *)posCategory
{
    self = [super initWithNibName:NIBCT(@"SubPosCategoryViewController") bundle:nil];
    if (self != nil)
    {
        self.parentCategory = parentCategory;
        self.posCategory = posCategory;
        self.title = self.parentCategory.categoryName;
        self.subCategoryArray = self.parentCategory.subCategory.array;
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
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n"] highlightedImage:[UIImage imageNamed:@"navi_add_h"]];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.isNoneView = [[CBIsNoneView alloc] initWithImage:[UIImage imageNamed:@"pos_category_is_null"] message:nil buttonTitle:nil];
    self.isNoneView.hidden = YES;
    [self.isNoneView showNoneViewInView:self.view];
    
    self.subCategoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.subCategoryTableView.backgroundColor = [UIColor clearColor];
    self.subCategoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.subCategoryTableView.delegate = self;
    self.subCategoryTableView.dataSource = self;
    self.subCategoryTableView.showsVerticalScrollIndicator = NO;
    self.subCategoryTableView.showsHorizontalScrollIndicator = NO;
    self.subCategoryTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.subCategoryTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.subCategoryTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.subCategoryTableView.tableFooterView = footerView;
    
    if (self.subCategoryArray.count == 0)
    {
        self.isNoneView.hidden = NO;
        self.subCategoryTableView.hidden = YES;
    }
    else
    {
        self.isNoneView.hidden = YES;
        self.subCategoryTableView.hidden = NO;
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
    PosCategoryCreateViewController *viewController = [[PosCategoryCreateViewController alloc] initWithType:kPosCategoryCreateSub posCategory:self.parentCategory];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSPosCategoryCreateResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.parentCategory = [[BSCoreDataManager currentManager] findEntity:@"CDProjectCategory" withValue:self.parentCategory.categoryID forKey:@"categoryID"];
            self.subCategoryArray = self.parentCategory.subCategory.array;
            [self.subCategoryTableView reloadData];
            if (self.subCategoryArray.count == 0)
            {
                self.isNoneView.hidden = NO;
                self.subCategoryTableView.hidden = YES;
            }
            else
            {
                self.isNoneView.hidden = YES;
                self.subCategoryTableView.hidden = NO;
            }
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.subCategoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSubPosCategoryCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSSelectCellIdentifier";
    BSSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CDProjectCategory *category = [self.subCategoryArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = category.categoryName;
    if (self.posCategory.parent != nil )
    {
        cell.selectImageView.hidden = YES;
        CDProjectCategory* tempCategory = self.posCategory;
        while (tempCategory)
        {
            if ( tempCategory.categoryID.integerValue == category.categoryID.integerValue )
            {
                cell.selectImageView.hidden = NO;
                break;
            }
            
            tempCategory = tempCategory.parent;
        }
    }
    else
    {
        cell.selectImageView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.parentCategory = [self.subCategoryArray objectAtIndex:indexPath.row];
    if ( self.parentCategory.subCategory.count == 0 )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectPosCategoryEditFinish object:self.parentCategory userInfo:nil];
        UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:self.popViewControllerIndex];
        [self.navigationController popToViewController:viewController animated:YES];
    }
    else
    {
        SubPosCategoryViewController *viewController = [[SubPosCategoryViewController alloc] initWithParentCategory:self.parentCategory posCategory:self.posCategory];
        viewController.popViewControllerIndex = self.popViewControllerIndex;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
