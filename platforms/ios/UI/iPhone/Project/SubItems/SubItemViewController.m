//
//  SubItemViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "SubItemViewController.h"
#import "CBIsNoneView.h"
#import "BSCommonCell.h"
#import "BSSubItem.h"
#import "SubItemCreateViewController.h"

#define kSubItemCellHeight   60.0

@interface SubItemViewController ()

@property (nonatomic, assign) kPadBornCategoryType projectType;
@property (nonatomic, strong) NSMutableArray *subItems;

@property (nonatomic, strong) CBIsNoneView *isNoneView;
@property (nonatomic, strong) UITableView *subItemTableView;

@end

@implementation SubItemViewController

- (id)initWithSubItems:(NSMutableArray *)subItems projectType:(kPadBornCategoryType)projectType
{
    self = [super initWithNibName:NIBCT(@"SubItemViewController") bundle:nil];
    if (self != nil)
    {
        self.projectType = projectType;
        self.subItems = subItems;
        self.title = LS(@"ProjectDetailSubItemTitle");
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
    
    [self registerNofitificationForMainThread:kBSProjectSubItemEditFinish];
    
    self.isNoneView = [[CBIsNoneView alloc] initWithImage:[UIImage imageNamed:@"sub_items_is_none"] message:nil buttonTitle:nil];
    self.isNoneView.hidden = YES;
    [self.isNoneView showNoneViewInView:self.view];
    
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
    if (self.subItems.count == 0)
    {
        self.isNoneView.hidden = NO;
        self.subItemTableView.hidden = YES;
    }
    else
    {
        self.isNoneView.hidden = YES;
        self.subItemTableView.hidden = NO;
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


-(void)swipBack:(UIGestureRecognizer *)gesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectSubItemEditFinish object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didBackBarButtonItemClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectSubItemEditFinish object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRightBarButtonItemClick:(id)sender
{
    SubItemCreateViewController *viewController = [[SubItemCreateViewController alloc] initWithSubItems:self.subItems projectType:self.projectType];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSProjectSubItemEditFinish])
    {
        [self.subItemTableView reloadData];
        if (self.subItems.count == 0)
        {
            self.isNoneView.hidden = NO;
            self.subItemTableView.hidden = YES;
        }
        else
        {
            self.isNoneView.hidden = YES;
            self.subItemTableView.hidden = NO;
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.subItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSubItemCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSCommonCellIdentifier";
    BSCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    BSSubItem *subItem = [self.subItems objectAtIndex:indexPath.row];
    cell.titleLabel.text = subItem.itemName;
    cell.detailLabel.text = [NSString stringWithFormat:LS(@"SubItemDetailTitle"), subItem.amount];
    cell.valueLabel.text = [NSString stringWithFormat:@"%.2f", subItem.amount * subItem.itemSetPrice];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SubItemCreateViewController *viewController = [[SubItemCreateViewController alloc] initWithSubItems:self.subItems editIndex:indexPath.row projectType:self.projectType];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.subItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        if (self.subItems.count == 0)
        {
            self.isNoneView.hidden = NO;
            self.subItemTableView.hidden = YES;
        }
    }
}


@end
