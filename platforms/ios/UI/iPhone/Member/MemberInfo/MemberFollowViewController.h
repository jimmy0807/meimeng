//
//  MemberFollowViewController.h
//  Boss
//
//  Created by lining on 16/5/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberFollowViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *noView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CDMember *member;

@end
