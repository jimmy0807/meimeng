//
//  SecondStepView.m
//  meim
//
//  Created by 刘伟 on 2017/11/10.
//

#import "SecondStepView.h"
//#import "meim-Swift.h"
#ifdef meim_dev
#import "meim_dev-Swift.h"
#else
#import "meim-Swift.h"
#endif
@implementation SecondStepView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        ///开始扫描手写本设备
        [[BSWILLManager shared] startScan];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
