//
//  HPatientMubanCategoryViewController.m
//  meim
//
//  Created by 波恩公司 on 2018/4/9.
//

#import "HPatientMubanCategoryViewController.h"
#import "PadProjectConstant.h"
#import "PadProjectTypeCell.h"
#import "PadSubCategoryViewController.h"

@interface HPatientMubanCategoryViewController ()

@property (nonatomic, strong) CDBornCategory *bornCategory;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) UITableView *categoryTableView;

@end

@implementation HPatientMubanCategoryViewController

- (id)initWithBornCategory:(CDBornCategory *)bornCategory
{
    self = [super init];
    if (self)
    {
        self.bornCategory = bornCategory;
        self.categories = [[BSCoreDataManager currentManager] fetchTopProjectCategory];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(245.0, 248.0, 248.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, kPadProjectCategoryCellWidth, 320);
    if (IS_SDK7)
    {
        self.preferredContentSize = self.view.frame.size;
    }
    else
    {
        self.contentSizeForViewInPopover = self.view.frame.size;
    }
    
    UIView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPadProjectCategoryCellHeight - 0.5, kPadProjectCategoryCellWidth, 0.5)];
    lineView.backgroundColor = COLOR(221.0, 221.0, 221.0, 1.0);
    [self.view addSubview:lineView];
    
    UIImage *backImage = [UIImage imageNamed:@"pad_back_button"];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0, (kPadProjectCategoryCellHeight - backImage.size.height)/2.0, backImage.size.width, backImage.size.height)];
    backImageView.image = backImage;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(0.0, 0.0, 160.0, kPadProjectCategoryCellHeight);
    [backButton addSubview:backImageView];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 32.0, 0.0, 0.0)];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [backButton setTitleColor:COLOR(169.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadProjectCategoryCellWidth, kPadProjectCategoryCellHeight)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = @"选择模板";
    [self.view addSubview:titleLabel];
    
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadProjectCategoryCellHeight, kPadProjectCategoryCellWidth, self.view.frame.size.height - kPadProjectCategoryCellHeight) style:UITableViewStylePlain];
    self.categoryTableView.backgroundColor = [UIColor clearColor];
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.categoryTableView.dataSource = self;
    self.categoryTableView.delegate = self;
    self.categoryTableView.showsVerticalScrollIndicator = NO;
    self.categoryTableView.showsHorizontalScrollIndicator = NO;
    self.categoryTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.categoryTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Requried Methods

- (void)didBackButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadCategoryBack)])
    {
        [self.delegate didPadCategoryBack];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.categories.count + 1 + ([self.bornCategory.otherCount integerValue] > 0 ? 1 : 0);
    return self.categories.count + 1;
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
    
    cell.arrowImageView.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (indexPath.row == 0)
    {
        cell.arrowImageView.hidden = YES;
        //cell.titleLabel.text = [NSString stringWithFormat:LS(@"PadTotalBornCategoryType"), self.bornCategory.bornCategoryName];
        cell.titleLabel.text = @"全部";
    }
    else if ( indexPath.row == self.categories.count + 1 )
    {
        cell.arrowImageView.hidden = YES;
        //cell.titleLabel.text = [NSString stringWithFormat:@"其他(%@)", self.bornCategory.otherCount];
        cell.titleLabel.text = [NSString stringWithFormat:@"其他"];
    }
    else
    {
        CDProjectCategory *category = [self.categories objectAtIndex:indexPath.row - 1];
        //cell.titleLabel.text = [NSString stringWithFormat:@"%@(%d)", category.categoryName, category.itemCount.integerValue];
        cell.titleLabel.text = category.categoryName;
        if (category.subCategory.count == 0)
        {
            cell.arrowImageView.hidden = YES;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadCategorySubTotalSelect)])
        {
            [self.delegate didPadCategorySubTotalSelect];
        }
    }
    else if ( indexPath.row == self.categories.count + 1 )
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadCategorySubOtherSelect)])
        {
            [self.delegate didPadCategorySubOtherSelect];
        }
    }
    else
    {
        CDProjectCategory *category = [self.categories objectAtIndex:indexPath.row - 1];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadCategoryCellSelect:)])
        {
            [self.delegate didPadCategoryCellSelect:category];
        }
        
        if (category.subCategory.count != 0)
        {
            PadSubCategoryViewController *viewController = [[PadSubCategoryViewController alloc] initWithCategory:category];
            viewController.delegate = (id<PadSubCategoryViewControllerDelegate>)self.delegate;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

@end

