//
//  UomCategoryViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "UomCategoryViewController.h"
#import "BSSelectCell.h"
#import "CBIsNoneView.h"
#import "UomCategoryCreateViewController.h"

#define kUomCategoryCellHeight   50.0

@interface UomCategoryViewController ()

@property (nonatomic, strong) NSNumber *uomCategoryID;
@property (nonatomic, strong) NSArray *uomCategorys;

@property (nonatomic, strong) CBIsNoneView *isNoneView;
@property (nonatomic, strong) UITableView *uomCategoryTableView;

@end

@implementation UomCategoryViewController

- (id)initWithProjectUomCategoryID:(NSNumber *)uomCategoryID
{
    self = [super initWithNibName:NIBCT(@"UomCategoryViewController") bundle:nil];
    if (self != nil)
    {
        self.uomCategoryID = uomCategoryID;
        self.uomCategorys = [NSArray arrayWithArray:[[BSCoreDataManager currentManager] fetchAllProjectUomCategory]];;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.title = LS(@"UomCategoryNaviTitle");
    self.view.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n"] highlightedImage:[UIImage imageNamed:@"navi_add_h"]];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.isNoneView = [[CBIsNoneView alloc] initWithImage:[UIImage imageNamed:@"consumables_is_none"] message:nil buttonTitle:nil];
    self.isNoneView.hidden = YES;
    [self.isNoneView showNoneViewInView:self.view];
    
    self.uomCategoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.uomCategoryTableView.backgroundColor = [UIColor clearColor];
    self.uomCategoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.uomCategoryTableView.delegate = self;
    self.uomCategoryTableView.dataSource = self;
    self.uomCategoryTableView.showsVerticalScrollIndicator = NO;
    self.uomCategoryTableView.showsHorizontalScrollIndicator = NO;
    self.uomCategoryTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.uomCategoryTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.uomCategoryTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.uomCategoryTableView.tableFooterView = footerView;
    if (self.uomCategorys.count == 0)
    {
        self.isNoneView.hidden = NO;
        self.uomCategoryTableView.hidden = YES;
    }
    else
    {
        self.isNoneView.hidden = YES;
        self.uomCategoryTableView.hidden = NO;
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
    UomCategoryCreateViewController *viewController = [[UomCategoryCreateViewController alloc] initWithType:kUomCategoryCreate];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.uomCategorys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kUomCategoryCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSSelectCellIdentifier";
    BSSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CDProjectUomCategory *uomCategory = [self.uomCategorys objectAtIndex:indexPath.row];
    cell.titleLabel.text = uomCategory.uomCategoryName;
    if (self.uomCategoryID.integerValue == uomCategory.uomCategoryID.integerValue)
    {
        cell.selectImageView.hidden = NO;
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
    
    CDProjectUomCategory *uomCategory = [self.uomCategorys objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSUomCategoryEditFinish object:uomCategory userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
