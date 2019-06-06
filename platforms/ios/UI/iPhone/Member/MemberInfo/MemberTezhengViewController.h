//
//  MemberTezhengViewController.h
//  Boss
//
//  Created by lining on 16/4/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberTezhengViewController : ICCommonViewController

@property (strong, nonatomic) CDMember *member;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addBtnPressed:(id)sender;
@end
