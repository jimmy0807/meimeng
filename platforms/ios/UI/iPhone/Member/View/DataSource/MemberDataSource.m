//
//  MemberDataSource.m
//  Boss
//
//  Created by lining on 16/5/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberDataSource.h"
#import "UIView+Frame.h"
#import "StaffCell.h"

#define kCellHeight     60


@interface MemberDataSource ()<StaffCellDelegate>
@property (nonatomic, strong) NSMutableDictionary *cachePicParams;
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation MemberDataSource

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.cachePicParams = [NSMutableDictionary dictionary];
        self.tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)setFilterMembers:(NSArray *)filterMembers
{
    NSMutableArray *members = [NSMutableArray array];
    for (CDMember *member in filterMembers) {
        if (member.isDefaultCustomer.boolValue) {
            continue;
        }
        [members addObject:member];
    }
    
    _filterMembers = [NSArray arrayWithArray:members];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filterMembers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSStaffCellIdentifier";
    StaffCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[StaffCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.lineImgView.x = cell.nameLabel.x;
        cell.lineImgView.width = IC_SCREEN_WIDTH - cell.nameLabel.x;
    }
    
    CDMember *member = [self.filterMembers objectAtIndex:indexPath.row];
    cell.nameLabel.text = member.memberName;
    cell.IDLable.text = member.mobile;
    cell.indexPath = indexPath;
    
    if ( [member.isAcitve boolValue] )
    {
        if ( [member.isWevipCustom boolValue] )
        {
            cell.nameLabel.textColor = COLOR(0, 23, 246, 1);
            cell.nameLabel.textColor = COLOR(0, 23, 246, 1);
        }
        else
        {
            cell.nameLabel.textColor = COLOR(76, 76, 76, 1);
            cell.IDLable.textColor = COLOR(76, 76, 76, 1);
        }
    }
    else
    {
        cell.nameLabel.textColor = COLOR(255, 0, 19, 1);
        cell.nameLabel.textColor = COLOR(255, 0, 19, 1);
    }
    
    [cell.headImgView setImageWithName:member.imageName tableName:@"born.member" filter:member.memberID fieldName:@"image" writeDate:member.lastUpdate placeholderString:@"user_default" cacheDictionary:self.cachePicParams completion:nil];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - cell delegate
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectedMemberAtIndexPath:)]) {
        [self.delegate didSelectedMemberAtIndexPath:indexPath];
    }
}
@end
