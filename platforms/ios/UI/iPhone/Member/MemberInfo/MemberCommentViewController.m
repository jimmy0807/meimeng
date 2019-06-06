//
//  MemberCommentViewController.m
//  Boss
//
//  Created by lining on 16/5/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCommentViewController.h"
#import "BSFetchCommentRequest.h"
#import "BSFetchCommentTypeRequest.h"
#import "CBLoadingView.h"
#import "MemberTezhengCell.h"

@interface MemberCommentViewController ()
{
    NSInteger requestCount;
}
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) MemberTezhengCell *cell;
@end

@implementation MemberCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.title = @"评论";
    
    [self registerNofitificationForMainThread:kBSFetchCommentResponse];
    [self registerNofitificationForMainThread:kBSFetchCommentTypeResponse];
    
    self.cell = [MemberTezhengCell createCell];
    self.cell.contentLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 20;
    
    [self reloadData];
    [self sendRequest];
}

- (void)reloadData
{
    self.comments = [[BSCoreDataManager currentManager] fetchCommentsWithMember:self.member];
    if (self.comments.count == 0) {
        self.noView.hidden = false;
        self.tableView.hidden = true;
    }
    else
    {
        self.noView.hidden = true;
        self.tableView.hidden = false;
        [self.tableView reloadData];
    }
    
}

#pragma mark - sendRequest
- (void)sendRequest
{
    BSFetchCommentRequest *commentRequest = [[BSFetchCommentRequest alloc] init];
    commentRequest.member = self.member;
    [commentRequest execute];
    requestCount ++;
    
    BSFetchCommentTypeRequest *commentTypeRequest = [[BSFetchCommentTypeRequest alloc] init];
    [commentTypeRequest execute];
    requestCount ++;
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    requestCount --;
    if (requestCount == 0) {
        [self reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.comments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberTezhengCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberTezhengCell"];
    if (cell == nil) {
        cell = [MemberTezhengCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CDComment *comment = [self.comments objectAtIndex:indexPath.section];
    [self cell:cell comment:comment];
    return cell;
}

- (void)cell:(MemberTezhengCell *)cell comment:(CDComment *)comment
{
    NSString *type = [[BSCoreDataManager currentManager] operateType:comment.operate_type];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",comment.operate_name,type];
    NSMutableString *commentContents = [NSMutableString string];
    NSString *commentTypeStr;
    for (CDCommentType *commentType in comment.commentTypes.array) {
        if (commentContents.length == 0) {
            [commentContents appendString:commentType.name];
        }
        else
        {
            [commentContents appendFormat:@", %@",commentType.name];
        }
        if (commentTypeStr.length == 0) {
            commentTypeStr = commentType.type;
        }
    }
    if ([commentTypeStr isEqualToString:@"good"]) {
        commentTypeStr = @"好评";
    }
    else
    {
        commentTypeStr = @"差评";
    }
    cell.typeLabel.text = commentTypeStr;
    cell.contentLabel.text = commentContents;
    cell.dateLabel.text = [comment.date substringToIndex:10];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDComment *comment = [self.comments objectAtIndex:indexPath.section];
    
    [self cell:self.cell comment:comment];
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
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
