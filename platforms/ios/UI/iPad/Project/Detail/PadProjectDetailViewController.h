//
//  PadProjectDetailViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/11/4.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadProjectDetailItemCell.h"
#import "PadProjectDetailAmountCell.h"
#import "BSReturnItem.h"
#import "PadPickerViewCell.h"
#import "PadDetailInputCell.h"
#import "PadProjectDetailSubRelatedCell.h"
#import "PadProjectDetailAppointmentCell.h"
#import "PadProjectDetailDiscountCell.h"
#import "PadProjectDetailCashDiscountCell.h"

typedef enum kPadProjectDetailType
{
    kPadProjectDetailUseItem,
    kPadProjectDetailProjectItem,
    kPadProjectDetailCurrentCashier,
    kPadProjectDetailReturnItem,
    kPadProjectDetailFreeCombination
}kPadProjectDetailType;

@protocol PadProjectDetailViewControllerDelegate <NSObject>

@optional
- (void)didPadPosProductDelete:(CDPosProduct *)product;
- (void)didPadPosProductConfirm:(CDPosProduct *)product;
- (void)didPadProjectItemDelete:(CDProjectItem *)item;
- (void)didPadProjectItemConfirm:(CDProjectItem *)item quantity:(NSInteger)quantity;

- (void)didUseItemDelete:(CDCurrentUseItem *)useItem;
- (void)didUseItemEditConfirm:(CDCurrentUseItem *)useItem;

- (void)didPadReturnItemDelete:(BSReturnItem *)returnItem;
- (void)didPadReturnItemEditConfirm:(BSReturnItem *)returnItem;

@end

@interface PadProjectDetailViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate, PadProjectDetailAmountCellDelegate, PadDetailInputCellDelegate, PadPickerViewCellDelegate, PadProjectDetailAppointmentCellDelegate>

@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) PadMaskView *maskView;
@property (nonatomic, assign) id<PadProjectDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) CDCouponCard *couponCard;
@property (nonatomic, strong) NSString *viewFrom;

@property(nonatomic)BOOL noTechnician;
///调整卡项修改(新增)
@property(nonatomic)BOOL hiddenProductPrice;///是否隐藏标题栏价格
@property(nonatomic)BOOL isFromProject;
@property(nonatomic)BOOL isFromGift;

@property(nonatomic)BOOL needRefreshCoupon;

- (id)initWithUseItem:(CDCurrentUseItem *)useItem;
- (id)initWithProjectItem:(CDProjectItem *)item quantity:(NSInteger)quantity;
- (id)initWithPosProduct:(CDPosProduct *)product detailType:(kPadProjectDetailType)type;
- (id)initWithReturnItem:(BSReturnItem *)returnItem;

- (void)refreshProductPrice;

@end
