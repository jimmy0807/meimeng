//
//  MemberMessageViewController.h
//  Boss
//
//  Created by lining on 16/5/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberMessageViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) CDStore *store;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
