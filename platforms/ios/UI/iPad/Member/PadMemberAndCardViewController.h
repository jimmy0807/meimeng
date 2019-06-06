//
//  PadMemberAndCardViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/11/11.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadCardOperateView.h"
#import "PadProjectConstant.h"
#import "PadMemberSelectViewController.h"
#import "PadCardSelectViewController.h"

#define kMemberNavigationBackToBook @"kMemberNavigationBackToBook"

#define kPadMemberAndCardViewWidth      300.0

@interface PadMemberAndCardViewController : ICCommonViewController <PadMemberSelectViewControllerDelegate, PadCardSelectViewControllerDelegate, PadCardOperateViewDelegate>

@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) CDCouponCard *couponCard;
@property (nonatomic, weak) UINavigationController *rootNaviationVC;
@property (nonatomic, strong) NSString *keyword;

- (id)initWithViewType:(kPadMemberAndCardViewType)viewType;
- (id)initWithMember:(CDMember *)member memberCard:(CDMemberCard *)memberCard couponCard:(CDCouponCard *)couponCard;


- (void)didTextFieldEditDone:(UITextField *)textField;

@end
