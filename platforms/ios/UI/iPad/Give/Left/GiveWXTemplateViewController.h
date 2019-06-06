//
//  GiveWXTemplateViewController.h
//  Boss
//
//  Created by lining on 16/6/2.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface GiveWXTemplateViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UINavigationController *rootNavigationVC;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) CDMember *member;
- (IBAction)sureBtnPressed:(id)sender;

@end
