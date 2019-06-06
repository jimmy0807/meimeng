//
//  MemberViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/8/19.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "StaffCell.h"
#import "CBRefreshView.h"

@interface MemberViewController : ICCommonViewController <UITextFieldDelegate, StaffCellDelegate, CBRefreshDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isCashier; //是否是从收银来

- (id)initWithStore:(CDStore *)store;

@end
