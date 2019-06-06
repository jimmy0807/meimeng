//
//  MemberCardProjectRecedeViewController.m
//  Boss
//  退项目
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardProjectRecedeViewController.h"
#import "CardRecedeProjectCell.h"
#import "BSReturnItem.h"
#import "CardReturnItemCell.h"
#import "MemberReturnItemView.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "BSMemberCardOperateRequest.h"

@interface MemberCardProjectRecedeViewController ()<MemberReturnItemViewDelegate>
@property (nonatomic, strong) NSMutableArray *returnItems; //可退的项目
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexPath; //当前选中的indexPath
@property (nonatomic, strong)  MemberReturnItemView *returnItemView;
@end

@implementation MemberCardProjectRecedeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    self.navigationItem.title = @"退项目";
    [self initData];
    
    self.returnItemView = [MemberReturnItemView createViewAddInSuperView:self.view];
    self.returnItemView.delegate = self;
    
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
}

- (void)initData
{
    self.returnItems = [NSMutableArray array];
    for (CDMemberCardProject *cardProject in self.memberCard.projects) {
        if (cardProject.remainQty.integerValue > 0) {
            BSReturnItem *returnItem = [[BSReturnItem alloc] init];
            returnItem.returnCount = 0; //以前默认1
            returnItem.returnAmount = 0; //以前cardProject.projectPriceUnit.floatValue
            returnItem.cardProject = cardProject;
            [self.returnItems addObject:returnItem];
        }
    }
}

#pragma mark - NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] == 0)
        {
            [[[CBMessageView alloc] initWithTitle:@"退项目成功"] show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}

#pragma mark - MemberReturnItemViewDelegate
- (void)didFinishChanged
{
    [self.tableView reloadRowsAtIndexPaths:@[self.currentSelectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.currentSelectedIndexPath = nil;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.returnItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CardReturnItemCell";
    CardReturnItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [CardReturnItemCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BSReturnItem *returnItem = [self.returnItems objectAtIndex:indexPath.row];
    cell.nameLabel.text = returnItem.cardProject.projectName;
    cell.countLabel.text = [NSString stringWithFormat:@"总数量x%d  数量(退):x%d",returnItem.cardProject.remainQty.integerValue,returnItem.returnCount];
    cell.amountLabel.text = [NSString stringWithFormat:@"退回卡内金额:￥%.2f",returnItem.returnAmount];
    cell.arrowImgView.highlighted = false;
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
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
    self.currentSelectedIndexPath  = indexPath;
    CardReturnItemCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.arrowImgView.highlighted = true;
    
    BSReturnItem *returnItem = [self.returnItems objectAtIndex:indexPath.row];
    self.returnItemView.returnItem = returnItem;
    
    [self.returnItemView show];
    
}

#pragma mark - button action
- (IBAction)sureBtnPressed:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.memberCard.cardID forKey:@"card_id"];
    NSMutableArray *returnLineIds = [NSMutableArray array];
    for (int i = 0; i < self.returnItems.count; i++)
    {
        BSReturnItem *returnItem = [self.returnItems objectAtIndex:i];
        if (returnItem.returnCount == 0 && returnItem.returnAmount - 0.01 < 0) {
            continue;
        }
        NSArray *array = @[@(0), @(NO), @{@"lines_id":returnItem.cardProject.productLineID, @"product_id":returnItem.cardProject.projectID, @"available_qty":returnItem.cardProject.remainQty, @"exchange_qty":@(returnItem.returnCount), @"exchange_amount":@(returnItem.returnAmount)}];
        [returnLineIds addObject:array];
    }
    
    [params setObject:returnLineIds forKey:@"exchange_line_ids"];
    [[CBLoadingView shareLoadingView] show];
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateExchange];
    [request execute];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
