//
//  PadRepaymentViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-4-19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadRepaymentViewController.h"
#import "PadProjectConstant.h"
#import "CBLoadingView.h"
#import "PadArrearsCell.h"
#import "PadConsumeItemCell.h"
#import "BSFetchPosProductRequest.h"
#import "BSFetchMemberCardArrearsRequest.h"
#import "PadCardOperateViewController.h"

@interface PadRepaymentViewController () <UITableViewDelegate, UITableViewDataSource, PadArrearsCellDelegate>

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) NSArray *unRepaymentArrears;
@property (nonatomic, strong) NSArray *productArray;

@property (nonatomic, strong) UITableView *arrearsTableView;
@property (nonatomic, strong) UITableView *productTableView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableSet *arrears;

@end

@implementation PadRepaymentViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard
{
    self = [super initWithNibName:@"PadRepaymentViewController" bundle:nil];
    if (self)
    {
        self.memberCard = memberCard;
        self.selectedIndex = -1;
        self.arrears = [NSMutableSet set];
        [self initUnRepaymentArrears];
        
        BSFetchMemberCardArrearsRequest *arrearsRequest = [[BSFetchMemberCardArrearsRequest alloc] initWithMemberCardID:self.memberCard.cardID];
        [arrearsRequest execute];
    }
    
    return self;
}

- (void)initUnRepaymentArrears
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (CDMemberCardArrears *arrears in self.memberCard.arrears)
    {
        if (arrears.unRepaymentAmount.floatValue != 0)
        {
            [mutableArray addObject:arrears];
        }
    }
    self.unRepaymentArrears = [NSArray arrayWithArray:mutableArray];
}

- (void)initProductArray
{
    self.productArray = [NSArray array];
    if (self.selectedIndex >= 0 && self.selectedIndex < self.unRepaymentArrears.count)
    {
        CDMemberCardArrears *arrears = [self.unRepaymentArrears objectAtIndex:self.selectedIndex];
        CDPosOperate *posOperate = [[BSCoreDataManager currentManager] findEntity:@"CDPosOperate" withValue:arrears.operateID forKey:@"operate_id"];
        self.productArray = posOperate.products.array;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSFetchMemberCardArrearsResponse];
    [self registerNofitificationForMainThread:kFetchPosOperateProductResponse];
    
    UIView *rightBackground = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth, 0.0, kPadProjectSideViewWidth, IC_SCREEN_HEIGHT)];
    rightBackground.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    [self.view addSubview:rightBackground];
    
    self.arrearsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width - kPadProjectSideViewWidth, self.view.frame.size.height - kPadNaviHeight) style:UITableViewStylePlain];
    self.arrearsTableView.backgroundColor = [UIColor clearColor];
    self.arrearsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.arrearsTableView.dataSource = self;
    self.arrearsTableView.delegate = self;
    self.arrearsTableView.showsVerticalScrollIndicator = NO;
    self.arrearsTableView.showsHorizontalScrollIndicator = NO;
    self.arrearsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.arrearsTableView];
    
    self.productTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth, kPadNaviHeight, kPadProjectSideViewWidth, self.view.frame.size.height - kPadNaviHeight) style:UITableViewStylePlain];
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
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_n"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_h"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, (kPadNaviHeight - 24.0)/2.0, self.view.frame.size.width - 2 * kPadNaviHeight, 24.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = LS(@"PadCardArrears");
    [navi addSubview:titleLabel];
    
    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadNaviHeight, 0.0, kPadNaviHeight, kPadNaviHeight)];
    self.confirmButton.backgroundColor = COLOR(90.0, 211.0, 213.0, 1.0);
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton setTitle:LS(@"PadCardRepayment") forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
}

- (void)refreshConfirmButton
{
    if (self.arrears.count == 0)
    {
        [self.confirmButton setTitleColor:COLOR(168.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    }
}

- (void)didBackButtonClick:(id)sender
{
    [self.maskView hidden];
}

- (void)didConfirmButtonClick:(id)sender
{
    if (self.arrears.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"PadMemberCardRepaymentRemind")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    PadCardOperateViewController *viewController = [[PadCardOperateViewController alloc] initWithMember:self.memberCard.member memberCard:self.memberCard arrears:self.arrears.allObjects];
    viewController.maskView = self.maskView;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberCardArrearsResponse])
    {
        if ([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [self initUnRepaymentArrears];
            [self initProductArray];
            [self.arrearsTableView reloadData];
            [self.productTableView reloadData];
        }
    }
    else if ([notification.name isEqualToString:kFetchPosOperateProductResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [self initProductArray];
            [self.productTableView reloadData];
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.arrearsTableView)
    {
        return self.unRepaymentArrears.count;
    }
    else if (tableView == self.productTableView)
    {
        return self.productArray.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.arrearsTableView)
    {
        return kPadArrearsCellHeight;
    }
    else if (tableView == self.productTableView)
    {
        return kPadConsumeItemCellHeight;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.arrearsTableView)
    {
        static NSString *CellIdentifier = @"PadArrearsCellIdentifier";
        PadArrearsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadArrearsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        
        cell.indexPath = indexPath;
        cell.highlighted = NO;
        if (self.selectedIndex == indexPath.row)
        {
            cell.highlighted = YES;
        }
        
        CDMemberCardArrears *arrears = [self.unRepaymentArrears objectAtIndex:indexPath.row];
        if ([self.arrears containsObject:arrears])
        {
            [cell isArrearsSelected:YES];
        }
        else
        {
            [cell isArrearsSelected:NO];
        }
        cell.titleLabel.text = LS(arrears.arrearsType);
        cell.priceLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), arrears.unRepaymentAmount.floatValue];
        cell.operateLabel.text = arrears.operateName;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *operateDate = [dateFormatter dateFromString:arrears.createDate];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
        cell.dateLabel.text = [dateFormatter stringFromDate:operateDate];
        
        return cell;
    }
    else if (tableView == self.productTableView)
    {
        static NSString *CellIdentifier = @"PadConsumeItemCellIdentifier";
        PadConsumeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadConsumeItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CDPosBaseProduct *product = [self.productArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = product.product_name;
        cell.amountLabel.text = [NSString stringWithFormat:LS(@"PadPosProductNum"), product.product_qty.integerValue];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.arrearsTableView)
    {
        if (self.selectedIndex != indexPath.row)
        {
            self.selectedIndex = indexPath.row;
            [self initProductArray];
            [self.productTableView reloadData];
        }
    }
}


#pragma mark -
#pragma mark PadArrearsCellDelegate Methods

- (void)didPadArrearsSelected:(PadArrearsCell *)cell
{
    CDMemberCardArrears *arrears = [self.unRepaymentArrears objectAtIndex:cell.indexPath.row];
    if (![self.arrears containsObject:arrears])
    {
        [cell isArrearsSelected:YES];
        [self.arrears addObject:arrears];
    }
    else
    {
        [cell isArrearsSelected:NO];
        [self.arrears removeObject:arrears];
    }
}

@end
