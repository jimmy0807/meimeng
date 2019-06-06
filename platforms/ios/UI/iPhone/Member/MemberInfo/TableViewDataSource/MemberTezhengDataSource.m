//
//  MemberTezhengDataSource.m
//  Boss
//
//  Created by lining on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberTezhengDataSource.h"
#import "MemberTezhengCell.h"
#import "BSFetchMemberTezhengRequest.h"
#import "CBLoadingView.h"
#import "BSFetchMemberQinyouRequest.h"
#import "BSUpdateMemberRequest.h"

@interface MemberTezhengDataSource ()
@property (nonatomic, strong) MemberTezhengCell *cell;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CDMember *memebr;
@property (nonatomic, strong) NSMutableArray *tezhengs;
@property (nonatomic, strong) NSIndexPath *deletedIndexPath;
@end

@implementation MemberTezhengDataSource

- (instancetype)initWithMember:(CDMember *)member tableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.memebr = member;
        
        self.tezhengs = [NSMutableArray arrayWithArray:[[BSCoreDataManager  currentManager] fetchMemberTezhengWithMember:self.memebr]];
        
        self.tableView = tableView;
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
//        self.tableView.editing = true;
        self.cell = [MemberTezhengCell createCell];
        self.cell.contentLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 20;
        
        [self registerNofitificationForMainThread:kBSFetchMemberTezhengResponse];
        [self registerNofitificationForMainThread:kBSUpdateMemberResponse];
    }
    return self;
}

- (void) reloadData
{
    self.tezhengs = [NSMutableArray arrayWithArray:[[BSCoreDataManager  currentManager] fetchMemberTezhengWithMember:self.memebr]];
    [self.tableView reloadData];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberTezhengResponse]) {
        [self reloadData];
    }
    else if ([notification.name isEqualToString:kBSUpdateMemberResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        NSNumber *ret = [notification.userInfo stringValueForKey:@"rc"];
        if ([ret integerValue] == 0) {
            if (self.deletedIndexPath) {
                [self.tezhengs removeObjectAtIndex:self.deletedIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[self.deletedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            [[[BSFetchMemberQinyouRequest alloc] initWithMember:self.memebr] execute];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.tezhengs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MemberTezhengCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberTezhengCell"];
    if (cell == nil) {
        cell = [MemberTezhengCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CDMemberTeZheng *tezheng = [self.tezhengs objectAtIndex:indexPath.row];
    cell.nameLabel.text = tezheng.tz_name;
    cell.contentLabel.text = tezheng.tz_describle;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.deletedIndexPath = indexPath;
    CDMemberTeZheng *tz = self.tezhengs[indexPath.row];
    [[CBLoadingView shareLoadingView] show];
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *subArray = @[[NSNumber numberWithInt:kBSDataDelete],tz.tz_id,@0];
    [array addObject:subArray];
    
    NSDictionary *dict = @{@"extended_ids":array};
    
    BSUpdateMemberRequest *updateRequest = [[BSUpdateMemberRequest alloc]initWithMember:self.memebr params:dict];
    [updateRequest execute];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectedTezheng:)]) {
        CDMemberTeZheng *tezheng = self.tezhengs[indexPath.row];
        [self.delegate didSelectedTezheng:tezheng];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDMemberTeZheng *tezheng = [self.tezhengs objectAtIndex:indexPath.row];
    
    self.cell.nameLabel.text = tezheng.tz_name;
    self.cell.contentLabel.text = tezheng.tz_describle;
    CGFloat height = [self.cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"height: %d",height);
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
