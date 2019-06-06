//
//  AttributeLineViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "AttributeLineViewController.h"
#import "UIImage+Resizable.h"
#import "BSAttributeLine.h"
#import "BSAttributeValue.h"
#import "CBIsNoneView.h"
#import "BSCommonCell.h"
#import "AttributeViewController.h"
#import "AttributeValueViewController.h"

#define kAttributeLineCellHeight     50.0

typedef enum kAttributeLineRow
{
    kAttributeLineAttribute,
    kAttributeLineAttributeValue
}kAttributeLineRow;

@interface AttributeLineViewController ()

@property (nonatomic, strong) CDProjectTemplate *projectTemplate;
@property (nonatomic, strong) NSMutableArray *attributeLines;

@property (nonatomic, strong) CBIsNoneView *isNoneView;
@property (nonatomic, strong) UITableView *templateTableView;

@end


@implementation AttributeLineViewController

- (id)initWithProjectTemplate:(CDProjectTemplate *)projectTemplate attributeLines:(NSMutableArray *)attributeLines
{
    self = [super initWithNibName:NIBCT(@"AttributeLineViewController") bundle:nil];
    if (self)
    {
        self.projectTemplate = projectTemplate;
        self.attributeLines = attributeLines;
        self.title = LS(@"ProjectDetailTemplateTitle");
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
    
    self.isNoneView = [[CBIsNoneView alloc] initWithImage:[UIImage imageNamed:@"template_is_null"] message:nil buttonTitle:nil];
    self.isNoneView.hidden = YES;
    [self.isNoneView showNoneViewInView:self.view];
    
    [self registerNofitificationForMainThread:kBSAttributeEditFinish];
    [self registerNofitificationForMainThread:kBSAttributeValueEditFinish];
    
    self.templateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.templateTableView.backgroundColor = [UIColor clearColor];
    self.templateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.templateTableView.delegate = self;
    self.templateTableView.dataSource = self;
    self.templateTableView.showsVerticalScrollIndicator = NO;
    self.templateTableView.showsHorizontalScrollIndicator = NO;
    self.templateTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.templateTableView];
    
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 19.5, IC_SCREEN_WIDTH, 0.5)];
    lineImageView.backgroundColor = [UIColor clearColor];
    lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
    [headerView addSubview:lineImageView];
    self.templateTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.templateTableView.tableFooterView = footerView;
    if (self.attributeLines.count == 0)
    {
        self.isNoneView.hidden = NO;
        self.templateTableView.hidden = YES;
    }
    else
    {
        self.isNoneView.hidden = YES;
        self.templateTableView.hidden = NO;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSAttributeLinesEditFinish object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didBackBarButtonItemClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSAttributeLinesEditFinish object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRightBarButtonItemClick:(id)sender
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < self.attributeLines.count; i++)
    {
        BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:i];
        [mutableArray addObject:attributeLine.attributeID];
    }
    AttributeViewController *viewController = [[AttributeViewController alloc] initWithAttributeIDs:mutableArray];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSAttributeEditFinish])
    {
        CDProjectAttribute *attribute = (CDProjectAttribute *)notification.object;
        if (attribute != nil)
        {
            BSAttributeLine *bsAttributeLine = [[BSAttributeLine alloc] init];
            bsAttributeLine.attributeID = attribute.attributeID;
            bsAttributeLine.attributeName = attribute.attributeName;
            bsAttributeLine.attributeValues = [NSMutableArray array];
            [self.attributeLines addObject:bsAttributeLine];
            [self.templateTableView reloadData];
            if (self.attributeLines.count == 0)
            {
                self.isNoneView.hidden = NO;
                self.templateTableView.hidden = YES;
            }
            else
            {
                self.isNoneView.hidden = YES;
                self.templateTableView.hidden = NO;
            }
        }
    }
    else if ([notification.name isEqualToString:kBSAttributeValueEditFinish])
    {
        [self.templateTableView reloadData];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.attributeLines.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:section];
    return attributeLine.attributeValues.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kAttributeLineCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kAttributeLineAttribute)
    {
        static NSString *CellIdentifier = @"BSAttributeCellIdentifier";
        AttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[AttributeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        
        cell.indexPath = indexPath;
        BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:indexPath.section];
        cell.titleLabel.text = [NSString stringWithFormat:LS(@"AttributeTitle"), attributeLine.attributeName];
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"BSAttributeValueCellIdentifier";
        AttributeValueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[AttributeValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        
        cell.indexPath = indexPath;
        
        BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:indexPath.section];
        BSAttributeValue *attributeValue = [attributeLine.attributeValues objectAtIndex:indexPath.row - 1];
        [cell setTitleLabelText:attributeValue.attributeValueName];
        cell.contentField.text = [NSString stringWithFormat:@"%.2f", attributeValue.attributeValueExtraPrice];
        
        return cell;
    }
    
    return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != kAttributeLineAttribute)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BSAttributeLine *bsAttributeLine = [self.attributeLines objectAtIndex:indexPath.section];
        [bsAttributeLine.attributeValues removeObjectAtIndex:indexPath.row - 1];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark -
#pragma mark AttributeCellDelegate Methods

- (void)didDeleteAttributeLine:(AttributeCell *)cell
{
    [self.attributeLines removeObjectAtIndex:cell.indexPath.section];
    [self.templateTableView reloadData];
}

- (void)didAddAttributeValue:(AttributeCell *)cell
{
    BSAttributeLine *bsAttributeLine = [self.attributeLines objectAtIndex:cell.indexPath.section];
    AttributeValueViewController *viewController = [[AttributeValueViewController alloc] initWithBSAttributeLine:bsAttributeLine];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark AttributeValueCellDelegate Methods

- (void)didContentFieldEndEdit:(AttributeValueCell *)cell
{
    BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:cell.indexPath.section];
    BSAttributeValue *attributeValue = [attributeLine.attributeValues objectAtIndex:cell.indexPath.row - 1];
    
    attributeValue. attributeValueExtraPrice = cell.contentField.text.floatValue;
    cell.contentField.text = [NSString stringWithFormat:@"%.2f", attributeValue. attributeValueExtraPrice];
}


@end
