//
//  HPatientZutaoSelectViewController.h
//  meim
//
//  Created by 波恩公司 on 2018/4/10.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadProjectDetailViewController.h"

@protocol HPatientZutaoSelectViewControllerDelegate <NSObject>
- (void)didHPatientZutaoSelectViewControllerConfirmButtonPressed:(NSArray*)itemArray;
@end

@interface HPatientZutaoSelectViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, PadProjectDetailViewControllerDelegate>

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithMemberCard:(CDMemberCard *)memberCard couponCard:(CDCouponCard*)couponCard;

@property(nonatomic, strong)NSArray* orignalProjectArray;

@property(nonatomic, weak)id<HPatientZutaoSelectViewControllerDelegate> delegate;

@end

