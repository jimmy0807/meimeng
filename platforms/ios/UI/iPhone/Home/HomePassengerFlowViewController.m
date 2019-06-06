//
//  HomePassengerFlowViewController.m
//  Boss
//
//  Created by jimmy on 15/7/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "HomePassengerFlowViewController.h"
#import "FetchHomePassengerFlowDetailRequest.h"
#import "HomePassengerFlowTableViewCell.h"
#import "HomeCountData.h"
#import "MemberOperateDetailViewController.h"
#import "BSFetchCardOperateRequest.h"

@interface HomePassengerFlowViewController ()<HomePassengerFlowTableViewCellDelegate>
@property(nonatomic, weak)IBOutlet UILabel* totalPassengerLabel;
@property(nonatomic, weak)IBOutlet UILabel* storeNameLabel;
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)NSArray* passengerFlowArray;
@property(nonatomic, strong)NSMutableDictionary* expandItemDictionary;
@end

@implementation HomePassengerFlowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"今日客流量";
    
    [self reloadData];
    
    [[[FetchHomePassengerFlowDetailRequest alloc] init] execute];
    
    self.expandItemDictionary = [NSMutableDictionary dictionary];
    
    [self registerNofitificationForMainThread:kFetchHomePassengerFlowDetailResponse];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kFetchHomePassengerFlowDetailResponse])
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
    self.passengerFlowArray = [[BSCoreDataManager currentManager] fetchHomePassengerFlowDetail];
    
    if ( self.passengerFlowArray.count == 0 )
    {
        self.totalPassengerLabel.text = [NSString stringWithFormat:@"%@",[HomeCountData currentData].totalpassengerFlow];
    }
    else
    {
        self.totalPassengerLabel.text = [NSString stringWithFormat:@"%d",self.passengerFlowArray.count];
    }
    
    self.storeNameLabel.text = [[PersonalProfile currentProfile] getCurrentStore].storeName;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.passengerFlowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = @"HomePassengerFlowTableViewCell";
    HomePassengerFlowTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomePassengerFlowTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    cell.indexPath = indexPath;
    CDPassengerFlow* item = self.passengerFlowArray[indexPath.row];
    
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
//    HomePassengerFlowTableViewCell* cell = (HomePassengerFlowTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    [cell didCellPressed];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CDPassengerFlow* item = self.passengerFlowArray[indexPath.row];
    
    BSFetchCardOperateRequest *reqeust = [[BSFetchCardOperateRequest alloc] initWithOperateID:item.itemID];
    [reqeust execute];
    
    MemberOperateDetailViewController *operateDetailVC = [[MemberOperateDetailViewController alloc] init];
    operateDetailVC.operateID = item.itemID;
    [self.navigationController pushViewController:operateDetailVC animated:YES];
}

-(void)didExpandPressedAtIndex:(NSIndexPath*)path isExpand:(BOOL)expand
{
    [self.expandItemDictionary setObject:@(expand) forKey:@(path.row)];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
}

@end
