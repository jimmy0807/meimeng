//
//  PadSettingInfoViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/12/2.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "PadSettingConstant.h"

@interface PadSettingInfoViewController : ICCommonViewController

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithType:(kPadSettingDetailType)type;

@end
