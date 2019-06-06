//
//  MemberAddViewController.m
//  Boss
//
//  Created by lining on 16/4/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberAddViewController.h"
#import "MemberInfoDataSource.h"

@interface MemberAddViewController ()
@property (nonatomic, strong) MemberInfoDataSource *dataSource;
@end

@implementation MemberAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.title = @"新增会员";
    

    self.dataSource = [[MemberInfoDataSource alloc] initWithMember:nil tableView:self.tableView];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
