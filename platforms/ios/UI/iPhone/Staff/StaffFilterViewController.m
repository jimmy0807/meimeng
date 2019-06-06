//
//  StaffFilterViewController.m
//  Boss
//
//  Created by lining on 15/5/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "StaffFilterViewController.h"
#import "HomeItemsTableViewCell.h"
#import "CBWebViewController.h"

typedef enum FilterItemIndex
{
    StaffFilterItem_Attendance,              //考勤
    StaffFilterItem_MyMoney,                 //提成
    StaffFilterItem_Appointment,             //预约
    StaffFilterItem_Leave,                   //请假
    StaffFilterItem_AttenanceException,      //考勤异常
}FilterItemIndex;



@interface StaffFilterItem : NSObject
@property(nonatomic)SEL function;
@property(nonatomic)FilterItemIndex itemIndex;
@property(nonatomic, strong)NSString* imageName;
@end

@implementation StaffFilterItem
@end


@interface StaffFilterViewController ()<UITableViewDataSource, UITableViewDelegate,HomeItemsTableViewCellDelegate>
{
    CGFloat itemHeight;
    
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *itemsArray;
@end

@implementation StaffFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *backBtnItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    backBtnItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
    self.title = @"员工筛选";
    
    itemHeight = IC_SCREEN_WIDTH / 320 * 84;
    
    [self initData];
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initData
{
    self.itemsArray = [NSMutableArray array];
    
    //考勤
    StaffFilterItem * item = [[StaffFilterItem alloc] init];
    item.imageName = @"HomeTableviewItems_Attendance";
    item.itemIndex = StaffFilterItem_Attendance;
    item.function = @selector(didItemsAttendancePressed:);
    [self.itemsArray addObject:item];
    

    //提成
    item = [[StaffFilterItem alloc] init];
    item.imageName = @"HomeTableviewItems_MyMoney";
    item.itemIndex = StaffFilterItem_MyMoney;
    item.function = @selector(didItemsMyMoneyPressed:);
    [self.itemsArray addObject:item];
    
    //预约
    item = [[StaffFilterItem alloc] init];
    item.imageName = @"HomeTableviewItems_Appointment";
    item.itemIndex = StaffFilterItem_Appointment;
    item.function = @selector(didItemsAppointmentPressed:);
    [self.itemsArray addObject:item];
    
    
    //请假
    item = [[StaffFilterItem alloc] init];
    item.imageName = @"HomeTableviewItems_Leave";
    item.itemIndex = StaffFilterItem_Leave;
    item.function = @selector(didItemsLeavePressed:);
    [self.itemsArray addObject:item];
    
    //考勤异常
    
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = 0xff;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = ceil(self.itemsArray.count/3.0);
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"indentifier";
    HomeItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[HomeItemsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.delegate = self;
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    NSInteger startIdx = indexPath.row * 3;
    for (int i = 0; i < 3; i++) {
        NSInteger index = startIdx + i;
        if (index < self.itemsArray.count) {
            StaffFilterItem *item = [self.itemsArray objectAtIndex:index];
            [cell setItemImage:[UIImage imageNamed:item.imageName] atIndex:i];
        }
        else
        {
             [cell setItemImage:nil atIndex:i];
        }
    }
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return itemHeight;
}


#pragma mark - Item cell Delegate
- (void)didItemButtonPressed:(NSInteger)index cell:(HomeItemsTableViewCell*)cell
{
    if (index >= self.itemsArray.count) {
        return;
    }
    StaffFilterItem *item = self.itemsArray[index];
    SEL selector = item.function;
    if ([self respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:nil]);
    }
}


#pragma mark -

#pragma mark - Filter Items Pressed

//考勤
- (void)didItemsAttendancePressed:(id)sender
{
    [self openUrl:nil];
}

//提成
- (void)didItemsMyMoneyPressed:(id)sender
{
    [self openUrl:nil];
}

//预约
- (void)didItemsAppointmentPressed:(id)sender
{
    [self openUrl:nil];
}

//请假
- (void)didItemsLeavePressed:(id)sender
{
    [self openUrl:nil];
}

//考勤异常
//- (void)didItemsAttendancePressed:(id)sender
//{
//    
//}


-(void)openUrl:(NSString *)urlString
{
    urlString = @"http://www.baidu.com";
    CBWebViewController *webVC = [[CBWebViewController alloc] init];
    webVC.url = urlString;
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - MemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
