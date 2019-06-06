//
//  CardItemViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/8/20.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "CardItemViewController.h"
#import "BSCardItem.h"
#import "BSCommonCell.h"
#import "CBIsNoneView.h"
#import "CardItemCreateViewController.h"

#define kCardItemCellHeight     60.0

@interface CardItemViewController ()

@property (nonatomic, strong) NSMutableArray *cardItems;

@property (nonatomic, strong) CBIsNoneView *isNoneView;
@property (nonatomic, strong) UITableView *cardItemTableView;

@end

@implementation CardItemViewController

- (id)initWithCardItems:(NSMutableArray *)cardItems
{
    self = [super initWithNibName:NIBCT(@"CardItemViewController") bundle:nil];
    if (self)
    {
        self.cardItems = cardItems;
        self.title = LS(@"CardItem");
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
    
    [self registerNofitificationForMainThread:kBSCardItemCreateResult];
    
    self.isNoneView = [[CBIsNoneView alloc] initWithImage:[UIImage imageNamed:@"sub_items_is_none"] message:nil buttonTitle:nil];
    self.isNoneView.hidden = YES;
    [self.isNoneView showNoneViewInView:self.view];
    
    self.cardItemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.cardItemTableView.backgroundColor = [UIColor clearColor];
    self.cardItemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cardItemTableView.delegate = self;
    self.cardItemTableView.dataSource = self;
    self.cardItemTableView.showsVerticalScrollIndicator = NO;
    self.cardItemTableView.showsHorizontalScrollIndicator = NO;
    self.cardItemTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.cardItemTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.cardItemTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.cardItemTableView.tableFooterView = footerView;
    if (self.cardItems.count == 0)
    {
        self.isNoneView.hidden = NO;
        self.cardItemTableView.hidden = YES;
    }
    else
    {
        self.isNoneView.hidden = YES;
        self.cardItemTableView.hidden = NO;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSCardItemEditFinish object:self.cardItems userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRightBarButtonItemClick:(id)sender
{
    CardItemCreateViewController *viewController = [[CardItemCreateViewController alloc] initWithCardItems:self.cardItems editIndex:-1];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSCardItemCreateResult])
    {
        self.cardItems = (NSMutableArray *)notification.object;
        [self.cardItemTableView reloadData];
        if (self.cardItems.count == 0)
        {
            self.isNoneView.hidden = NO;
            self.cardItemTableView.hidden = YES;
        }
        else
        {
            self.isNoneView.hidden = YES;
            self.cardItemTableView.hidden = NO;
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cardItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCardItemCellHeight;
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
    
    BSCardItem *cardItem = [self.cardItems objectAtIndex:indexPath.row];
    cell.titleLabel.text = cardItem.productName;
    cell.detailLabel.text = [NSString stringWithFormat:LS(@"CardItemDetailTitle"), cardItem.importQty];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CardItemCreateViewController *viewController = [[CardItemCreateViewController alloc] initWithCardItems:self.cardItems editIndex:indexPath.row];
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
        [self.cardItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        if (self.cardItems.count == 0)
        {
            self.isNoneView.hidden = NO;
            self.cardItemTableView.hidden = YES;
        }
    }
}

@end
