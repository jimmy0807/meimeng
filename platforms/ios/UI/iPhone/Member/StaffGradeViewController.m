//
//  StaffGradeViewController.m
//  Boss
//
//  Created by mac on 15/8/13.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "BSFetchStaffWithGradePlan.h"
#import "StaffGradeViewController.h"

@interface StaffGradeViewController ()

@end

@implementation StaffGradeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    [self initStaff];
    // Do any additional setup after loading the view from its nib.
}

- (void)initNavigationBar
{
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = LS(@"员工业绩");
}

- (void)initStaff
{
    BSFetchStaffWithGradePlan *request = [[BSFetchStaffWithGradePlan alloc]init];
    [request execute];
}
@end
