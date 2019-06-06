//
//  UomViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "UomViewController.h"
#import "BSSelectCell.h"
#import "CBIsNoneView.h"
#import "UomCreateViewController.h"

#define kUomCellHeight   50.0

@interface UomViewController ()

@property (nonatomic, strong) NSNumber *uomID;
@property (nonatomic, strong) CDProjectUom *projectUom;
@property (nonatomic, strong) NSArray *projectUoms;

@property (nonatomic, strong) CBIsNoneView *isNoneView;
@property (nonatomic, strong) UITableView *uomTableView;

@end

@implementation UomViewController

- (id)initWithProjectUomID:(NSNumber *)uomID
{
    self = [super initWithNibName:NIBCT(@"UomViewController") bundle:nil];
    if (self != nil)
    {
        self.uomID = uomID;
        self.projectUoms = [NSArray arrayWithArray:[[BSCoreDataManager currentManager] fetchAllProjectUom]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.title = LS(@"UomNaviTitle");
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
    if (self.projectUoms.count == 0)
    {
        self.isNoneView.hidden = NO;
        self.uomTableView.hidden = YES;
    }
    else
    {
        self.isNoneView.hidden = YES;
        self.uomTableView.hidden = NO;
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
    UomCreateViewController *viewController = [[UomCreateViewController alloc] initWithType:kUomCreate];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.projectUoms.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kUomCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSSelectCellIdentifier";
    BSSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CDProjectUom *uom = [self.projectUoms objectAtIndex:indexPath.row];
    cell.titleLabel.text = uom.uomName;
    if (self.uomID.integerValue == uom.uomID.integerValue)
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
    
    CDProjectUom *projectUom = [self.projectUoms objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectUomEditFinish object:projectUom userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
