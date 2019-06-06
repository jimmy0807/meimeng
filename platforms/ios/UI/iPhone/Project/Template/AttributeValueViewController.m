//
//  AttributeValueViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "AttributeValueViewController.h"
#import "CBIsNoneView.h"
#import "BSSelectCell.h"
#import "BSAttributeValue.h"
#import "AttributeValueCreateViewController.h"

#define kAttributeCellHeight    50.0

@interface AttributeValueViewController ()

@property (nonatomic, strong) BSAttributeLine *bsAttributeLine;
@property (nonatomic, strong) CDProjectAttribute *attribute;

@property (nonatomic, strong) NSArray *attributeValues;
@property (nonatomic, strong) CBIsNoneView *isNoneView;
@property (nonatomic, strong) UITableView *attributeTableView;

@end

@implementation AttributeValueViewController

- (id)initWithBSAttributeLine:(BSAttributeLine *)bsAttributeLine
{
    self = [super initWithNibName:NIBCT(@"AttributeValueViewController") bundle:nil];
    if (self != nil)
    {
        self.title = LS(@"AttributeValue");
        self.bsAttributeLine = bsAttributeLine;
        
        NSNumber *attributeId = self.bsAttributeLine.attributeID;
        self.attribute = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttribute" withValue:attributeId forKey:@"attributeID"];
        NSMutableArray *values = [NSMutableArray arrayWithArray:self.attribute.attributeValues.array];
        for (int i = 0; i < self.bsAttributeLine.attributeValues.count; i++)
        {
            BSAttributeValue *attributeValue = [self.bsAttributeLine.attributeValues objectAtIndex:i];
            CDProjectAttributeValue *value = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttributeValue" withValue:attributeValue.attributeValueID forKey:@"attributeValueID"];
            [values removeObject:value];
        }
        
        self.attributeValues = values;
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
    
    [self registerNofitificationForMainThread:kBSAttributeValueCreateResponse];
    
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
    
    if (self.attributeValues.count == 0)
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
    AttributeValueCreateViewController *viewController = [[AttributeValueCreateViewController alloc] initWithAttribute:self.attribute attributeValue:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didAttributeValueSelected:(CDProjectAttributeValue *)attributeValue
{
    BSAttributeValue *bsAttributeValue = [[BSAttributeValue alloc] init];
    bsAttributeValue.attributeValueID = attributeValue.attributeValueID;
    bsAttributeValue.attributeValueName = attributeValue.attributeValueName;
    [self.bsAttributeLine.attributeValues addObject:bsAttributeValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSAttributeValueEditFinish object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSAttributeValueCreateResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            CDProjectAttributeValue *attributeValue = (CDProjectAttributeValue *)[notification.userInfo objectForKey:@"object"];
            if (attributeValue != nil)
            {
                BSAttributeValue *bsAttributeValue = [[BSAttributeValue alloc] init];
                bsAttributeValue.attributeValueID = attributeValue.attributeValueID;
                bsAttributeValue.attributeValueName = attributeValue.attributeValueName;
                [self.bsAttributeLine.attributeValues addObject:bsAttributeValue];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSAttributeValueEditFinish object:nil userInfo:nil];
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
    return self.attributeValues.count;
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
    
    CDProjectAttributeValue *value = [self.attributeValues objectAtIndex:indexPath.row];
    cell.titleLabel.text = value.attributeValueName;
    cell.selectImageView.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CDProjectAttributeValue *attributeValue = [self.attributeValues objectAtIndex:indexPath.row];
    BSAttributeValue *bsAttributeValue = [[BSAttributeValue alloc] init];
    bsAttributeValue.attributeValueID = attributeValue.attributeValueID;
    bsAttributeValue.attributeValueName = attributeValue.attributeValueName;
    [self.bsAttributeLine.attributeValues addObject:bsAttributeValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSAttributeValueEditFinish object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
