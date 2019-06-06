//
//  PosOperateDetailViewController.h
//  Boss
//
//  Created by lining on 16/8/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface PosOperateDetailViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) CDPosOperate *operate;
@property (strong, nonatomic) NSNumber *operateID;
@property (assign, nonatomic) BOOL isFromSuccessView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
