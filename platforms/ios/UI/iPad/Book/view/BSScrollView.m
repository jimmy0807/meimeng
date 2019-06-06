//
//  BSScrollView.m
//  Boss
//
//  Created by lining on 15/12/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSScrollView.h"
#import "PadBookColorView.h"
#import "PadBookTouchButton.h"
@implementation BSScrollView

//- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
//{
//    NSLog(@"%s",__FUNCTION__);
//    self.tracingEvnet = true;
//    NSLog(@"用户点击了scroll上的视图%@,是否开始滚动scroll",view);
//    if ([view isKindOfClass:[PadBookTouchButton class]] || [view isKindOfClass:[PadBookColorView class]]) {
//        return YES;
//    }
//    
//    BOOL test = [super touchesShouldBegin:touches withEvent:event inContentView:view];
//    NSLog(@"%d",test);
//    return test;
//    
//}
//
//- (BOOL)touchesShouldCancelInContentView:(UIView *)view
//{
//    NSLog(@"%s",__FUNCTION__);
//    NSLog(@"用户点击的视图 %@",view);
//    return NO;
//    BOOL  test = [super touchesShouldCancelInContentView:view];
//    NSLog(@"%d",test);
//    return YES;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
