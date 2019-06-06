//
//  MemberQinyouViewController.h
//  Boss
//
//  Created by lining on 16/4/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberQinyouViewController : ICCommonViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addBtnPressed:(id)sender;
@property (nonatomic, strong) CDMember *member;
@end
