//
//  AllocationHeadView.h
//  Boss
//
//  Created by lining on 15/10/21.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllocationHeadViewDelegate <NSObject>
@optional
- (void) didGiveBtnPressed;
@end

@interface AllocationHeadView : UIView

+ (instancetype)createView;

@property (Weak, nonatomic) id<AllocationHeadViewDelegate> delegate;
@property (assign, nonatomic) bool need_give;
@property (strong, nonatomic) IBOutlet UIImageView *head_top_bg;
@property (strong, nonatomic) IBOutlet UIImageView *head_bottom_bg;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIImageView *swithImgView;

- (IBAction)switchBtnPressed:(UIButton *)sender;
- (IBAction)giveBtnPressed:(UIButton *)sender;

@end
