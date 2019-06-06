//
//  YimeiSignAfterOperationViewController.h
//  ds
//
//  Created by jimmy on 16/11/9.
//
//

#import <UIKit/UIKit.h>
#import "PadMaskView.h"

@interface YimeiSignAfterOperationViewController : ICCommonViewController

@property(nonatomic, strong)NSMutableDictionary* params;
@property(nonatomic, strong)CDPosWashHand* washHand;
@property(nonatomic, copy)void (^YimeiSignAfterOperationViewControllerFinished)(void);
@property(nonatomic, copy)void (^YimeiSignAfterOperationViewControllerCancel)(void);

@end
