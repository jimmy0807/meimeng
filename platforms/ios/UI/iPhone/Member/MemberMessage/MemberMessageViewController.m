//
//  MemberMessageViewController.m
//  Boss
//
//  Created by lining on 16/5/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberMessageViewController.h"
#import "MemberMessagePeopleViewController.h"

#import "BSMessageRecordReqeust.h"
#import "MemberTezhengCell.h"

@interface MemberMessageViewController ()<CBRefreshDelegate>
@property (nonatomic, strong) NSArray *messageRecords;
@property (nonatomic, strong) MemberTezhengCell *cell;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CBRefreshState refreshState;
@property (nonatomic, assign) NSInteger startIndex;
@end

@implementation MemberMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.title = @"短信群发";
    
    
    [self registerNofitificationForMainThread:kBSMessageRecordResponse];
    
    [self fetchMessageRecordWithStartIndex:0];
    
    self.cell = [MemberTezhengCell createCell];
    self.cell.contentLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 20;
    
    [self initTableView];
    [self reloadData];
}

- (void) initTableView
{
    self.tableView.refreshDelegate = self;
    self.tableView.canRefresh = true;
    self.tableView.canLoadMore = true;
}

- (void)reloadData
{
    self.messageRecords = [[BSCoreDataManager currentManager] fetchMemberMessageRecords];
    [self.tableView reloadData];
}

- (void)fetchMessageRecordWithStartIndex:(NSInteger)startIdx
{
    if (!self.isLoading) {
        BSMessageRecordReqeust *recodrdRquest = [[BSMessageRecordReqeust alloc] initWithStartIndex:startIdx];
        [recodrdRquest execute];
        self.isLoading = true;
    }
}

#pragma mark - ReceivedNotification
- (void) didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSMessageRecordResponse]) {
        self.isLoading = false;
        [self.tableView stopWithRefreshState:self.refreshState];
        [self reloadData];
    }
}

#pragma mark CBRefreshDelegate Methods
- (void)scrollView:(UIScrollView *)scrollView withRefreshState:(CBRefreshState)state
{
    if (self.isLoading && self.refreshState == state)
    {
        return ;
    }
    
    self.refreshState = state;
    if (state == CBRefreshStateRefresh)
    {
        self.startIndex = 0;
    }
    else if (state == CBRefreshStateLoadMore)
    {
      
        self.startIndex = self.messageRecords.count;
    }
    
    [self fetchMessageRecordWithStartIndex:self.startIndex];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.messageRecords.count;
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
    CDMessageRecord *record = [self.messageRecords objectAtIndex:indexPath.section];
    cell.nameLabel.text = record.send_no;
//    cell.typeLabel.text = @" ";
    cell.contentLabel.text = record.template_content;
    cell.lineImgView.hidden = true;
    cell.dateLabel.text = record.send_date;
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
//    if ([self.delegate respondsToSelector:@selector(didSelectedTezheng:)]) {
//        CDMemberTeZheng *tezheng = self.tezhengs[indexPath.row];
//        [self.delegate didSelectedTezheng:tezheng];
//    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDMessageRecord *record = [self.messageRecords objectAtIndex:indexPath.section];
    self.cell.nameLabel.text = record.send_no;
//    self.cell.typeLabel.text = @" ";
    self.cell.contentLabel.text = record.template_content;
    self.cell.dateLabel.text = record.send_date;
    CGFloat height = [self.cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"height: %.2f",height);
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



#pragma mark - button action
- (IBAction)newQunfaPressed:(UIButton *)sender {
    MemberMessagePeopleViewController *messagePeopleVC = [[MemberMessagePeopleViewController alloc] init];
    messagePeopleVC.store = self.store;
    [self.navigationController pushViewController:messagePeopleVC animated:YES];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - dealloc
- (void)dealloc
{
    [self.tableView cleanCBrefreshView];
}

@end
