//
//  FilterGuwenDataSource.m
//  Boss
//
//  Created by lining on 16/5/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FilterGuwenDataSource.h"
#import "FilterGuwenCell.h"
#import "BSFetchStaffRequest.h"

@interface FilterGuwenDataSource ()
@property (nonatomic, strong) NSArray *staffs;
@end


@implementation FilterGuwenDataSource

- (instancetype)initWithStore:(CDStore *)store
{
    self = [super init];
    if (self ) {
        self.store = store;
        self.staffs = [[BSCoreDataManager currentManager] fetchStaffsWithShopID:self.store.storeID];
//        BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
//        [request execute];
//        [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    }
    return self;
}


//#pragma mark - received notification
//- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
//{
//    
//}

- (CGFloat)getHeight
{
//    if (self.staffs.count == 0) {
//        return 300;
//    }
//    return self.staffs.count * 50;
    
    return IC_SCREEN_HEIGHT * 0.5;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.staffs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterGuwenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterGuwenCell"];
    if (cell == nil) {
        cell = [FilterGuwenCell createCell];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    CDStaff *staff = [self.staffs objectAtIndex:indexPath.row];
    if (self.currentStaff && ([self.currentStaff.staffID integerValue] == [staff.staffID integerValue])) {
        cell.selectedImgView.hidden = false;
    }
    else
    {
        cell.selectedImgView.hidden = true;
    }
    cell.nameLabel.text = staff.name;

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
    CDStaff *staff = [self.staffs objectAtIndex:indexPath.row];
    if (self.currentStaff && ([self.currentStaff.staffID integerValue] == [staff.staffID integerValue])) {
        return;
    }
    else
    {
        self.currentStaff = staff;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedGuwen:)]) {
        [self.delegate didSelectedGuwen:self.currentStaff];
    }
}

@end
