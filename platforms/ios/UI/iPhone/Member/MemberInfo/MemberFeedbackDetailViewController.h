//
//  MemberFeedbackDetailViewController.h
//  Boss
//
//  Created by lining on 16/8/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum kFeedbackDetailType
{
    kFeedbackDetailType_Create,
    kFeedbackDetailType_Detail
    
}kFeedbackDetailType;

@interface MemberFeedbackDetailViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CDMemberFeedback *feedback;
@property (assign, nonatomic) kFeedbackDetailType type;
@end
