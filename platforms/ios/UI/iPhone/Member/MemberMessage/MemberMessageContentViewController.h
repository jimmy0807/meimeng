//
//  MemberMessageContentViewController.h
//  Boss
//
//  Created by lining on 16/5/27.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberMessageContentViewController : ICCommonViewController
@property (nonatomic, strong) CDMessageTemplate *messageTmplate;
@property (nonatomic, strong) NSArray *peoples;
@property (nonatomic, assign) BOOL qunfa;
@property (nonatomic, strong) CDMember *member;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)sendBtnPressed:(id)sender;

@end

@interface MessageItem : NSObject
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) BOOL needInput;

@end
