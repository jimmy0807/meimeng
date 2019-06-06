//
//  PosOperateAssignViewController.h
//  Boss
//
//  Created by lining on 16/9/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface PosOperateAssignViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) CDPosOperate *operate;
@property (strong, nonatomic) CDPosBaseProduct *product;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
