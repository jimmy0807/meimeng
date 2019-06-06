//
//  PadSelectSingleProductViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-16.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"

@protocol PadSelectSingleProductViewControllerDelegate <NSObject>

- (void)didPadSelectSingleProduct:(CDProjectItem *)product;

@end

@interface PadSelectSingleProductViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PadMaskView *maskView;
@property (nonatomic, assign) id<PadSelectSingleProductViewControllerDelegate> delegate;

- (id)initWithDelegate:(id)delegate;

@end
