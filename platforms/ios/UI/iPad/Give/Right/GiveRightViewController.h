//
//  GiveRightViewController.h
//  Boss
//
//  Created by lining on 15/10/29.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@protocol GiveRightVCDelegate <NSObject>
@optional
- (void)didRightBtnPressed:(UIButton *)btn;
@end

@interface GiveRightViewController : ICCommonViewController

@property (Weak, nonatomic) id<GiveRightVCDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) IBOutlet UIImageView *bgImgView;
- (IBAction)rightBtnPressed:(UIButton *)sender;

@end
