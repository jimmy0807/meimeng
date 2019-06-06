//
//  GiveProjectCountEditView.h
//  Boss
//
//  Created by lining on 16/9/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponProject.h"

@protocol GiveProjectCountEditDelegate <NSObject>
@optional
- (void)didFinishChanged;
- (void)didDeleteBtnPressed;
@end

@interface GiveProjectCountEditView : UIView

@property (strong, nonatomic) CouponProject *couponProject;
@property (nonatomic, weak) id<GiveProjectCountEditDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIButton *bgBtn;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UIButton *reduceBtn;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


+ (instancetype)createViewAddInSuperView:(UIView *)view;

- (IBAction)bgBtnPressed:(id)sender;

- (IBAction)reduceBtnPressed:(id)sender;
- (IBAction)addBtnPressed:(id)sender;

- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)deleteBtnPressed:(id)sender;
- (IBAction)sureBtnPressed:(id)sender;

- (void)show;
- (void)hide;
@end
