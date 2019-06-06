//
//  PosCategoryViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "PosCategoryViewController.h"
#import "CBIsNoneView.h"
#import "BSSelectCell.h"
#import "SubPosCategoryViewController.h"
#import "PosCategoryCreateViewController.h"

#define kPosCategoryCellHeight      50.0

@interface PosCategoryViewController ()

@property (nonatomic, assign) kPosCategoryType type;
@property (nonatomic, strong) CDProjectCategory *posCategory;

@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic, strong) CBIsNoneView *isNoneView;

@end

@implementation PosCategoryViewController

- (id)initWithPosCategoryType:(kPosCategoryType)type posCategory:(CDProjectCategory *)posCategory
{
    self = [super initWithNibName:NIBCT(@"PosCategoryViewController") bundle:nil];
    if (self != nil)
    {
        self.type = type;
        self.posCategory = posCategory;
        self.categoryArray = [[BSCoreDataManager currentManager] fetchAllTopProjectCategory];
        if (self.type == kPosCategoryDefault)
        {
            self.title = LS(@"ProjectInfoPosCategoryTitle");
        }
        else if (self.type == kPosCategoryJustParent)
        {
            self.title = LS(@"ParentPosCategoryTitle");
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
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n"] highlightedImage:[UIImage imageNamed:@"navi_add_h"]];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.isNoneView = [[CBIsNoneView alloc] initWithImage:[UIImage imageNamed:@"pos_category_is_null"] message:nil buttonTitle:nil];
    self.isNoneView.hidden = YES;
    [self.isNoneView showNoneViewInView:self.view];
    
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
    
    if (self.categoryArray.count == 0)
    {
        self.isNoneView.hidden = NO;
        self.categoryTableView.hidden = YES;
    }
    else
    {
        self.isNoneView.hidden = YES;
        self.categoryTableView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    ;
}


#pragma mark -
#pragma mark Required Methods

-(void)swipBack:(UIGestureRecognizer *)gesture
{
    if (self.posCategory != nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectPosCategoryEditFinish object:self.posCategory userInfo:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didBackBarButtonItemClick:(id)sender
{
    if (self.posCategory != nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectPosCategoryEditFinish object:self.posCategory userInfo:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRightBarButtonItemClick:(id)sender
{
    if (self.type == kPosCategoryDefault)
    {
        PosCategoryCreateViewController *viewController = [[PosCategoryCreateViewController alloc] initWithType:kPosCategoryCreate posCategory:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (self.type == kPosCategoryJustParent)
    {
        PosCategoryCreateViewController *viewController = [[PosCategoryCreateViewController alloc] initWithType:kPosCategoryCreateParent posCategory:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPosCategoryCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSSelectCellIdentifier";
    BSSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CDProjectCategory *category = [self.categoryArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = category.categoryName;
    if (self.posCategory != nil )
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
    
    CDProjectCategory *category = [self.categoryArray objectAtIndex:indexPath.row];
    if ((self.posCategory.parent == nil && self.posCategory.categoryID.integerValue != category.categoryID.integerValue))
    {
        self.posCategory = category;
    }
    else if ( self.posCategory.parent != nil )
    {
        BOOL bFind = FALSE;
        CDProjectCategory* tempCategory = self.posCategory;
        while (tempCategory)
        {
            if ( tempCategory.categoryID.integerValue == category.categoryID.integerValue )
            {
                bFind = TRUE;
                break;
            }
            
            tempCategory = tempCategory.parent;
        }
        
        if ( !bFind )
        {
            self.posCategory = category;
        }
    }
    
    [tableView reloadData];
    
    if (self.type == kPosCategoryDefault)
    {
        SubPosCategoryViewController *viewController = [[SubPosCategoryViewController alloc] initWithParentCategory:category posCategory:self.posCategory];
        viewController.popViewControllerIndex = self.navigationController.viewControllers.count - 2;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (self.type == kPosCategoryJustParent)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSParentPosCategoryEditFinish object:self.posCategory userInfo:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
