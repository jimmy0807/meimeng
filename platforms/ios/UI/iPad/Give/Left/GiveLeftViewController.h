//
//  GiveLeftViewController.h
//  Boss
//
//  Created by lining on 15/10/29.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@protocol GiveLeftVCDelegate <NSObject>

@optional
- (void) didLeftBtnPressed:(UIButton *)btn;
- (void) didBackBtnPressed:(UIButton *)btn;

@end

@interface GiveLeftViewController : ICCommonViewController

@property (Weak, nonatomic) id<GiveLeftVCDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *backBtnView;
@property (strong, nonatomic) IBOutlet UIImageView *bgImgView;
@property (strong, nonatomic) IBOutlet UIButton *btn;
- (IBAction)backBtnPressed:(id)sender;

- (IBAction)leftBtnPressed:(UIButton *)sender;

@end
