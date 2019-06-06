//
//  ConsumableViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ConsumableViewController.h"
#import "CBIsNoneView.h"
#import "BSCommonCell.h"
#import "BSConsumable.h"
#import "ConsumableCreateViewController.h"

#define kConsumableCellHeight   60.0

@interface ConsumableViewController ()

@property (nonatomic, strong) NSMutableArray *consumables;

@property (nonatomic, strong) CBIsNoneView *isNoneView;
@property (nonatomic, strong) UITableView *consumableTableView;

@end

@implementation ConsumableViewController

- (id)initWithConsumables:(NSMutableArray *)consumables
{
    self = [super initWithNibName:NIBCT(@"ConsumableViewController") bundle:nil];
    if (self != nil)
    {
        self.consumables = consumables;
        self.title = LS(@"ProjectDetailConsumableTitle");
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
    
    [self registerNofitificationForMainThread:kBSConsumablesEditFinish];
    
    self.isNoneView = [[CBIsNoneView alloc] initWithImage:[UIImage imageNamed:@"consumables_is_none"] message:nil buttonTitle:nil];
    self.isNoneView.hidden = YES;
    [self.isNoneView showNoneViewInView:self.view];
    
    self.consumableTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.consumableTableView.backgroundColor = [UIColor clearColor];
    self.consumableTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.consumableTableView.delegate = self;
    self.consumableTableView.dataSource = self;
    self.consumableTableView.showsVerticalScrollIndicator = NO;
    self.consumableTableView.showsHorizontalScrollIndicator = NO;
    self.consumableTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.consumableTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.consumableTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.consumableTableView.tableFooterView = footerView;
    if (self.consumables.count == 0)
    {
        self.isNoneView.hidden = NO;
        self.consumableTableView.hidden = YES;
    }
    else
    {
        self.isNoneView.hidden = YES;
        self.consumableTableView.hidden = NO;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectConsumableEditFinish object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didBackBarButtonItemClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectConsumableEditFinish object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRightBarButtonItemClick:(id)sender
{
    ConsumableCreateViewController *viewController = [[ConsumableCreateViewController alloc] initWithConsumables:self.consumables];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSConsumablesEditFinish])
    {
        [self.consumableTableView reloadData];
        if (self.consumables.count == 0)
        {
            self.isNoneView.hidden = NO;
            self.consumableTableView.hidden = YES;
        }
        else
        {
            self.isNoneView.hidden = YES;
            self.consumableTableView.hidden = NO;
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.consumables.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kConsumableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSCommonCellIdentifier";
    BSCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.valueLabel.hidden = YES;
    }
    
    BSConsumable *consumable = [self.consumables objectAtIndex:indexPath.row];
    cell.titleLabel.text = consumable.productName;
    cell.detailLabel.text = [NSString stringWithFormat:LS(@"ConsumableDetailTitle"), consumable.amount, consumable.uomName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ConsumableCreateViewController *viewController = [[ConsumableCreateViewController alloc] initWithConsumables:self.consumables editIndex:indexPath.row];
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
        [self.consumables removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        if (self.consumables.count == 0)
        {
            self.isNoneView.hidden = NO;
            self.consumableTableView.hidden = YES;
        }
    }
}


@end
