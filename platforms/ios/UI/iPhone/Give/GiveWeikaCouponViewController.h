//
//  GiveWeikaCouponViewController.h
//  Boss
//
//  Created by lining on 16/9/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "GivePeople.h"

@interface GiveWeikaCouponViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CDCardTemplate *cardTemplate;
@property (strong, nonatomic) GivePeople *givePeople;
@property (assign, nonatomic) BOOL isFromMember;
@end
