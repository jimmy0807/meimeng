//
//  MemberChangeCardInfoViewController.h
//  Boss
//
//  Created by lining on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberChangeCardInfoViewController : ICCommonViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)CDMemberCard *memberCard;
@end
