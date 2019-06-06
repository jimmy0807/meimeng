//
//  MemberCardRepaymentViewController.h
//  Boss
//
//  Created by lining on 16/6/17.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardRepaymentViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) CDMemberCard *memberCard;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureBtnPressed:(id)sender;

@end
