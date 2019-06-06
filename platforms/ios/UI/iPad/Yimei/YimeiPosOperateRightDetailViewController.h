//
//  YimeiPosOperateRightDetailViewController.h
//  ds
//
//  Created by jimmy on 16/11/1.
//
//

#import <UIKit/UIKit.h>

@protocol YimeiPosOperateRightDetailViewControllerDelegate <NSObject>
@end

@interface YimeiPosOperateRightDetailViewController : UIViewController

@property(nonatomic, weak)id<YimeiPosOperateRightDetailViewControllerDelegate> delegate;
@property(nonatomic, strong)CDPosWashHand* washHand;
@property(nonatomic, strong)UIView* maskView;

- (void)realoadData;
- (void)scrollToEnd;
- (void)removeNoti;

- (void)clearUploadingState;
- (void)clearTimer;
- (void)startTimer;

@end
