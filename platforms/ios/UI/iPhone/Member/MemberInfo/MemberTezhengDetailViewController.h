//
//  MemberTezhengDetailViewController.h
//  Boss
//
//  Created by lining on 16/4/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum kTezhengType
{
    kTezhengType_create,
    kTezhengType_edit
}kTezhengType;

@interface MemberTezhengDetailViewController : ICCommonViewController

@property (strong, nonatomic) CDMember *member;
@property (assign, nonatomic) kTezhengType type;
@property (assign, nonatomic) CDMemberTeZheng *tezheng;
@property (strong, nonatomic) IBOutlet UITextField *nameFiled;
@property (strong, nonatomic) IBOutlet UITextView *describleTextview;
- (IBAction)selectedBtnPressed:(id)sender;

@end
