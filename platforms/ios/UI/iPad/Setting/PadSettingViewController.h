//
//  PadSettingViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadSettingConstant.h"
#import "PadSettingLeftViewController.h"
#import "PadSettingRightViewController.h"


@interface PadSettingViewController : ICCommonViewController <PadSettingLeftViewControllerDelegate, PadSettingRightViewControllerDelegate>

- (id)initWithViewType:(kPadSettingViewType)type;

@end
