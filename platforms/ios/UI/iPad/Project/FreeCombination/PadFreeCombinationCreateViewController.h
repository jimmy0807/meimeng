//
//  PadFreeCombinationCreateViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/10/27.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadProjectTypeViewController.h"
#import "PadProjectDetailViewController.h"

@interface PadFreeCombinationCreateViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate, PadProjectTypeViewControllerDelegate, PadProjectDetailViewControllerDelegate>

@property (nonatomic, strong) PadMaskView *maskView;

@end
