//
//  MemberSaleSelectedCardViewController.h
//  Boss
//
//  Created by lining on 16/6/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "SelectedCardCell.h"
@interface MemberSaleSelectedCardViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) CDMember *member;
@property (assign, nonatomic) BOOL isPopDismiss; //present dismiss
@property (strong, nonatomic) CDPosOperate *operate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureBtnPressed:(id)sender;

@end
