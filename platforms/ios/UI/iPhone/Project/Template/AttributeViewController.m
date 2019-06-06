//
//  AttributeViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "AttributeViewController.h"
#import "CBIsNoneView.h"
#import "BSSelectCell.h"
#import "CBLoadingView.h"
#import "AttributeCreateViewController.h"

#define kAttributeCellHeight    50.0

@interface AttributeViewController ()


@property (nonatomic, strong) NSArray *attributeIds;
@property (nonatomic, strong) NSArray *attributeArray;

@property (nonatomic, strong) CBIsNoneView *isNoneView;
@property (nonatomic, strong) UITableView *attributeTableView;

@end

@implementation AttributeViewController

- (id)initWithAttributeIDs:(NSArray *)attributeIds
{
    self = [super initWithNibName:NIBCT(@"AttributeViewController") bundle:nil];
    if (self != nil)
    {
        self.attributeIds = attributeIds;
        self.title = LS(@"Attribute");
        
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchAllProjectAttribute]];
        for (int i = 0; i < self.attributeIds.count; i++)
        {
            NSNumber *attributeId = [self.attributeIds objectAtIndex:i];
            CDProjectAttribute *attribute = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttribute" withValue:attributeId forKey:@"attributeID"];
            [mutableArray removeObject:attribute];
        }
        
        self.attributeArray = mutableArray;
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
    
    [self registerNofitificationForMainThread:kBSAttributeCreateResponse];
    
    self.isNoneView = [[CBIsNoneView alloc] initWithImage:[UIImage imageNamed:@"template_is_null"] message:nil buttonTitle:nil];
    self.isNoneView.hidden = YES;
    [self.isNoneView showNoneViewInView:self.view];
    
    self.attributeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.attributeTableView.backgroundColor = [UIColor clearColor];
    self.attributeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.attributeTableView.delegate = self;
    self.attributeTableView.dataSource = self;
    self.attributeTableView.showsVerticalScrollIndicator = NO;
    self.attributeTableView.showsHorizontalScrollIndicator = NO;
    self.attributeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.attributeTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.attributeTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.attributeTableView.tableFooterView = footerView;
    
    if (self.attributeArray.count == 0)
    {
        self.isNoneView.hidden = NO;
        self.attributeTableView.hidden = YES;
    }
    else
    {
        self.isNoneView.hidden = YES;
        self.attributeTableView.hidden = NO;
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
    AttributeCreateViewController *viewController = [[AttributeCreateViewController alloc] initWithAttribute:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSAttributeCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            CDProjectAttribute *attribute = (CDProjectAttribute *)[notification.userInfo objectForKey:@"object"];
            if (attribute)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSAttributeEditFinish object:attribute userInfo:nil];
                UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
                [self.navigationController popToViewController:viewController animated:YES];
            }
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attributeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kAttributeCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSSelectCellIdentifier";
    BSSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CDProjectAttribute *attribute = [self.attributeArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = attribute.attributeName;
    cell.selectImageView.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CDProjectAttribute *attribute = [self.attributeArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSAttributeEditFinish object:attribute userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
