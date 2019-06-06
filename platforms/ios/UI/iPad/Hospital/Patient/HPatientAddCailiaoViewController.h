//
//  HPatientAddCailiaoViewController.h
//  meim
//
//  Created by 波恩公司 on 2018/7/25.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadProjectDetailViewController.h"

@protocol HPatientAddCailiaoViewControllerDelegate <NSObject>
- (void)didHPatientAddCailiaoViewControllerConfirmButtonPressed:(NSArray*)itemArray;
@end

@interface HPatientAddCailiaoViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, PadProjectDetailViewControllerDelegate>

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithMemberCard:(CDMemberCard *)memberCard couponCard:(CDCouponCard*)couponCard;

@property(nonatomic, strong)NSArray* orignalProjectArray;

@property(nonatomic, weak)id<HPatientAddCailiaoViewControllerDelegate> delegate;

@end
