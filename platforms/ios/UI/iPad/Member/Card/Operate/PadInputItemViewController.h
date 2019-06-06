//
//  PadReturnItemViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadProjectDetailViewController.h"

@protocol PadInputItemViewControllerDelegate <NSObject>
- (void)didPadInputItemViewControllerConfirmButtonPressed:(NSArray*)itemArray;
@end

@interface PadInputItemViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, PadProjectDetailViewControllerDelegate>

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithMemberCard:(CDMemberCard *)memberCard couponCard:(CDCouponCard*)couponCard;

@property(nonatomic, strong)NSArray* orignalProjectArray;

@property(nonatomic, weak)id<PadInputItemViewControllerDelegate> delegate;

@end
