//
//  MemberQinyouDataSource.m
//  Boss
//
//  Created by lining on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberQinyouDataSource.h"
#import "BSItemCell.h"
#import "BSFetchMemberQinyouRequest.h"
#import "BSUpdateMemberRequest.h"
#import "CBLoadingView.h"
#import "UIView+Frame.h"

@interface MemberQinyouDataSource ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *qinyous;
@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) NSIndexPath *deletedIndexPath;
@end

@implementation MemberQinyouDataSource

- (instancetype)initWithMember:(CDMember *)member tableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.member = member;
        self.tableView = tableView;
        self.qinyous = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchMemberQinyouWithMember:self.member]];
        
        tableView.dataSource = self;
        tableView.delegate = self;
        [self registerNofitificationForMainThread:kBSFetchMemberQinyouResponse];
        [self registerNofitificationForMainThread:kBSUpdateMemberResponse];
//        [self registerNofitificationForMainThread:@"kBSUpdateQinyouSuccess"];
    }
    return self;
}

- (void) reloadData
{
    self.qinyous = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchMemberQinyouWithMember:self.member]];
    [self.tableView reloadData];
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberQinyouResponse]) {
        [self reloadData];
    }
    else if ([notification.name isEqualToString:kBSUpdateMemberResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        NSNumber *ret = [notification.userInfo stringValueForKey:@"rc"];
        if ([ret integerValue] == 0) {
            if (self.deletedIndexPath) {
                [self.qinyous removeObjectAtIndex:self.deletedIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[self.deletedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            [[[BSFetchMemberQinyouRequest alloc] initWithMember:self.member] execute];
            
        }

        self.deletedIndexPath = nil;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.qinyous.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = @"identifier";
    BSItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BSItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIImage *defaultImg = [UIImage imageNamed:@"user_default.png"];
        cell.itemImageView.width = defaultImg.size.width;
        cell.itemImageView.height = defaultImg.size.height;
        
        
    }
    CDMemberQinyou *qinyou = [self.qinyous objectAtIndex:indexPath.row];
    cell.titleLabel.text = qinyou.name;
    
    [cell.itemImageView setImageWithName:qinyou.image_name tableName:@"born.relatives" filter:qinyou.qy_id fieldName:@"image" writeDate:qinyou.last_update placeholderString:@"setting_profile.png" cacheDictionary:[NSMutableDictionary dictionary] completion:^(UIImage *image) {
    }];

    if (qinyou.telephone.length == 11) {
        cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@-%@",[qinyou.telephone substringWithRange:NSMakeRange(0, 3)],[qinyou.telephone substringWithRange:NSMakeRange(3, 4)],[qinyou.telephone substringWithRange:NSMakeRange(7, 4)]];
    }
    else
    {
        cell.detailLabel.text = qinyou.telephone;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.deletedIndexPath = indexPath;
        CDMemberQinyou *qy = self.qinyous[indexPath.row];
        [[CBLoadingView shareLoadingView] show];
        
        NSMutableArray *array = [NSMutableArray array];
        
        NSArray *subArray = @[[NSNumber numberWithInt:kBSDataDelete],qy.qy_id,@0];
        [array addObject:subArray];
        
        NSDictionary *dict = @{@"relatives_ids":array};
        
        BSUpdateMemberRequest *updateRequest = [[BSUpdateMemberRequest alloc]initWithMember:self.member params:dict];
        [updateRequest execute];

    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectedQinyou:)]) {
        CDMemberQinyou *qinyou = self.qinyous[indexPath.row];
        [self.delegate didSelectedQinyou:qinyou];
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
