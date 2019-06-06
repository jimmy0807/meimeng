//
//  StaffAddViewController+StaffAddInfoKindViewController.h
//  Boss
//
//  Created by mac on 15/7/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "StaffCreateJobViewController.h"
#import "StaffCreateDepartmentViewController.h"
#import "StaffAddShopViewController.h"
#import "StaffDetailViewController.h"
@interface ICCommonViewController (StaffAddInfoKindViewController)
-(void)pushViewControllerWithIndexPath:(NSIndexPath *)indexPath withISLogin:(BOOL)is_login;
@end
