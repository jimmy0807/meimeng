//
//  MemberPayViewController.m
//  Boss
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSPayModeCell.h"
#import "MemberPayViewController.h"

@interface MemberPayViewController ()<UITableViewDataSource,UITableViewDelegate,BNRightButtonItemDelegate,BSPayModeCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MemberPayViewController

-(double)totalMoney
{
    _totalMoney = 0;
    for(MemberPay *memberPay in self.MemberPays)
    {
        _totalMoney = _totalMoney + [memberPay.payMoney floatValue];
    }
    return _totalMoney;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    [self initTableView];
}

- (void)initTableView
{
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
}

- (void)initNavigationBar
{
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    BNRightButtonItem *item = [[BNRightButtonItem alloc]initWithTitle:@"确认"];
    item.delegate = self;
    self.navigationItem.rightBarButtonItem = item;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%0.2f",self.totalMoney];
}


#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.MemberPays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSPayModeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil)
    {
        cell = [[BSPayModeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.memberPay = self.MemberPays[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma Cell delegate
- (void)cellDidEdit:(BSPayModeCell *)cell
{
    self.navigationItem.title = [NSString stringWithFormat:@"%0.2f",self.totalMoney];
}

#pragma UInavigationItemBarButtonDelegate
-(void)didRightBarButtonItemClick:(id)sender
{
    [self.tableView reloadData];
    if(self.delegate!=nil&&[self.delegate respondsToSelector:@selector(didChoosedPayModeWithAmount:payModes:)])
    {
        [self.delegate didChoosedPayModeWithAmount:@(self.totalMoney) payModes:self.MemberPays];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
