//
//  MemberFollowContentDataSource.m
//  Boss
//
//  Created by lining on 16/5/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFollowContentDataSource.h"
#import "MemberTezhengCell.h"

@interface MemberFollowContentDataSource ()
@property (nonatomic, strong) MemberTezhengCell *cell;
@end

@implementation MemberFollowContentDataSource
#pragma mark - UITableViewDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cell = [MemberTezhengCell createCell];
        self.cell.contentLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 20;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.followContents.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger row = indexPath.row;
//    NSInteger section = indexPath.section;
    
    MemberTezhengCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberTezhengCell"];
    if (cell == nil) {
        cell = [MemberTezhengCell createCell];
    }
    
    CDMemberFollowContent *followContent = [self.followContents objectAtIndex:indexPath.section];
    cell.nameLabel.text = followContent.guwen_name;
    cell.contentLabel.text = followContent.note;
    cell.typeLabel.font = [UIFont systemFontOfSize:13.0f];
    cell.typeLabel.textColor = [UIColor grayColor];
    cell.typeLabel.text = followContent.date;
    return cell;
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDMemberFollowContent *followContent = [self.followContents objectAtIndex:indexPath.section];
    self.cell.nameLabel.text = followContent.name;
    self.cell.contentLabel.text = followContent.note;
    CGFloat height = [self.cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"height: %d",height);
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}



- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self.delegate respondsToSelector:@selector(didItemSelectedwithType:atIndexPath:)]) {
        [self.delegate didItemSelectedwithType:self.tag atIndexPath:indexPath];
    }
}
@end
