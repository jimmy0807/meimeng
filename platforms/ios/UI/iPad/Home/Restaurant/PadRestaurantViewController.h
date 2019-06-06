//
//  PadRestaurantViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-2-23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "BNSegmentedControl.h"
#import "PadCustomerCell.h"
#import "PadRestaurantFloorCell.h"
#import "PadRestaurantCollectionView.h"
#import "PadProjectViewController.h"
#import "HomeCurrentPosTableViewCell.h"

@protocol PadRestaurantViewControllerDelegate <NSObject>

- (void)didBackPadSideBar;

@end

@interface PadRestaurantViewController : ICCommonViewController <BNSegmentedControlDelegate, PadRestaurantCollectionViewDataSource, PadRestaurantCollectionViewDelegate, PadProjectViewControllerDelegate, HomeCurrentPosTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<PadRestaurantViewControllerDelegate> delegate;

- (id)initWithDelegate:(id<PadRestaurantViewControllerDelegate>)delegate;

- (void)didTextFieldEditDone:(UITextField *)textField;

@end
