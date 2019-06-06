//
//  GuadanViewController.m
//  Boss
//
//  Created by lining on 16/7/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GuadanViewController.h"
#import "GuaDanCell.h"
#import "BSFetchPadOrderRequest.h"
#import "OperateManager.h"
#import "ProductProjectMainController.h"

@interface GuadanViewController ()
@property (nonatomic, strong) NSMutableArray *operates;
@property (nonatomic, strong) NSMutableDictionary *cachePicParams;
@end

@implementation GuadanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.title = @"挂单记录";
    
    [self registerNofitificationForMainThread:kBSFetchPadOrderResponse];
    [self registerNofitificationForMainThread:kLocalGuaDanResponse];
    
    BSFetchPadOrderRequest *request = [[BSFetchPadOrderRequest alloc] init];
    [request execute];
}

- (void)reloadData
{
    self.operates = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchLocalPosOperates:@"operate_date"]];
    [self.tableView reloadData];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.operates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuaDanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuaDanCell"];
    if (cell == nil) {
        cell = [GuaDanCell createCell];
    }
    CDPosOperate *operate = [self.operates objectAtIndex:indexPath.row];
    
    [cell.imgView setImageWithName:operate.member.imageName tableName:@"born.member" filter:operate.member.memberID fieldName:@"image" writeDate:operate.member.lastUpdate placeholderString:@"user_default" cacheDictionary:self.cachePicParams completion:nil];
    
    NSString *title;
    if (operate.member) {
       title = operate.member.memberName;
    }
    else
    {
        title = @"散客";
    }
    
    if (operate.handno.length > 0) {
        title = [NSString stringWithFormat:@"%@(%@)",title,operate.handno];
    }
    
    cell.nameLabel.text = title;
    
    cell.dateLabel.text = [operate.operate_date substringToIndex:16];
    cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",operate.amount.floatValue];
    
//    yyyy-mm-dd HH:mm
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        CDPosOperate *operate = [self.operates objectAtIndex:indexPath.row];
        [self.operates removeObjectAtIndex:indexPath.row];
        [[BSCoreDataManager currentManager] deleteObject:operate];
        [[BSCoreDataManager currentManager] save:nil];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CDPosOperate *operate = [self.operates objectAtIndex:indexPath.row];
    ProductProjectMainController *projectMainVC = [[ProductProjectMainController alloc] init];
    projectMainVC.controllerType = ProductControllerType_Sale;
    [OperateManager shareManager].posOperate = operate;
    [self.navigationController pushViewController:projectMainVC animated:YES];
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
