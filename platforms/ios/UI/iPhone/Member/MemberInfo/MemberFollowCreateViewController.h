//
//  MemberFollowCreateViewController.h
//  Boss
//
//  Created by lining on 16/5/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberFollowCreateViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) CDMember *member;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomMonthViewConstraint;
@property (strong, nonatomic) IBOutlet UIView *monthView;
@property (strong, nonatomic) IBOutlet UITableView *monthTableView;
- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)selecteBtnPressed:(id)sender;

@end
