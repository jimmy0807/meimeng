//
//  MemberWevipViewController.m
//  Boss
//
//  Created by lining on 16/4/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberWevipViewController.h"
#import "StaffCell.h"
#import "UIView+Frame.h"
#import "MemberFunctionViewController.h"

@interface MemberWevipViewController ()<StaffCellDelegate>
@property (nonatomic, strong) NSArray *wevipMembers;
@property (nonatomic, strong) NSMutableDictionary *cachePicParams;
@end

@implementation MemberWevipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.title = @"微卡会员";
    
    self.wevipMembers = [[BSCoreDataManager currentManager] fetchWevipMembersWithStoreID:self.store.storeID];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wevipMembers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    
    CDMember *member = [self.wevipMembers objectAtIndex:indexPath.row];
    cell.nameLabel.text = member.memberName;
    cell.IDLable.text = member.memberNo;
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

#pragma mark -
#pragma mark cell delegate method
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    //    CDMember *member = [self.members objectAtIndex:indexPath.row];
    //
    //    MemberDetailViewController *viewController = [[MemberDetailViewController alloc] initWithNibName:NIBCT(@"MemberDetailViewController") bundle:nil];
    //    viewController.member = member;
    //
    //    [self.navigationController pushViewController:viewController animated:YES];
    
    CDMember *member = [self.wevipMembers objectAtIndex:indexPath.row];
    MemberFunctionViewController *memberFunctionVC = [[MemberFunctionViewController alloc] initWithNibName:@"MemberFunctionViewController" bundle:nil];
    memberFunctionVC.member = member;
    [self.navigationController pushViewController:memberFunctionVC animated:YES];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
