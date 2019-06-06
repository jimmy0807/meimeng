//
//  YimeiFumaPhotoView.h
//  meim
//
//  Created by jimmy on 2017/5/25.
//
//

#import <UIKit/UIKit.h>

@interface YimeiFumaPhotoView : UIView

@property(nonatomic, strong)CDPosWashHand* washHand;
+ (void)showWithOperate:(CDPosWashHand*)washHand;

@end
