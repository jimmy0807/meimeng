//
//  MemberChangeCardInfoViewController.m
//  Boss
//
//  Created by lining on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberChangeCardInfoViewController.h"
#import "MemberCardInfoDataSource.h"
@interface MemberChangeCardInfoViewController ()<BNRightButtonItemDelegate>
@property (nonatomic, strong) MemberCardInfoDataSource *dataSource;
@end

@implementation MemberChangeCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    BNRightButtonItem *rightItem = [[BNRightButtonItem alloc] initWithTitle:@"保存"];
    rightItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.title = self.memberCard.priceList.name;

    self.dataSource = [[MemberCardInfoDataSource alloc] init];
    self.dataSource.canEdit = true;
    self.dataSource.memberCard = self.memberCard;
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
}


#pragma mark - BNRightButtonItem
- (void)didRightBarButtonItemClick:(id)sender
{
    NSLog(@"保存");
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
