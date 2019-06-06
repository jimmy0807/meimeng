//
//  MemberCardUpgradeViewController.h
//  Boss
//  卡升级
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "MemberCardOperateView.h"

@interface MemberCardUpgradeViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) CDMemberCard *card;
@property (nonatomic, assign) kPadMemberCardOperateType operateType;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextBtnPressed:(id)sender;

@end
