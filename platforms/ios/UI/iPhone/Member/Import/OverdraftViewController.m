//
//  OverdraftViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/8/20.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "OverdraftViewController.h"
#import "BSOverdraft.h"
#import "BSCommonCell.h"
#import "CBIsNoneView.h"
#import "OverdraftCreateViewController.h"

#define kOverdraftCellHeight    60.0

@interface OverdraftViewController ()

@property (nonatomic, strong) NSMutableArray *overdrafts;

@property (nonatomic, strong) CBIsNoneView *isNoneView;
@property (nonatomic, strong) UITableView *overdraftTableView;

@end

@implementation OverdraftViewController

- (id)initWithOverdrafts:(NSMutableArray *)overdrafts
{
    self = [super initWithNibName:NIBCT(@"CardItemViewController") bundle:nil];
    if (self)
    {
        self.overdrafts = overdrafts;
        self.title = LS(@"Overdraft");
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
    
    [self registerNofitificationForMainThread:kBSOverdraftCreateResult];
    
    self.isNoneView = [[CBIsNoneView alloc] initWithImage:[UIImage imageNamed:@"sub_items_is_none"] message:nil buttonTitle:nil];
    self.isNoneView.hidden = YES;
    [self.isNoneView showNoneViewInView:self.view];
    
    self.overdraftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.overdraftTableView.backgroundColor = [UIColor clearColor];
    self.overdraftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.overdraftTableView.delegate = self;
    self.overdraftTableView.dataSource = self;
    self.overdraftTableView.showsVerticalScrollIndicator = NO;
    self.overdraftTableView.showsHorizontalScrollIndicator = NO;
    self.overdraftTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.overdraftTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.overdraftTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.overdraftTableView.tableFooterView = footerView;
    if (self.overdrafts.count == 0)
    {
        self.isNoneView.hidden = NO;
        self.overdraftTableView.hidden = YES;
    }
    else
    {
        self.isNoneView.hidden = YES;
        self.overdraftTableView.hidden = NO;
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

- (void)didBackBarButtonItemClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSOverdraftEditFinish object:self.overdrafts userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRightBarButtonItemClick:(id)sender
{
    OverdraftCreateViewController *viewController = [[OverdraftCreateViewController alloc] initWithOverdrafts:self.overdrafts editIndex:-1];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSOverdraftCreateResult])
    {
        self.overdrafts = (NSMutableArray *)notification.object;
        [self.overdraftTableView reloadData];
        if (self.overdrafts.count == 0)
        {
            self.isNoneView.hidden = NO;
            self.overdraftTableView.hidden = YES;
        }
        else
        {
            self.isNoneView.hidden = YES;
            self.overdraftTableView.hidden = NO;
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.overdrafts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kOverdraftCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSCommonCellIdentifier";
    BSCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.valueLabel.hidden = NO;
    }
    
    BSOverdraft *overdraft = [self.overdrafts objectAtIndex:indexPath.row];
    cell.titleLabel.text = overdraft.name;
    cell.detailLabel.text = [NSString stringWithFormat:LS(@"OverdraftDetailTitle"), LS(overdraft.type)];
    cell.valueLabel.text = [NSString stringWithFormat:@"%.2f", overdraft.amount];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OverdraftCreateViewController *viewController = [[OverdraftCreateViewController alloc] initWithOverdrafts:self.overdrafts editIndex:indexPath.row];
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
        [self.overdrafts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        if (self.overdrafts.count == 0)
        {
            self.isNoneView.hidden = NO;
            self.overdraftTableView.hidden = YES;
        }
    }
}

@end
