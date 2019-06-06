//
//  HPatientRecipeTempletViewController.h
//  meim
//
//  Created by 波恩公司 on 2017/9/21.
//
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadProjectDetailViewController.h"

@protocol HPatientRecipeTempletViewControllerDelegate <NSObject>
- (void)didHPatientRecipeTempletViewControllerConfirmButtonPressed:(NSArray*)itemArray;
@end

@interface HPatientRecipeTempletViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, PadProjectDetailViewControllerDelegate>

@property (nonatomic, strong) PadMaskView *maskView;
@property (nonatomic, strong) NSString *type;

- (id)initWithMemberCard:(CDMemberCard *)memberCard couponCard:(CDCouponCard*)couponCard;
- (id)initWenZhenWithMemberCard:(CDMemberCard *)memberCard couponCard:(CDCouponCard*)couponCard;


@property(nonatomic, strong)NSArray* orignalProjectArray;
@property (nonatomic, strong) CDPosOperate *posOperate;

@property(nonatomic, weak)id<HPatientRecipeTempletViewControllerDelegate> delegate;

@end
