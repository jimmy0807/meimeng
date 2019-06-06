//
//  MemberPayAlertFieldView.h
//  Boss
//
//  Created by lining on 16/6/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemberPayAlertFieldViewDelegate <NSObject>
@optional
- (void) didSureBtnPressedWithPayMode:(CDPOSPayMode *)payMode money:(CGFloat)money;
- (void) didChangeBtnPressedWithPayMode:(CDPOSPayMode *)payMode;
@end

@interface MemberPayAlertFieldView : UIView<UITextFieldDelegate>

+ (instancetype)createViewWithPayMode:(CDPOSPayMode *)payMode money:(CGFloat)money delegate:(id<MemberPayAlertFieldViewDelegate>)delegate;

@property (assign, nonatomic) CGFloat payMoney;
@property (weak, nonatomic) id<MemberPayAlertFieldViewDelegate>delegate;
@property (strong, nonatomic) CDPOSPayMode *payMode;
@property (strong, nonatomic) CDMemberCard *card;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *moneyTextFiled;
@property (strong, nonatomic) IBOutlet UIButton *changeBtn;

- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)sureBtnPressed:(id)sender;
- (IBAction)bgBtnPressed:(id)sender;
- (IBAction)changeBtnPressed:(id)sender;

- (void)show;
- (void)showInView:(UIView *)view;
- (void)hide;

@end
