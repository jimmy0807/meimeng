//
//  MemberCardShopCartViewController.h
//  Boss
//
//  Created by lining on 16/6/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "OperateManager.h"


@interface MemberCardShopCartViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) OperateManager *operateManager;



@end
