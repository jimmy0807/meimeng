//
//  BaseStepView.m
//  meim
//
//  Created by 刘伟 on 2017/11/11.
//

#import "BaseStepView.h"

@implementation BaseStepView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)nextStep{
    CGFloat newX = -self.frame.size.width;
    [UIView animateWithDuration:0.8 animations:^{
        self.frame = CGRectMake(newX, 75, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
