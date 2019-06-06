//
//  YimeiCreateKeshiViewController.h
//  ds
//
//  Created by jimmy on 16/10/25.
//
//

#import <UIKit/UIKit.h>
#import "PadMaskView.h"

@interface YimeiCreateKeshiViewController : ICCommonViewController

@property (nonatomic, weak) PadMaskView *maskView;
@property (nonatomic, weak) CDPosOperate *operate;
@property (nonatomic, copy) void (^keshiSelectFinished)(CDKeShi* first, CDStaff* second);

@end
