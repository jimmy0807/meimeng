//
//  MemberFeedbackViewController.m
//  Boss
//
//  Created by lining on 16/8/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFeedbackViewController.h"
#import "MemberTezhengViewController.h"
#import "MemberTezhengCell.h"
#import "BSFetchFeedbacksRequest.h"
#import "MemberFeedbackDetailViewController.h"

@interface MemberFeedbackViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *feedbacks;
@property (nonatomic, strong) MemberTezhengCell *cell;
@end

@implementation MemberFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n"] highlightedImage:[UIImage imageNamed:@"navi_add_h"]];
    rightButtonItem.delegate = self;
  //  self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.navigationItem.title = @"护理反馈";

    
    self.cell = [MemberTezhengCell createCell];
    self.cell.contentLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 20;
    
    [self reloadData];
    
    [self registerNofitificationForMainThread:kBSFetchFeedbackResponse];
    [self sendRquest];
}

- (void)sendRquest
{
    BSFetchFeedbacksRequest *request = [[BSFetchFeedbacksRequest alloc] initWithMember:self.member];
    [request execute];
}

- (void)reloadData
{
    self.feedbacks = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchMemberFeedbackWithMember:self.member]];
}


#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    MemberFeedbackDetailViewController *detailVC = [[MemberFeedbackDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchFeedbackResponse]) {
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
    
    return self.feedbacks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberTezhengCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberTezhengCell"];
    if (cell == nil) {
        cell = [MemberTezhengCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.typeLabel.font = [UIFont systemFontOfSize:13.0];
        cell.typeLabel.textColor = [UIColor grayColor];
        cell.arrowImgViewHidden = false;
    }
    CDMemberFeedback *feedback = [self.feedbacks objectAtIndex:indexPath.row];
    cell.nameLabel.text = feedback.member.memberName;
    cell.typeLabel.text = feedback.last_update;
    cell.contentLabel.text = feedback.note;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.deletedIndexPath = indexPath;
//    CDMemberTeZheng *tz = self.tezhengs[indexPath.row];
//    [[CBLoadingView shareLoadingView] show];
//    
//    NSMutableArray *array = [NSMutableArray array];
//    
//    NSArray *subArray = @[[NSNumber numberWithInt:kBSDataDelete],tz.tz_id,@0];
//    [array addObject:subArray];
//    
//    NSDictionary *dict = @{@"extended_ids":array};
//    
//    BSUpdateMemberRequest *updateRequest = [[BSUpdateMemberRequest alloc]initWithMember:self.memebr params:dict];
//    [updateRequest execute];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CDMemberFeedback *feedback = [self.feedbacks objectAtIndex:indexPath.row];
    
    MemberFeedbackDetailViewController *feedbackDetailVC = [[MemberFeedbackDetailViewController alloc] init];
    feedbackDetailVC.feedback = feedback;
    [self.navigationController pushViewController:feedbackDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDMemberFeedback *feedback = [self.feedbacks objectAtIndex:indexPath.row];
    
    self.cell.nameLabel.text = feedback.member.memberName;
    self.cell.contentLabel.text = feedback.note;
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


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
