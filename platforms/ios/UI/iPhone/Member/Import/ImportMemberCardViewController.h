//
//  ImportMemberCardViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/8/18.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "BSCoreDataManager.h"
#import "BSCommonSelectedItemViewController.h"

@interface ImportMemberCardViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate, BSCommonSelectedItemViewControllerDelegate>

@property (nonatomic, assign) BOOL isFromCreateMember;
- (id)initWithMember:(CDMember *)member;

@end
