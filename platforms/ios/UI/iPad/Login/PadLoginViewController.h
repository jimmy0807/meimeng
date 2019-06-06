//
//  PadLoginViewController.h
//  Boss
//
//  Created by lining on 15/10/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface PadLoginViewController : ICCommonViewController
@property (strong, nonatomic) IBOutlet UIImageView *posImagView;
@property (strong, nonatomic) IBOutlet UILabel *posLabel;
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;
@property (strong, nonatomic) IBOutlet UIImageView *eyeImgView;

- (IBAction)eyeBtnPressed:(id)sender;

- (IBAction)loginBtnPressed:(id)sender;

@end
