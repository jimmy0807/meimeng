//
//  UIView+SnapShot.h
//  Boss
//
//  Created by XiaXianBing on 15/10/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SnapShot)

- (UIView *)snapshot;
/**
 *  cell截屏(购买动画)
 *  shotView:要截取的view(cell)
 *  toRect:动画最终的大小和位置
 */
- (void)screenCartView:(UIView*)shotView rect:(CGRect)toRect;
@end
