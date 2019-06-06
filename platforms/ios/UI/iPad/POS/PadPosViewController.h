//
//  PadPosViewController.h
//  Boss
//
//  Created by lining on 15/10/16.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

#define kReloadPadPOSViewResponse   @"kReloadPadPOSViewResponse"

@interface PadPosViewController : ICCommonViewController
@property(nonatomic, strong) CDPosOperate *operate;
@property(nonatomic, strong) NSNumber *operateID;

@end
