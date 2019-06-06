//
//  MemberAddTezhengViewController.h
//  Boss
//
//  Created by lining on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberAddTezhengViewController : ICCommonViewController
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextView *describleTextView;

@property (strong, nonatomic) CDMember *member;

@end
