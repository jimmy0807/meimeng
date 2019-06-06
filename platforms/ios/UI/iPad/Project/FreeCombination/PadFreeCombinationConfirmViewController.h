//
//  PadFreeCombinationConfirmViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/10/28.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"

@interface PadFreeCombinationConfirmViewController : ICCommonViewController

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithProducts:(NSOrderedSet *)products totalPrice:(CGFloat)totalPrice;

@end
