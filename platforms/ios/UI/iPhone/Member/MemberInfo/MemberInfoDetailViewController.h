//
//  MemberChangeInfoViewController.h
//  Boss
//
//  Created by lining on 16/3/21.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum MemberInfoType
{
    MemberInfoType_create,
    MemberInfoType_edit,
}MemberInfoType;

@interface MemberInfoDetailViewController : ICCommonViewController
@property (strong, nonatomic) IBOutlet UITableView *infoTableView;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) CDMember *member;
@property (strong, nonatomic) CDStore *store;
@property (assign, nonatomic) MemberInfoType type;
- (IBAction)saveBtnPressed:(id)sender;
@end
