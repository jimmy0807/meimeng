//
//  GiveWeixinViewController.h
//  Boss
//
//  Created by lining on 16/9/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "GivePeople.h"

@interface GiveWeixinViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CDWXCardTemplate *WXTemplate;


@property (strong, nonatomic) GivePeople *givePeople;
@property (assign, nonatomic) BOOL isFromMember;
@end
