//
//  MemberCallRecordViewController.m
//  Boss
//
//  Created by lining on 16/5/4.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCallRecordViewController.h"
#import "MemberCardCell.h"
#import "BSFetchCallRecordRequest.h"

@interface MemberCallRecordViewController ()
@property (strong, nonatomic) NSArray *callRecords;
@end

@implementation MemberCallRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.title = @"来电记录";
    [self registerNofitificationForMainThread:kBSFetchMemberCallRecordResponse];
    
    BSFetchCallRecordRequest *request = [[BSFetchCallRecordRequest alloc] initWithStoreID:self.store.storeID];
    [request execute];
    
//    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)reloadData
{
    self.callRecords = [[BSCoreDataManager currentManager] fetchMemberRecordsWithStoreID:self.store.storeID];
    [self.tableView reloadData];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberCallRecordResponse]) {
        [self reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.callRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"identifier";
    MemberCardCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCardCell"];
    if (cell == nil) {
        cell = [MemberCardCell createCell];
    }

    cell.detailLabel.textColor = [UIColor blackColor];

    CDMemberCallRecord *callRecord = [self.callRecords objectAtIndex:indexPath.row];
    if ([callRecord.is_answer boolValue]) {
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    else
    {
        cell.titleLabel.textColor = [UIColor redColor];
    }
    cell.titleLabel.text = [self sepreatePhoneString:callRecord.phone];
    
    cell.detailLabel.text = callRecord.member_name;
    
    cell.valueLabel.text = callRecord.last_update;
    
    cell.arrowImgViewHidden = true;
    
    return cell;
}

- (NSString *)sepreatePhoneString:(NSString *)phoneString
{
    NSString *sepreateString;
    if (phoneString.length == 11) {
        sepreateString = [NSString stringWithFormat:@"%@-%@-%@",[phoneString substringWithRange:NSMakeRange(0, 3)],[phoneString substringWithRange:NSMakeRange(3, 4)],[phoneString substringWithRange:NSMakeRange(7, 4)]];
    }
    else
    {
        sepreateString = phoneString;
    }
    return sepreateString;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
