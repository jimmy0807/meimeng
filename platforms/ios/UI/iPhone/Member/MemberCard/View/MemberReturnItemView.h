//
//  MemberReturnItemView.h
//  Boss
//
//  Created by lining on 16/6/16.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSReturnItem.h"

@protocol MemberReturnItemViewDelegate <NSObject>
@optional
- (void)didFinishChanged;

@end

@interface MemberReturnItemView : UIView

+ (instancetype)createViewAddInSuperView:(UIView *)view;

@property (nonatomic, strong) BSReturnItem *returnItem;
@property (nonatomic, weak) id<MemberReturnItemViewDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *moneyTextField;
@property (strong, nonatomic) IBOutlet UILabel *maxCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIButton *reduceBtn;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (strong, nonatomic) IBOutlet UIButton *bgBtn;

- (IBAction)bgBtnPressed:(id)sender;

- (IBAction)reduceBtnPressed:(id)sender;
- (IBAction)addBtnPressed:(id)sender;

- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)deleteBtnPressed:(id)sender;
- (IBAction)sureBtnPressed:(id)sender;

//- (void)initView;
- (void)show;
- (void)hide;

@end
