//
//  UIView+SnapShot.m
//  Boss
//
//  Created by XiaXianBing on 15/10/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "UIView+SnapShot.h"

@implementation UIView (SnapShot)

- (UIView *)snapshot
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageView *result = [[UIImageView alloc] initWithImage:image];
        
        return (UIView *)result;
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        return [self snapshotViewAfterScreenUpdates:NO];
    }
    
    return self;
}
- (void)screenCartView:(UIView*)shotView rect:(CGRect)toRect
{

    CGRect rect = [self convertRect:shotView.bounds fromView:shotView];
    UIView *snapshot = [shotView snapshot];
    snapshot.alpha = 1.0;
    snapshot.layer.shadowRadius = 4.0;
    snapshot.layer.shadowOpacity = 0.0;
    snapshot.layer.shadowOffset = CGSizeZero;
    snapshot.layer.shadowPath = [[UIBezierPath bezierPathWithRect:snapshot.layer.bounds] CGPath];
    snapshot.frame = rect;
    [self addSubview:snapshot];
    [UIView animateWithDuration:0.4 animations:^{
        snapshot.frame = toRect;
    } completion:^(BOOL finished) {
        [snapshot removeFromSuperview];
    }];
}

@end
