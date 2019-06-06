//
//  MemberCardPayViewController.h
//  Boss
//
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "MemberCardOperateView.h"

@interface MemberCardPayViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)didSureBtnPressed:(UIButton *)sender;
@property (assign, nonatomic) kPadMemberCardOperateType operateType;
@property (strong, nonatomic) CDMemberCard *card;
@property (assign, nonatomic) CGFloat amount;
@end
