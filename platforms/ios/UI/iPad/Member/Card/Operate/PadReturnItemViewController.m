//
//  PadReturnItemViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadReturnItemViewController.h"
#import "PadProjectConstant.h"
#import "CBLoadingView.h"
#import "PadProjectCell.h"
#import "PadProjectSideCell.h"
#import "BSReturnItem.h"
#import "BSMemberCardOperateRequest.h"
#import "BSFetchMemberCardDetailRequest.h"

@interface PadReturnItemViewController ()

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSMutableArray *returnArray;
@property (nonatomic, assign) CGFloat totalAmount;

@property (nonatomic, strong) UITableView *itemTableView;
@property (nonatomic, strong) UITableView *returnTableView;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation PadReturnItemViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard
{
    self = [super initWithNibName:@"PadReturnItemViewController" bundle:nil];
    if (self)
    {
        self.memberCard = memberCard;
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (CDMemberCardProject *cardProject in self.memberCard.projects)
        {
            if (cardProject.remainQty.integerValue > 0)
            {
                [mutableArray addObject:cardProject];
            }
        }
        self.itemArray = [NSArray arrayWithArray:mutableArray];
        self.returnArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    
    UIView *leftBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width - kPadProjectSideViewWidth, IC_SCREEN_HEIGHT)];
    leftBackground.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    [self.view addSubview:leftBackground];
    
    self.itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width - kPadProjectSideViewWidth, self.view.frame.size.height - kPadNaviHeight) style:UITableViewStylePlain];
    self.itemTableView.backgroundColor = [UIColor clearColor];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.itemTableView.dataSource = self;
    self.itemTableView.delegate = self;
    self.itemTableView.showsVerticalScrollIndicator = NO;
    self.itemTableView.showsHorizontalScrollIndicator = NO;
    self.itemTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.itemTableView];
    
    self.returnTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth, kPadNaviHeight, kPadProjectSideViewWidth, self.view.frame.size.height - kPadNaviHeight - kPadConfirmButtonHeight) style:UITableViewStylePlain];
    self.returnTableView.backgroundColor = [UIColor clearColor];
    self.returnTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.returnTableView.dataSource = self;
    self.returnTableView.delegate = self;
    self.returnTableView.showsVerticalScrollIndicator = NO;
    self.returnTableView.showsHorizontalScrollIndicator = NO;
    self.returnTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.returnTableView];
    
    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth, self.view.frame.size.height - kPadConfirmButtonHeight, kPadProjectSideViewWidth, kPadConfirmButtonHeight)];
    self.confirmButton.backgroundColor = [UIColor clearColor];
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self.confirmButton setTitleColor:COLOR(168.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
    [self.confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_n"] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_h"] forState:UIControlStateHighlighted];
    [self.confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
    
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, (kPadNaviHeight - 24.0)/2.0, self.view.frame.size.width - kPadProjectSideViewWidth - 2 * kPadNaviHeight, 24.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = LS(@"PadCanReturnItemList");
    [navi addSubview:titleLabel];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth - 1.0, 0.0, 1.0, kPadNaviHeight)];
    lineImageView.backgroundColor = COLOR(216.0, 230.0, 230.0, 1.0);
    [navi addSubview:lineImageView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth, (kPadNaviHeight - 24.0)/2.0, kPadProjectSideViewWidth, 24.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = LS(@"PadMemberCardReturnItem");
    [navi addSubview:titleLabel];
}

