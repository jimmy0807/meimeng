//
//  MemberMessageSelectedViewController.m
//  Boss
//
//  Created by lining on 16/6/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberMessageSelectedViewController.h"
#import "BSFetchMessageTemplateRequest.h"
#import "MemberMessageTemplateSelectedCell.h"
#import "BSSendMessageRequest.h"
#import "MemberMessageContentViewController.h"
#import "UILabel+LineSpace.h"

@interface MemberMessageSelectedViewController ()
@property (nonatomic, strong) NSArray *templateItems;
@property (nonatomic, strong) MemberMessageTemplateSelectedCell *cell;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@end

@implementation MemberMessageSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *leftBtnItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftBtnItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    self.navigationItem.title = @"选择短信模板";
    
    self.currentSelectedIndex = -1;
    self.cell = [MemberMessageTemplateSelectedCell createCell];
    self.cell.contentLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 67;
    [self registerNofitificationForMainThread:kBSFetchMessageTemplateResponse];
    [self sendRequest];
    [self reloadData];
}

#pragma mark - sendRequest
- (void)sendRequest
{
    BSFetchMessageTemplateRequest *request = [[BSFetchMessageTemplateRequest alloc] initWithType:self.type];
    [request execute];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [self reloadData];
}

#pragma mark - init data
- (void)reloadData
{
    self.templateItems = [[BSCoreDataManager currentManager] fetchMemberMessagesWithType:self.type];
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.templateItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberMessageTemplateSelectedCell *templateSelectedCell = [tableView dequeueReusableCellWithIdentifier:@"MemberMessageTemplateSelectedCell"];
    if (templateSelectedCell == nil) {
        templateSelectedCell = [MemberMessageTemplateSelectedCell createCell];
        templateSelectedCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CDMessageTemplate *template = [self.templateItems objectAtIndex:indexPath.row];
//    templateSelectedCell.contentLabel.text = template.template_content;
    [templateSelectedCell.contentLabel setText:template.template_content lineSpace:6];
    
    if (self.currentSelectedIndex == indexPath.section) {
        templateSelectedCell.selectedImgView.highlighted = true;
    }
    else
    {
        templateSelectedCell.selectedImgView.highlighted = false;
    }
    return templateSelectedCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDMessageTemplate *template = [self.templateItems objectAtIndex:indexPath.section];
//    NSLog(@"%@",template.template_content);
//    self.cell.contentLabel.text = template.template_content;
    [self.cell.contentLabel setText:template.template_content lineSpace:6];
    CGFloat height = [self.cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
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
    if (self.currentSelectedIndex == indexPath.section) {
//        return;
    }
    self.currentSelectedIndex = indexPath.section;
    
    [self.tableView reloadData];
    
    CDMessageTemplate *messageTemplate = [self.templateItems objectAtIndex:indexPath.section];
    
    MemberMessageContentViewController *messageContentVC = [[MemberMessageContentViewController alloc] init];
    messageContentVC.messageTmplate = messageTemplate;
    messageContentVC.peoples = self.peoples;
    messageContentVC.qunfa = self.qunfa;
    messageContentVC.member = self.member;
    [self.navigationController pushViewController:messageContentVC animated:YES];
    
    return;
   
    
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
