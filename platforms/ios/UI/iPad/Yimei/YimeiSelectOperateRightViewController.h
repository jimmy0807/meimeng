//
//  YimeiSelectOperateRightViewController.h
//  ds
//
//  Created by jimmy on 16/11/8.
//
//

#import <UIKit/UIKit.h>

@interface YimeiSelectOperateRightViewController : ICCommonViewController

@property(nonatomic, strong)CDPosWashHand* washHand;
@property(nonatomic, copy)void (^writeBinglikaButtonPressed)(void);
- (void)removeNoti;

@end
