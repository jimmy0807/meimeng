//
//  UIBezierPath+Points.m
//  Path获取点
//
//  Created by 刘伟 on 2017/12/4.
//  Copyright © 2017年 刘伟. All rights reserved.
//
#define VALUE(_INDEX_) [NSValue valueWithCGPoint:points[_INDEX_]]

#import "UIBezierPath+Points.h"

@implementation UIBezierPath (Points)

void getPointsFromBezier(void *info,const CGPathElement *element){
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    
    if (type != kCGPathElementCloseSubpath) {
        [bezierPoints addObject:VALUE(0)];
        if ((type != kCGPathElementAddLineToPoint) && (type != kCGPathElementMoveToPoint)) {
            [bezierPoints addObject:VALUE(1)];
        }
    }
    
    if (type == kCGPathElementAddCurveToPoint) {
        [bezierPoints addObject:VALUE(2)];
    }
    
}

- (NSArray *)points
{
    NSMutableArray *points = [NSMutableArray array];
    CGPathApply(self.CGPath, (__bridge void *)points, getPointsFromBezier);
    return points;
}
@end
