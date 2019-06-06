//
//  MemberCardProjectRecedeViewController.h
//  Boss
//  退项目
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardProjectRecedeViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)sureBtnPressed:(id)sender;
@end
