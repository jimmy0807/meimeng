//
//  LoginViewController.h
//  Boss
//
//  Created by lining on 15/3/30.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "GestureUnlockViewController.h"

@interface LoginViewController : ICCommonViewController <GestureUnlockViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *userTextBg;
@property (strong, nonatomic) IBOutlet UIImageView *pwTextBg;
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *pswTextField;
@property (strong, nonatomic) IBOutlet UIImageView *pwImgView;

- (IBAction)loginBtnPressed:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)rememberPw:(id)sender;

@end
