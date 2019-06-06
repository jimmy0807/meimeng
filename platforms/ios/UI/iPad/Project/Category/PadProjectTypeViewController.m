//
//  PadProjectTypeViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/10/12.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectTypeViewController.h"
#import "PadProjectConstant.h"
#import "PadProjectTypeCell.h"
#import "PadProjectCustomMadeCell.h"
#import "PadProjectViewController.h"
#import "PadCategoryViewController.h"

@interface PadProjectTypeViewController ()

@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) UITableView *typeTableView;

@end

@implementation PadProjectTypeViewController

- (id)initWithTypes:(NSArray *)types
{
    self = [super init];
    if (self)
    {
        self.types = types;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(245.0, 248.0, 248.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, kPadProjectCategoryCellWidth, kPadProjectTypeViewHeight);
    if (IS_SDK7)
    {
        self.preferredContentSize = self.view.frame.size;
    }
    else
    {
        self.contentSizeForViewInPopover = self.view.frame.size;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadProjectCategoryCellWidth, kPadProjectCategoryCellHeight)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = LS(@"PadSelectType");
    [self.view addSubview:titleLabel];
    
    UIView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadProjectCategoryCellHeight - 1.0, kPadProjectTypeViewHeight, 1.0)];
    lineView.backgroundColor = COLOR(221.0, 221.0, 221.0, 1.0);
    [self.view addSubview:lineView];
    
    self.typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadProjectCategoryCellHeight, kPadProjectCategoryCellWidth, self.view.frame.size.height - kPadProjectCategoryCellHeight) style:UITableViewStylePlain];
    self.typeTableView.backgroundColor = [UIColor clearColor];
    self.typeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.typeTableView.dataSource = self;
    self.typeTableView.delegate = self;
    self.typeTableView.showsVerticalScrollIndicator = NO;
    self.typeTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.typeTableView];
    [self.typeTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Requried Methods
- (void)refreshWithTypes:(NSArray *)types
{
    self.types = types;
    [self.typeTableView reloadData];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.types.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadProjectCategoryCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.types.count)
    {
        static NSString *CellIdentifier = @"PadTypeCellIdentifier";
        PadProjectTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadProjectTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CDBornCategory *bornCategory = [self.types objectAtIndex:indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@(%d)", bornCategory.bornCategoryName, bornCategory.totalCount.integerValue];
        cell.arrowImageView.hidden = NO;
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"PadProjectCustomMadeCellIdentifier";
        PadProjectCustomMadeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadProjectCustomMadeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.titleLabel.text = LS(@"PadBornCategoryCustomPrice");
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.types.count)
    {
        CDBornCategory *bornCategory = [self.types objectAtIndex:indexPath.row];
        for (CDBornCategory *category in self.types) {
            NSLog(@"%@",category.bornCategoryName);
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectViewSelectWithBornCategory:hidden:)])
        {
            [self.delegate didProjectViewSelectWithBornCategory:bornCategory hidden:NO];
        }
        
        BOOL isExist = NO;
        NSArray *categories = [[BSCoreDataManager currentManager] fetchTopProjectCategory];
        for (NSInteger i = 0; i < categories.count; i++)
        {
            CDProjectCategory *category = [categories objectAtIndex:i];
            if (category.itemCount.integerValue != 0)
            {
                isExist = YES;
                break;
            }
        }
        
        if (isExist)
        {
            PadCategoryViewController *viewController = [[PadCategoryViewController alloc] initWithBornCategory:bornCategory];
            viewController.delegate = (id<PadCategoryViewControllerDelegate>)self.delegate;
            if ( tableView == nil )
            {
                [self.navigationController pushViewController:viewController animated:NO];
            }
            else
            {
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectViewSelectCustomPrice)])
        {
            [self.delegate didProjectViewSelectCustomPrice];
        }
    }
}

@end
