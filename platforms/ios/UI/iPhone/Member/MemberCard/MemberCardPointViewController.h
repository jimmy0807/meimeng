//
//  MemberCardPointViewController.h
//  Boss
//
//  Created by lining on 16/5/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardPointViewController : ICCommonViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CDMemberCard *card;
@end
