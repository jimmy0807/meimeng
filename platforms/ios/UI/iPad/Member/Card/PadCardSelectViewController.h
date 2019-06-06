//
//  PadCardSelectViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/10/21.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadProjectConstant.h"

@protocol PadCardSelectViewControllerDelegate <NSObject>

- (void)didCardSelectCancel:(BOOL)isMemberSelected;
- (void)didCardSelectMemberCard:(CDMemberCard *)memberCard couponCard:(CDCouponCard *)couponCard toOrder:(BOOL)toOrder;

@end

@interface PadCardSelectViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL isMemberSelected;
@property (nonatomic, assign) id<PadCardSelectViewControllerDelegate> delegate;
@property (nonatomic, weak) UINavigationController *rootNavigationVC;
- (id)initWithMember:(CDMember *)member viewType:(kPadMemberAndCardViewType)viewType;
- (id)initWithMember:(CDMember *)member memberCard:(CDMemberCard *)memberCard couponCard:(CDCouponCard *)couponCard;

@end
