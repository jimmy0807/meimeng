//
//  MemberFollowCreateViewController.m
//  Boss
//
//  Created by lining on 16/5/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFollowCreateViewController.h"
#import "BSFetchFollowPeroidRequest.h"
#import "FilterGuwenCell.h"
#import "CBMessageView.h"
#import "BSMemberFollowCreateRequest.h"
#import "CBLoadingView.h"
#import "NSDate+Formatter.h"

#define MONTH_MARGIN_DAY 3

@interface MemberFollowCreateViewController ()
@property (nonatomic, strong) NSArray *periods;
@property (nonatomic, strong) CDMemberFollowPeroid *currentPeriod;
@property (strong, nonatomic) IBOutlet UITextField *monthTextField;

@end

@implementation MemberFollowCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"新建跟进表";
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:@"确定"];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self reloadView];
    
    [self registerNofitificationForMainThread:kBSFetchFollowPeroidResponse];
    [self registerNofitificationForMainThread:kBSCreateMemberFollowResponse];
    [self sendRequest];
}

#pragma mark - reloadView
- (void) reloadView
{
    NSInteger month = [[NSDate date] month];
    NSInteger day = [[NSDate date] day];
    NSInteger monthLength = [[NSDate date] monthDaysLen];
    
    if (monthLength - MONTH_MARGIN_DAY <= day) {
        month = month + 1;
    }
    
    self.periods = [[BSCoreDataManager currentManager] fetchMemberFollowPeriodsWithMonth:month];
    [self.monthTableView reloadData];
}

#pragma mark - send request
- (void)sendRequest
{
    BSFetchFollowPeroidRequest *peroidRequest = [[BSFetchFollowPeroidRequest alloc] init];
    [peroidRequest execute];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchFollowPeroidResponse]) {
        [self reloadView];
    }
    else if ([notification.name isEqualToString:kBSCreateMemberFollowResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        NSInteger ret = [[notification.userInfo numberValueForKey:@"rc"] integerValue];
        if (ret == 0) {
            [[[CBMessageView alloc] initWithTitle:@"创建成功"] show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
        }
    }
}

#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    if (self.monthTextField.text.length == 0) {
        [[[CBMessageView alloc] initWithTitle:@"请选择月份"] show];
        return;
    }
    
    [self createFollow];
}

#pragma mark - create request
- (void)createFollow
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.currentPeriod.period_id forKey:@"period_id"];
    [params setObject:self.member.memberID forKey:@"member_id"];
    [params setObject:@"新建跟进表" forKey:@"name"];
    BSMemberFollowCreateRequest *followCreateRequest = [[BSMemberFollowCreateRequest alloc] initWithParams:params];
    [followCreateRequest execute];
    [[CBLoadingView shareLoadingView] show];
}


#pragma mark - show & hide monthView
- (void)showMonthView
{
    self.bottomMonthViewConstraint.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hideMonthView
{
    self.bottomMonthViewConstraint.constant = -263;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}




- (IBAction)cancelBtnPressed:(id)sender {
    [self hideMonthView];
}

- (IBAction)selecteBtnPressed:(id)sender {
    [self showMonthView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.periods.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterGuwenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterGuwenCell"];
    if (cell == nil) {
        cell = [FilterGuwenCell createCell];
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    CDMemberFollowPeroid *period = [self.periods objectAtIndex:indexPath.row];
    if (self.currentPeriod && ([self.currentPeriod.period_id integerValue] == [period.period_id integerValue])) {
        cell.selectedImgView.hidden = false;
    }
    else
    {
        cell.selectedImgView.hidden = true;
    }
    cell.nameLabel.text = period.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CDMemberFollowPeroid *period = [self.periods objectAtIndex:indexPath.row];
    if (self.currentPeriod && ([self.currentPeriod.period_id integerValue] == [period.period_id integerValue])) {
        return;
    }
    else
    {
        self.currentPeriod = period;
    }
    self.monthTextField.text = self.currentPeriod.name;
    [self.monthTableView reloadData];
    [self performSelector:@selector(hideMonthView) withObject:nil afterDelay:0.1];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
