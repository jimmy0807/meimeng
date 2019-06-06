//
//  WillSplitView.m
//  meim
//
//  Created by 刘伟 on 2017/12/19.
//

#import "WillSplitView.h"

@implementation WillSplitView

-(instancetype)initWithFrame:(CGRect)frame AndBezierPathArr:(NSArray *)bezierpathArr {
    self = [super initWithFrame:frame];
    if (self) {
        self.bezierpathArr = bezierpathArr;
//        self.mobanImageV = [[UIImageView alloc]initWithFrame:self.bounds];
//        self.mobanImageV.image = [UIImage imageNamed:@"ink_moban2.jpg"];
//        [self addSubview:self.mobanImageV];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;

}

//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//    }
//    return self;
//}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    NSLog(@"WillSplitView -drawRect %d",self.bezierpathArr.count);
    for (UIBezierPath *path in self.bezierpathArr) {
        [[UIColor blackColor] set];
        path.lineWidth = 1;
        path.lineJoinStyle = 1;
        path.lineCapStyle = kCGLineCapRound;
        path.flatness = 3;
        //[path strokeWithBlendMode:kCGBlendModeNormal alpha:1];
        [path stroke];
    }
    
}

-(NSArray *)bezierpathArr{
    if (!_bezierpathArr) {
       _bezierpathArr = [NSArray array];
    }
    return _bezierpathArr;
}

@end
