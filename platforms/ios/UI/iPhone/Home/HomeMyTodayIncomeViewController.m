//
//  HomeMyTodayIncomeViewController.m
//  Boss
//
//  Created by jimmy on 15/7/28.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "HomeMyTodayIncomeViewController.h"

#import "FetchHomeMyTodayInComeDetailRequset.h"
#import "HomeMyTodayIncomeDetailTableViewCell.h"
#import "HomeCountData.h"

@interface HomeMyTodayIncomeViewController ()<HomeMyTodayIncomeDetailTableViewCellDelegate>
@property(nonatomic, weak)IBOutlet UILabel* totalMoneyLabel;
@property(nonatomic, weak)IBOutlet UILabel* timeLabel;
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)NSArray* myIncomeArray;
@property(nonatomic, strong)NSMutableDictionary* expandItemDictionary;
@end

@implementation HomeMyTodayIncomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"我的提成";
    
    [self reloadData];
    
    [[[FetchHomeMyTodayInComeDetailRequset alloc] init] execute];
    
    self.expandItemDictionary = [NSMutableDictionary dictionary];
    
    [self registerNofitificationForMainThread:kFetchHomeMyTodayIncomeDetailResponse];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kFetchHomeMyTodayIncomeDetailResponse])
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
    self.myIncomeArray = [[BSCoreDataManager currentManager] fetchHomeMyTodayIncomeDetail];
    
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"%@",[HomeCountData currentData].totalMyTodayInCome];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy年MM月";
    NSString* today = [dateFormat stringFromDate:[NSDate date]];
    
    self.timeLabel.text = today;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myIncomeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = @"HomeMyTodayIncomeDetailTableViewCell";
    HomeMyTodayIncomeDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeMyTodayIncomeDetailTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    cell.indexPath = indexPath;
    CDMyTodayInComeItem* item = self.myIncomeArray[indexPath.row];
    
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
    HomeMyTodayIncomeDetailTableViewCell* cell = (HomeMyTodayIncomeDetailTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell didCellPressed];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)didExpandPressedAtIndex:(NSIndexPath*)path isExpand:(BOOL)expand
{
    [self.expandItemDictionary setObject:@(expand) forKey:@(path.row)];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
}

@end
