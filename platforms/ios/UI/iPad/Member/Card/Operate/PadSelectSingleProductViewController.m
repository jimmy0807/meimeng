//
//  PadSelectSingleProductViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-16.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadSelectSingleProductViewController.h"
#import "PadProjectConstant.h"
#import "PadProjectCell.h"

@interface PadSelectSingleProductViewController ()

@property (nonatomic, strong) NSArray *productArray;

@property (nonatomic, strong) UITableView *productTableView;

@end

@implementation PadSelectSingleProductViewController

- (id)initWithDelegate:(id)delegate
{
    self = [super initWithNibName:@"PadSelectSingleProductViewController" bundle:nil];
    if (self)
    {
        self.delegate = delegate;
        self.productArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:@[@(kPadBornCategoryProduct), @(kPadBornCategoryProject)] categoryIds:nil existItemIds:nil keyword:nil priceAscending:YES];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);;
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSMemberCardRedeemResponse];
    
    
    self.productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, self.view.frame.size.height - kPadNaviHeight) style:UITableViewStylePlain];
    self.productTableView.backgroundColor = [UIColor clearColor];
    self.productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.productTableView.dataSource = self;
    self.productTableView.delegate = self;
    self.productTableView.showsVerticalScrollIndicator = NO;
    self.productTableView.showsHorizontalScrollIndicator = NO;
    self.productTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.productTableView];
    
    UIImage *naviImage = [UIImage imageNamed:@"pad_navi_background"];
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, naviImage.size.height)];
    navi.backgroundColor = [UIColor clearColor];
    navi.image = naviImage;
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_back_n"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_back_h"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, (kPadNaviHeight - 24.0)/2.0, self.view.frame.size.width - 2 * kPadNaviHeight, 24.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = LS(@"PadCardOperateSelectProduct");
    [navi addSubview:titleLabel];
}

- (void)didBackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadCustomItemCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PadProjectCellIdentifier";
    PadProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PadProjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CDProjectItem *item = [self.productArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.itemName;
    cell.priceLabel.text = @"";
    
    return cell;
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadSelectSingleProduct:)])
    {
        CDProjectItem *product = [self.productArray objectAtIndex:indexPath.row];
        [self.delegate didPadSelectSingleProduct:product];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
