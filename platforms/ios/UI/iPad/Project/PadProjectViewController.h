//
//  PadProjectViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/10/8.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadProjectNaviView.h"
#import "PadProjectView.h"
#import "PadProjectHeaderView.h"
#import "PadProjectKeyboardView.h"
#import "PadProjectUserSelectView.h"
#import "PadProjectSideView.h"
#import "PadCategoryViewController.h"
#import "PadProjectTypeViewController.h"
#import "PadCategoryViewController.h"
#import "PadSubCategoryViewController.h"
#import "PadProjectDetailViewController.h"
#import "PadReserveViewController.h"

@protocol PadProjectViewControllerDelegate <NSObject>
- (void)didPadProjectViewControllerMenuButtonPressed:(CDPosOperate*)operate;
@end

@interface PadProjectViewController : ICCommonViewController <PadProjectViewDelegate, PadProjectNaviViewDelegate, PadProjectSideViewDelegate, PadProjectUserSelectViewDelegate, PadProjectTypeViewControllerDelegate, PadCategoryViewControllerDelegate, PadSubCategoryViewControllerDelegate, PadProjectDetailViewControllerDelegate, PadProjectHeaderViewDelegate, PadProjectKeyboardViewDelegate, PadReserveViewControllerDelegate, UIAlertViewDelegate>

- (id)initWithHandNo:(NSString *)handno memberCard:(CDMemberCard *)memberCard;
- (id)initWithTakeoutWithHandNo:(NSString *)handno;
- (id)initWithRestaurant:(CDRestaurantTable *)table personCount:(NSInteger)PersonCount occupyID:(NSNumber*)occupyID book:(CDBook *)book;
- (id)initWithBook:(CDBook *)book handno:(NSString *)handno;
- (id)initWithMemberCard:(CDMemberCard * )memberCard handno:(NSString *)handno;
- (instancetype _Nonnull)initWithMemberCard:(CDMemberCard * _Nullable)memberCard couponCard:(CDCouponCard* _Nullable)couponCard handno:(NSString * _Nullable)handno;
- (id)initWithPosOperate:(CDPosOperate *)posOperate;
- (void)didPadProjectViewItemClick:(NSObject *)object;
- (void)refreshItems;

@property(nonatomic, weak)id<PadProjectViewControllerDelegate> delegate;

- (void)didTextFieldEditDone:(UITextField *)textField;

@property (nonatomic) BOOL createYimeiNewMember;
@property (nonatomic) BOOL canChangeMember;
@property (nonatomic) BOOL isGuadan;
@property (nonatomic) BOOL isGuadanAddItem;

@property(nonatomic, strong)NSNumber* orignalOperateID;
@property(nonatomic, strong)CDHGuadan* guadan;

@end
