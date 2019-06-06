//
//  CBRotateNavigationController.h
//  CardBag
//
//  Created by jimmy on 13-9-3.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import <UIKit/UIKit.h>


#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define kkBackViewHeight [UIScreen mainScreen].bounds.size.height
#define kkBackViewWidth [UIScreen mainScreen].bounds.size.width

#define kDragBackNotification   @"kDragBackNotification"

#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define iOS8  ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

// 背景视图起始frame.x
#define startXX 0;

@interface RotateNavigationController : UINavigationController
{
    CGFloat startBackViewX;
}
@property(nonatomic, assign) BOOL canDragBack;//默认为特效开启
@property(nonatomic, assign) BOOL isAnimationHiddenNavBar;//默认是YES;
@property(nonatomic, strong) UIPanGestureRecognizer *recognizer;
@end
