//
//  MemberCardExchangeViewController.h
//  Boss
//  卡交换
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCardExchangeViewController : ICCommonViewController
@property (strong, nonatomic) CDMemberCard *card;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureBtnPressed:(id)sender;

@end
