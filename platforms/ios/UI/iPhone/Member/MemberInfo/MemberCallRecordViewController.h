//
//  MemberCallRecordViewController.h
//  Boss
//
//  Created by lining on 16/5/4.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCallRecordViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CDStore *store;
@end
