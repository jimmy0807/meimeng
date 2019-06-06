//
//  StaffAddViewController+StaffAddInfoKindViewController.m
//  Boss
//
//  Created by mac on 15/7/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController+StaffAddInfoKindViewController.h"

@implementation ICCommonViewController (StaffAddInfoKindViewController)
-(void)pushViewControllerWithIndexPath:(NSIndexPath *)indexPath withISLogin:(BOOL)is_login
{
    if(indexPath.section==OtherInfoSection&&indexPath.row==ThirdRow)
    {
        StaffAddShopViewController *addShop = [[StaffAddShopViewController alloc]initWithNibName:NIBCT(@"StaffAddShopViewController") bundle:nil];
        [self.navigationController pushViewController:addShop animated:YES];
    }else if(indexPath.section==OtherRoleSection&&indexPath.row==ZeroRow)
    {
        StaffCreateDepartmentViewController *createDepartment = [[StaffCreateDepartmentViewController alloc]initWithNibName:NIBCT(@"StaffCreateDepartmentViewController") bundle:nil];
        [self.navigationController pushViewController:createDepartment animated:YES];
    }else if(indexPath.section==OtherRoleSection&&indexPath.row==FirstRow)
    {
        StaffCreateJobViewController *createJob = [[StaffCreateJobViewController alloc]initWithNibName:NIBCT(@"StaffCreateJobViewController") bundle:nil];
        [self.navigationController pushViewController:createJob animated:YES];
    }
}
@end
