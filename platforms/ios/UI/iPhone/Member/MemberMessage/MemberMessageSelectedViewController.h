//
//  MemberMessageSelectedViewController.h
//  Boss
//
//  Created by lining on 16/6/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberMessageSelectedViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *peoples;
@property (nonatomic, assign) BOOL qunfa;
@property (nonatomic, strong) CDMember *member;
@end
