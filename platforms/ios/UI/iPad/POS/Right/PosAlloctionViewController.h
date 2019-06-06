//
//  PosAlloctionViewController.h
//  Boss
//
//  Created by lining on 15/10/20.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface PosAlloctionViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) CDPosOperate *operate;
@property (strong, nonatomic) CDPosBaseProduct *product;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)sureBtnPressed:(UIButton *)sender;

@end
