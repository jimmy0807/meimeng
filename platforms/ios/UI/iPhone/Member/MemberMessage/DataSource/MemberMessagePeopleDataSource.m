//
//  MemberMessagePeopleDataSource.m
//  Boss
//
//  Created by lining on 16/5/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberMessagePeopleDataSource.h"
#import "MemberMessagePeopleCell.h"

#define kCellHeight     60

@interface MemberMessagePeopleDataSource ()
@property (nonatomic, strong) NSMutableDictionary *cachePicParams;
@property (nonatomic, strong) NSMutableDictionary *selectedDict;
@property (nonatomic, strong) NSMutableOrderedSet *itemsSet;
@end

@implementation MemberMessagePeopleDataSource

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.cachePicParams = [NSMutableDictionary dictionary];
        self.selectedDict = [NSMutableDictionary dictionary];
        self.itemsSet = [NSMutableOrderedSet orderedSet];
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cachePicParams = [NSMutableDictionary dictionary];
        self.selectedDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setFilterMembers:(NSArray *)filterMembers
{
    _filterMembers = filterMembers;
    for (CDMember *member in filterMembers) {
        if (member.isDefaultCustomer.boolValue) {
            continue;
        }
        if (![self.selectedDict objectForKey:member.memberID]) {
            [self.selectedDict setObject:[NSNumber numberWithBool:false] forKey:member.memberID];
        }
    }
    [self.tableView reloadData];
}

- (void)setAllSelected:(BOOL)allSelected
{
    _allSelected = allSelected;
    if (allSelected) {
        for (CDMember *member in self.filterMembers) {
            [self.selectedDict setObject:[NSNumber numberWithBool:true] forKey:member.memberID];
            [self.itemsSet addObject:member];
        }
        
    }
    else
    {
        for (CDMember *member in self.filterMembers) {
            [self.selectedDict setObject:[NSNumber numberWithBool:false] forKey:member.memberID];
            [self.itemsSet removeObject:member];
        }
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedItemsChanged:)]) {
        [self.delegate didSelectedItemsChanged:self.itemsSet];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filterMembers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberMessagePeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberMessagePeopleCell"];
    if (cell == nil)
    {
        cell = [MemberMessagePeopleCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CDMember *member = [self.filterMembers objectAtIndex:indexPath.row];
    cell.nameLabel.text = member.memberName;
    cell.IDLabel.text = member.memberNo;
    
    if ([[self.selectedDict objectForKey:member.memberID] boolValue]) {
        cell.selectedImgView.highlighted = true;
    }
    else
    {
        cell.selectedImgView.highlighted = false;
    }
    
    
//     cell.selectedImgView.highlighted = [[self.selectedDict objectForKey:member.memberID] boolValue];
  
    
//    if ( [member.isAcitve boolValue] )
//    {
//        if ( [member.isWevipCustom boolValue] )
//        {
//            cell.nameLabel.textColor = COLOR(0, 23, 246, 1);
//            cell.nameLabel.textColor = COLOR(0, 23, 246, 1);
//        }
//        else
//        {
//            cell.nameLabel.textColor = COLOR(76, 76, 76, 1);
//            cell.IDLabel.textColor = COLOR(76, 76, 76, 1);
//        }
//    }
//    else
//    {
//        cell.nameLabel.textColor = COLOR(255, 0, 19, 1);
//        cell.nameLabel.textColor = COLOR(255, 0, 19, 1);
//    }
    
    [cell.headImgView setImageWithName:member.imageName tableName:@"born.member" filter:member.memberID fieldName:@"image" writeDate:member.lastUpdate placeholderString:@"user_default" cacheDictionary:self.cachePicParams completion:nil];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CDMember *member = [self.filterMembers objectAtIndex:indexPath.row];
    BOOL selected = ![[self.selectedDict objectForKey:member.memberID] boolValue];
    [self.selectedDict setObject:[NSNumber numberWithBool:selected] forKey:member.memberID];
    
    if (selected) {
        [self.itemsSet addObject:member];
    }
    else
    {
        [self.itemsSet removeObject:member];
    }

    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(didSelectedItemsChanged:)]) {
        [self.delegate didSelectedItemsChanged:self.itemsSet];
    }
    
    
}

@end
