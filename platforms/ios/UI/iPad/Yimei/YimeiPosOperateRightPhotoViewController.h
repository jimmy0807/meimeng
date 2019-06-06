//
//  YimeiPosOperateRightPhotoViewController.h
//  ds
//
//  Created by jimmy on 16/11/3.
//
//

#import <UIKit/UIKit.h>

@interface YimeiPosOperateRightPhotoViewController : UIViewController

@property(nonatomic, strong)CDPosWashHand* washHand;

- (void)realoadData;
- (void)scrollToEnd;

- (void)clearUploadingState;
- (void)clearTimer;
- (void)startTimer;

@end
