//
//  YimeiSignBeforeOperationViewController.h
//  ds
//
//  Created by jimmy on 16/10/27.
//
//

#import <UIKit/UIKit.h>
#import "PadMaskView.h"

@interface YimeiSignBeforeOperationViewController : ICCommonViewController

@property(nonatomic, strong)CDPosOperate* operate;
@property(nonatomic, copy)void (^YimeiSignBeforeOperationViewControllerFinished)(void);

@end
