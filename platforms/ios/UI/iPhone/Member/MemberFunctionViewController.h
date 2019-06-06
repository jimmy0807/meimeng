//
//  MemberFunctionViewController.h
//  Boss
//
//  Created by lining on 16/3/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberFunctionViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) CDMember *member;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtnPressed:(UIButton *)sender;

@end