- (void)refreshConfirmButton
{
    if (self.returnArray.count == 0)
    {
        [self.confirmButton setTitleColor:COLOR(168.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_n"] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_h"] forState:UIControlStateHighlighted];
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.memberCard.cardID forKey:@"card_id"];
    NSMutableArray *exchangeLineIds = [NSMutableArray array];
    for (int i = 0; i < self.returnArray.count; i++)
    {
        BSReturnItem *returnItem = [self.returnArray objectAtIndex:i];
        NSArray *array = @[@(0), @(NO), @{@"lines_id":returnItem.cardProject.productLineID, @"product_id":returnItem.cardProject.projectID, @"available_qty":returnItem.cardProject.remainQty, @"exchange_qty":@(returnItem.returnCount), @"exchange_amount":@(returnItem.returnAmount)}];
        [exchangeLineIds addObject:array];
    }
    
    [params setObject:exchangeLineIds forKey:@"exchange_line_ids"];
    [[CBLoadingView shareLoadingView] show];
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateExchange];
    [request execute];
}

- (void)didMemberCardProjectAdded:(CDMemberCardProject *)cardProject
{
    BOOL isExist = NO;
    for (BSReturnItem *returnItem in self.returnArray)
    {
        if (returnItem.cardProject == cardProject)
        {
            isExist = YES;
            if (returnItem.returnCount + 1 <= cardProject.remainQty.integerValue)
            {
                returnItem.returnCount ++;
                returnItem.returnAmount = returnItem.cardProject.projectPriceUnit.doubleValue * returnItem.returnCount;
            }
            [[BSCoreDataManager currentManager] save:nil];
            
            break;
        }
    }
    
    if (!isExist)
    {
        BSReturnItem *returnItem = [[BSReturnItem alloc] init];
        returnItem.cardProject = cardProject;
        returnItem.returnCount = 1;
        returnItem.returnAmount = returnItem.cardProject.projectPriceUnit.doubleValue * returnItem.returnCount;
        [self.returnArray addObject:returnItem];
    }
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self.maskView hidden];
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.itemTableView)
    {
        return self.itemArray.count;
    }
    else if (tableView == self.returnTableView)
    {
        return self.returnArray.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.itemTableView)
    {
        return kPadCustomItemCellHeight;
    }
    else if (tableView == self.returnTableView)
    {
        return kPadProjectSideCellHeight;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.itemTableView)
    {
        static NSString *CellIdentifier = @"PadProjectCellIdentifier";
        PadProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadProjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CDMemberCardProject *cardProject = [self.itemArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = cardProject.projectName;
        cell.priceLabel.text = [NSString stringWithFormat:LS(@"PadCanReturnItemCount"), cardProject.remainQty.integerValue];
        
        return cell;
    }
    else if (tableView == self.returnTableView)
    {
        static NSString *CellIdentifier = @"PadProjectSideCellIdentifier";
        PadProjectSideCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadProjectSideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        BSReturnItem *returnItem = [self.returnArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = returnItem.cardProject.projectName;
        cell.numberLabel.text = [NSString stringWithFormat:LS(@"PadPosProductNum"), returnItem.returnCount];
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", returnItem.returnAmount];
        
        return cell;
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.returnTableView)
    {
        return YES;
    }
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.returnTableView)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.returnArray removeObjectAtIndex:indexPath.row];
        [self.returnTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self refreshConfirmButton];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.itemTableView)
    {
        CDMemberCardProject *cardProject = [self.itemArray objectAtIndex:indexPath.row];
        [self didMemberCardProjectAdded:cardProject];
        
        [self.itemTableView reloadData];
        [self.returnTableView reloadData];
        [self refreshConfirmButton];
    }
    else if (tableView == self.returnTableView)
    {
        BSReturnItem *returnItem = [self.returnArray objectAtIndex:indexPath.row];
        PadProjectDetailViewController *viewController = [[PadProjectDetailViewController alloc] initWithReturnItem:returnItem];
        viewController.delegate = self;
        viewController.maskView = self.maskView;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark -
#pragma mark PadProjectDetailViewControllerDelegate Methods

- (void)didPadReturnItemDelete:(BSReturnItem *)returnItem
{
    [self.returnArray removeObject:returnItem];
    [self.returnTableView reloadData];
}

- (void)didPadReturnItemEditConfirm:(BSReturnItem *)returnItem
{
    [self.returnTableView reloadData];
}

@end
