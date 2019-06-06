//
//  StaffDetailViewController.h
//  Boss
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "BSCommonSelectedItemViewController.h"
#import "ICCommonViewController+StaffAddInfoKindViewController.h"
#import "ICCommonViewController.h"
#import "CDStaff+CoreDataClass.h"

enum{
    BasicInfoSection = 0,
    OtherInfoSection = 1,
    BasicRoleSection = 2,
    OtherRoleSection = 3,
};

enum{
    ZeroRow   = 0,
    FirstRow  = 1,
    SecondRow = 2,
    ThirdRow  = 3,
};

typedef enum StaffDetailType
{
    StaffDetailType_create,
    StaffDetailType_edit
}StaffDetailType;

@interface StaffDetailViewController : ICCommonViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CDStaff *staff;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, assign) StaffDetailType type;
@property (nonatomic, assign) BOOL isHaveImage;

@end
