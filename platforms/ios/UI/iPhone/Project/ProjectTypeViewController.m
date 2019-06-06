//
//  ProjectTypeViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/8.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ProjectTypeViewController.h"
#import "BSEditCell.h"
#import "ProjectCreateViewController.h"

#define kPadBornCategoryCellHeight      50.0
#define kPadBornCategoryItems           @[LS(@"BornCategory1"), LS(@"BornCategory2"), LS(@"BornCategory3"), LS(@"BornCategory4")]

@interface ProjectTypeViewController ()

@property (nonatomic, assign) UIViewController *mParentVC;

@end


@implementation ProjectTypeViewController

- (id)initWithParentViewController:(UIViewController *)viewController
{
    self = [super initWithNibName:NIBCT(@"ProjectTypeViewController") bundle:nil];
    if (self != nil)
    {
        self.mParentVC = viewController;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.title = LS(@"ProjectTypeNaviTitle");
    self.view.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UITableView *typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    typeTableView.backgroundColor = [UIColor clearColor];
    typeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    typeTableView.delegate = self;
    typeTableView.dataSource = self;
    typeTableView.showsVerticalScrollIndicator = NO;
    typeTableView.showsHorizontalScrollIndicator = NO;
    typeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:typeTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    typeTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    typeTableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kPadBornCategoryItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadBornCategoryCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSEditCellIdentifier";
    BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentField.enabled = NO;
        cell.contentField.text = @"";
        cell.contentField.placeholder = @"";
        cell.arrowImageView.hidden = NO;
    }
    
    cell.titleLabel.text = [kPadBornCategoryItems objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProjectCreateViewController *viewController = [[ProjectCreateViewController alloc] initWithProjectType:indexPath.row + 1];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
