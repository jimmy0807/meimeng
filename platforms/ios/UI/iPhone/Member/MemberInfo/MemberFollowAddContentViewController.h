//
//  MemberFollowAddContentViewController.h
//  Boss
//
//  Created by lining on 16/5/16.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum kContentType
{
    kContentType_create,
    kContentType_edit
}kContentType;

@interface MemberFollowAddContentViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CDMemberFollowContent *followContent;
@property (strong, nonatomic) CDMemberFollow *follow;
@property (assign, nonatomic) kContentType type;
- (IBAction)hideKeyboard:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *bgBtn;

@end
