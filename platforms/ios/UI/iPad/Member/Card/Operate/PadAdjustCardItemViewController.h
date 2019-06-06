//
//  PadAdjustCardItemViewController.h
//  meim
//
//  Created by jimmy on 17/2/8.
//
//

#import <UIKit/UIKit.h>
#import "PadMaskView.h"

@interface PadAdjustCardItemViewController : ICCommonViewController

@property (nonatomic, strong) PadMaskView *maskView;
@property (nonatomic, strong) CDMemberCard* memberCard;
@end
