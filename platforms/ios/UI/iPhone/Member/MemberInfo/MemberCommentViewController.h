//
//  MemberCommentViewController.h
//  Boss
//
//  Created by lining on 16/5/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberCommentViewController : ICCommonViewController
@property (nonatomic, strong) CDMember *member;
@property (strong, nonatomic) IBOutlet UIView *noView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
