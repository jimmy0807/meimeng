//
//  PadCardProductViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-4-7.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadCardProductViewController.h"
#import "PadProjectConstant.h"
#import "PadCardProductCell.h"
#import "PadCardProjectLimitDateContainerViewController.h"

typedef enum kPadCardProductViewType
{
    kPadCardProductWithMemberCard,
    kPadCardProductWithCouponCard
}kPadCardProductViewType;

@interface PadCardProductViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) kPadCardProductViewType viewType;
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) CDCouponCard *couponCard;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) UITableView *productTableView;
@property (nonatomic, strong) PadCardProjectLimitDateContainerViewController *limitDateVC;

@end

@implementation PadCardProductViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard
{
    self = [super initWithNibName:@"PadCardProductViewController" bundle:nil];
    if (self)
    {
        self.viewType = kPadCardProductWithMemberCard;
        self.memberCard = memberCard;
        self.couponCard = nil;
    }
    
    [self initMemberAndCouponCardProduct];
    
    return self;
}

- (id)initWithCouponCard:(CDCouponCard *)couponCard
{
    self = [super initWithNibName:@"PadCardProductViewController" bundle:nil];
    if (self)
    {
        self.viewType = kPadCardProductWithCouponCard;
        self.memberCard = nil;
        self.couponCard = couponCard;
    }
    
    [self initMemberAndCouponCardProduct];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self registerNofitificationForMainThread:kBSFetchMemberCardProjectResponse];
    [self registerNofitificationForMainThread:kBSFetchCouponCardProductResponse];
    
    self.productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, self.view.frame.size.height - kPadNaviHeight) style:UITableViewStylePlain];
    self.productTableView.backgroundColor = [UIColor clearColor];
    self.productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.productTableView.delegate = self;
    self.productTableView.dataSource = self;
    self.productTableView.showsVerticalScrollIndicator = NO;
    self.productTableView.showsHorizontalScrollIndicator = NO;
    self.productTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.productTableView];
    
    UIImageView *naviImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, kPadNaviHeight + 3.0)];
    naviImageView.backgroundColor = [UIColor clearColor];
    naviImageView.image = [UIImage imageNamed:@"pad_navi_background"];
    naviImageView.userInteractionEnabled = YES;
    [self.view addSubview:naviImageView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(0.0, 0.0, 2 * 66.0, kPadNaviHeight);
    UIImage *backImage = [UIImage imageNamed:@"pad_navi_back_n"];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(66.0 - kPadNaviHeight + 20.0, 0.0, kPadNaviHeight, kPadNaviHeight)];
    backImageView.backgroundColor = [UIColor clearColor];
    backImageView.image = backImage;
    [backButton addSubview:backImageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0, 0.0, 66.0, kPadNaviHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = COLOR(148.0, 172.0, 172.0, 1.0);
    titleLabel.text = LS(@"BornCategory2");
    [backButton addSubview:titleLabel];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [naviImageView addSubview:backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)didBackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Requried Methods

- (void)refreshWithMemberCard:(CDMemberCard *)memberCard
{
    if (self.viewType == kPadCardProductWithMemberCard && self.memberCard.cardID.integerValue != memberCard.cardID.integerValue)
    {
        if (memberCard.cardID.integerValue == 0)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        self.memberCard = memberCard;
        [self initMemberAndCouponCardProduct];
    }
}

- (void)refreshWithCouponCard:(CDCouponCard *)couponCard
{
    if (self.viewType == kPadCardProductWithCouponCard && self.memberCard.cardID.integerValue != couponCard.cardID.integerValue)
    {
        if (couponCard.cardID.integerValue == 0)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        self.couponCard = couponCard;
        [self initMemberAndCouponCardProduct];
    }
}

- (void)initMemberAndCouponCardProduct
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (CDMemberCardProject *product in self.memberCard.products)
    {
        if (product.isDeposit.boolValue && product.projectCount.boolValue > 0)
        {
            [mutableArray addObject:product];
        }
    }
    
    for (CDMemberCardProject *project in self.memberCard.projects)
    {
        if (project.projectCount.integerValue > 0)
        {
            [mutableArray addObject:project];
        }
    }
    
    for (CDCouponCardProduct *project in self.couponCard.products)
    {
        if (project.remainQty.integerValue > 0)
        {
            [mutableArray addObject:project];
        }
    }
    
    self.products = [NSArray arrayWithArray:mutableArray];
    [self.productTableView reloadData];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberCardProjectResponse] ||
        [notification.name isEqualToString:kBSFetchCouponCardProductResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self initMemberAndCouponCardProduct];
            [self.productTableView reloadData];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadCardProductCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PadCardProductCellIdentifier";
    PadCardProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PadCardProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSObject *object = [self.products objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[CDMemberCardProject class]])
    {
        CDMemberCardProject *project = (CDMemberCardProject *)object;
        cell.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",project.projectName,project.create_date];
        cell.amountLabel.text = [NSString stringWithFormat:@"x%d", project.remainQty.integerValue];
        CGFloat price = project.projectPriceUnit.doubleValue * project.remainQty.integerValue;
        if ( ceil(price) - price > 0 && ceil(price) - price < 0.1 )
        {
            price = ceil(price);
        }
        cell.priceLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), price];
    }
    else if ([object isKindOfClass:[CDCouponCardProduct class]])
    {
        CDCouponCardProduct *product = (CDCouponCardProduct *)object;
        cell.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",product.productName,product.lastUpdate];
        cell.amountLabel.text = [NSString stringWithFormat:@"x%d", product.remainQty.integerValue];
        cell.priceLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), product.unitPrice.floatValue];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *object = [self.products objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[CDMemberCardProject class]])
    {
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"PadCardProjectBoard" bundle:nil];
        self.limitDateVC = [tableViewStoryboard instantiateInitialViewController];
        self.limitDateVC.project = (CDMemberCardProject*)object;
        [[UIApplication sharedApplication].keyWindow addSubview:self.limitDateVC.view];
        [self.limitDateVC show];
    }
}

@end
