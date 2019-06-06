//
//  HomeTodayIncomeViewController.m
//  Boss
//
//  Created by jimmy on 15/7/22.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "HomeTodayIncomeViewController.h"
#import "FetchHomeTodayIncomeDetailRequest.h"
#import "HomeTodayIncomeDetailTableViewCell.h"

@interface HomeTodayIncomeViewController ()<HomeTodayIncomeDetailTableViewCellDelegate>
@property(nonatomic, weak)IBOutlet UILabel* totalMoneyLabel;
@property(nonatomic, weak)IBOutlet UILabel* storeNameLabel;
@property(nonatomic, weak)IBOutlet UILabel* consumeMoneyLabel;
@property(nonatomic, weak)IBOutlet UILabel* outMoneyLabel;
@property(nonatomic, weak)IBOutlet UILabel* chuzhiMoneyLabel;
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)CDTodayIncomeMain* income;
@property(nonatomic, strong)NSMutableDictionary* expandItemDictionary;
@end

@implementation HomeTodayIncomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"今日总收入";
    [self reloadData];
    [[[FetchHomeTodayIncomeDetailRequest alloc] init] execute];
    self.expandItemDictionary = [NSMutableDictionary dictionary];
    [self registerNofitificationForMainThread:kFetchHomeTodayIncomeDetailResponse];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kFetchHomeTodayIncomeDetailResponse])
    {
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            [self reloadData];
        }
    }
}

- (void)reloadData
{
    self.income = [[BSCoreDataManager currentManager] fetchTodayIncomeDetail];
    
    self.totalMoneyLabel.text = self.income.total_in_amout.length > 0 ? self.income.total_in_amout : @"0.00";
    self.consumeMoneyLabel.text = self.income.situation_amount.length > 0 ? self.income.situation_amount : @"0.00";
    self.outMoneyLabel.text = self.income.total_out_amount.length > 0 ? self.income.total_out_amount : @"0.00";
    self.chuzhiMoneyLabel.text = self.income.total_remain_amount.length > 0 ? [NSString stringWithFormat:@"%0.1f",[self.income.total_remain_amount floatValue]] : @"0.00";
    
    self.storeNameLabel.text = [[PersonalProfile currentProfile] getCurrentStore].storeName;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.income.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = @"HomeTodayIncomeDetailTableViewCell";
    HomeTodayIncomeDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTodayIncomeDetailTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    cell.indexPath = indexPath;
    CDTodayIncomeItem* item = self.income.items[indexPath.row];
    
    [cell setItemInfo:item];
    [cell setIsExpand:[self.expandItemDictionary[@(indexPath.row)] boolValue]];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [self.expandItemDictionary[@(indexPath.row)] boolValue] )
    {
        return 198;
    }
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTodayIncomeDetailTableViewCell* cell = (HomeTodayIncomeDetailTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell didCellPressed];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)didExpandPressedAtIndex:(NSIndexPath*)path isExpand:(BOOL)expand
{
    [self.expandItemDictionary setObject:@(expand) forKey:@(path.row)];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
}

@end
