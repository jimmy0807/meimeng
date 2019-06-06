//
//  DailyMenuOperateViewController.m
//  Boss
//
//  Created by mac on 15/8/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "StaffGradeViewController.h"
#import "DailyOperateMenu.h"
#import "MenuOperateCell.h"
#import "BSFetchMenuOperateRequest.h"
#import "DailyMenuOperateViewController.h"

@interface DailyMenuOperateViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DailyMenuOperateViewController
-(NSArray *)tableViewData
{
    if(_tableViewData==nil)
    {
        return _tableViewData = [[NSArray alloc]init];
    }else
    {
        return _tableViewData;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNofitificationForMainThread:kBSDailyOperateMenuResponse];
    [self initNavigationBar];
    [self initData];
    [self initTableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initNavigationBar
{
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = LS(@"日常操作单");
}

- (void)initData
{
    BSFetchMenuOperateRequest *request = [[BSFetchMenuOperateRequest alloc]init];
    [request execute];
}

- (void)initTableView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
    self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark - HTTP Response
- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if([notification.name isEqualToString:kBSDailyOperateMenuResponse])
    {
        if([[notification.userInfo objectForKey:@"rc"] integerValue]==0)
        {
            self.tableViewData = [notification.userInfo objectForKey:@"data"];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITableViewDelegate and UITableViewDataSourc
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewData.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   MenuOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MenuOperateCell" owner:self options:nil] lastObject];
    }
    DailyOperateMenu *menu = self.tableViewData[indexPath.row];
    cell.nameLabel.text = menu.name;
    cell.cardNoLabel.text = menu.cardNo;
    cell.operateLabel.text = menu.operateUser;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffGradeViewController *staffGrade = [[StaffGradeViewController alloc]initWithNibName:NIBCT(@"StaffGradeViewController") bundle:nil];
    staffGrade.menu = self.tableViewData[indexPath.row];
    [self.navigationController pushViewController:staffGrade animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
