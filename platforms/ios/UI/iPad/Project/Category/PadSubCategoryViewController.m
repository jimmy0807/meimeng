//
//  PadSubCategoryViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/10/12.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadSubCategoryViewController.h"
#import "PadProjectConstant.h"
#import "PadProjectTypeCell.h"

@interface PadSubCategoryViewController ()

@end

@interface PadSubCategoryViewController ()

@property (nonatomic, strong) CDProjectCategory *category;
@property (nonatomic, strong) NSArray *subCategories;
@property (nonatomic, strong) UITableView *subCategoryTableView;

@end

@implementation PadSubCategoryViewController

- (id)initWithCategory:(CDProjectCategory *)category
{
    self = [super init];
    if (self)
    {
        self.category = category;
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (CDProjectCategory *subCategory in self.category.subCategory)
        {
            //if (subCategory.itemCount.integerValue != 0)
            {
                [mutableArray addObject:subCategory];
            }
        }
        self.subCategories = [NSArray arrayWithArray:mutableArray];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES];
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
        
        NSArray *sortArray = @[sortDescriptor1,sortDescriptor];
        self.subCategories = [self.subCategories sortedArrayUsingDescriptors:sortArray];
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
    
    UIView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadProjectCategoryCellHeight - 1.0, kPadProjectCategoryCellWidth, 1.0)];
    lineView.backgroundColor = COLOR(221.0, 221.0, 221.0, 1.0);
    [self.view addSubview:lineView];
    
    UIImage *backImage = [UIImage imageNamed:@"pad_back_button"];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0, (kPadProjectCategoryCellHeight - backImage.size.height)/2.0, backImage.size.width, backImage.size.height)];
    backImageView.image = backImage;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(0.0, 0.0, 160.0, kPadProjectCategoryCellHeight);
    [backButton addSubview:backImageView];
    backButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 32.0, 0.0, 0.0)];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitle:[NSString stringWithFormat:LS(@"GoBackTo"), self.category.categoryName] forState:UIControlStateNormal];
    [backButton setTitleColor:COLOR(169.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    self.subCategoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadProjectCategoryCellHeight, self.view.frame.size.width, self.view.frame.size.height - kPadProjectCategoryCellHeight) style:UITableViewStylePlain];
    self.subCategoryTableView.backgroundColor = [UIColor clearColor];
    self.subCategoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.subCategoryTableView.dataSource = self;
    self.subCategoryTableView.delegate = self;
    self.subCategoryTableView.showsVerticalScrollIndicator = NO;
    self.subCategoryTableView.showsHorizontalScrollIndicator = NO;
    self.subCategoryTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.subCategoryTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Requried Methods

- (void)didBackButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadSubCategoryBack:)])
    {
        [self.delegate didPadSubCategoryBack:self.category];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.subCategories.count + 1 + (self.category.otherCount.integerValue > 0 ? 1 : 0);
    return self.subCategories.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadProjectCategoryCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PadCategoryCellIdentifier";
    PadProjectTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PadProjectTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.arrowImageView.hidden = YES;
    if (indexPath.row == 0)
    {
        cell.titleLabel.text = [NSString stringWithFormat:LS(@"PadTotalBornCategoryType"), self.category.categoryName];
    }
    else if (indexPath.row == self.subCategories.count + 1 )
    {
        //cell.titleLabel.text = [NSString stringWithFormat:@"其他(%@)", self.category.otherCount];
        cell.titleLabel.text = [NSString stringWithFormat:@"其他"];
    }
    else
    {
        CDProjectCategory *category = [self.subCategories objectAtIndex:indexPath.row - 1];
        //cell.titleLabel.text = [NSString stringWithFormat:@"%@(%d)", category.categoryName, category.itemCount.integerValue];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", category.categoryName];
        if ( category.subCategory.count > 0 )
        {
            cell.arrowImageView.hidden = NO;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadSubCategorySubTotalSelect:)])
        {
            [self.delegate didPadSubCategorySubTotalSelect:self.category];
        }
    }
    else if ( indexPath.row == self.subCategories.count + 1 )
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadSubCategorySubOtherSelect:)])
        {
            [self.delegate didPadSubCategorySubOtherSelect:self.category];
        }
    }
    else
    {
        CDProjectCategory *category = [self.subCategories objectAtIndex:indexPath.row - 1];
        
        if (category.subCategory.count != 0)
        {
            PadSubCategoryViewController *viewController = [[PadSubCategoryViewController alloc] initWithCategory:category];
            viewController.delegate = (id<PadSubCategoryViewControllerDelegate>)self.delegate;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadSubCategoryCellSelect:)])
        {
            [self.delegate didPadSubCategoryCellSelect:category];
        }
    }
}

@end
