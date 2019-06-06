//
//  PadHomeViewController.h
//  BornPOS
//
//  Created by XiaXianBing on 15/10/8.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadSideBarViewController.h"
#import "PadRestaurantViewController.h"

@interface PadHomeViewController : ICCommonViewController <PadSideBarViewControllerDelegate, PadRestaurantViewControllerDelegate>

@property(nonatomic)BOOL isShouyintai;

@end
