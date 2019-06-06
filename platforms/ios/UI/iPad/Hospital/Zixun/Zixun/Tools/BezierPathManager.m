//
//  BezierPathManager.m
//  meim
//
//  Created by 刘伟 on 2017/12/14.
//

#import "BezierPathManager.h"
#import "UIBezierPath+Points.h"
#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

@implementation BezierPathManager

+ (BezierPathManager *)sharedInstance {
    static BezierPathManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)removeBezierPathArr:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(void)saveBezierPathArrToPointsStr2: (NSArray *)bezierPathArr andImgKey:(NSString *)key {
        NSString *pathStr = [NSString string];
        NSMutableArray *pathStrArr = [NSMutableArray array];
        for (UIBezierPath *path in bezierPathArr) {
            //NSLog(@"存进的path　%@",path);
            //NSLog(@"存进的path属性　%f-%d-%d",path.lineWidth,path.lineCapStyle,path.lineJoinStyle);
            //1.000000-0-0
            pathStr = [[self class] convertBezierPathToNSString:path];
            [pathStrArr addObject:pathStr];
        }
        //NSLog(@"存进UserDefault的pathStr%@",pathStr);
    
    //TODO:存文件
        [[NSUserDefaults standardUserDefaults] setObject:pathStrArr forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    //TODO:不存文件 也就是用临时变量
    //_pathStrArr = pathStrArr;
    
}

-(NSArray *)dealPointsStrToBezierPathArr2: (NSArray *)pointArr {
    
    //NSLog(@"dealPointsStrToBezierPathArr2 = %@",pointArr);
    NSMutableArray *pathArr = [NSMutableArray array];
    for (NSString *pathStr in pointArr) {
        UIBezierPath *path =
        [[self class] convertNSStringToBezierPath:pathStr];
        //NSLog(@"取出的path = %@",path);
        //NSLog(@"取出的path属性　%f-%d-%d",path.lineWidth,path.lineCapStyle,path.lineJoinStyle);
        //1.000000-0-0
        [pathArr addObject:path];
    }
    return pathArr;
    
}


/**
 *@brief:将BezierPath中的点转为字符串
 */
+ (NSString*)convertBezierPathToNSString:(UIBezierPath*) bezierPath
{
    NSString *pathString = @"";
    
    CGPathRef yourCGPath = bezierPath.CGPath;
    NSMutableArray *bezierPoints = [NSMutableArray array];
    CGPathApply(yourCGPath, (__bridge void *)(bezierPoints), MyCGPathApplierFunc);
    
    for (int i = 0; i < [bezierPoints count]; ++i)
    {
        
        CGPoint point = [bezierPoints[i] CGPointValue];
        pathString = [pathString stringByAppendingString:[NSString stringWithFormat:@"%f",point.x]];
        pathString = [pathString stringByAppendingFormat:@"%@",@","];
        pathString = [pathString stringByAppendingString:[NSString stringWithFormat:@"%f",point.y]];
        pathString = [pathString stringByAppendingString:@"|"];
        
    }
    
    return pathString;
}


void MyCGPathApplierFunc (void *info, const CGPathElement *element) {
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
    CGPoint *points = element->points;
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;
            
        case kCGPathElementAddLineToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            break;
            
        case kCGPathElementAddCurveToPoint: // contains 3 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[2]]];
            break;
            
        case kCGPathElementCloseSubpath: // contains no point
            break;
    }
}

/**
 *@brief:将字符串中的点转为BezierPath
 */
+ (UIBezierPath*)convertNSStringToBezierPath:(NSString*) bezierPathString
{
    
    NSMutableArray *pointsArray = [[NSMutableArray alloc] init];
    NSInteger length = 0;
    
    //解析字符串
    NSString *separatorString1 = @",";
    NSString *separatorString2 = @"|";
    
    NSScanner *aScanner = [NSScanner scannerWithString:bezierPathString];
    
    while (![aScanner isAtEnd]) {
        
        NSString *xString, *yString;
        
        [aScanner scanUpToString:separatorString1 intoString:&xString];
        [aScanner setScanLocation:[aScanner scanLocation]+1];
        
        [aScanner scanUpToString:separatorString2 intoString:&yString];
        [aScanner setScanLocation:[aScanner scanLocation]+1];
        
        CGPoint point;
        point.x = [xString floatValue];
        point.y = [yString floatValue];
        
        [pointsArray addObject:[NSValue valueWithCGPoint:point]];
        
    }
    
    ///LW新增:(无效果)
    //[[BezierPathManager sharedInstance] smoothedPathWithPoints:pointsArray andGranularity:1];
    
    //首先将字符串解析为CGPoint数组,再将数组初始化UIBeizerPath
    length = [pointsArray count];
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:[pointsArray[0] CGPointValue] ];//设置起点
    for (NSUInteger j=1; j< length; j++) {
        if (j>1) {
            //[bezierPath addQuadCurveToPoint:[pointsArray[j] CGPointValue] controlPoint:[pointsArray[j-1] CGPointValue]];

            [bezierPath addCurveToPoint:[pointsArray[j] CGPointValue] controlPoint1:[pointsArray[j-2] CGPointValue] controlPoint2:[pointsArray[j-1] CGPointValue]];
        }
        else {
            [bezierPath addLineToPoint:[pointsArray[j] CGPointValue]];
        }
    }
    
    ///LW新增:
    bezierPath.lineCapStyle= kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineWidth = 1;
    
    return bezierPath;
}

///使path平滑的方法(解决锯齿未起效)
//#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]
- (void)smoothedPathWithPoints:(NSArray *) pointsArray andGranularity:(NSInteger)granularity {
    
    NSMutableArray *points = [pointsArray mutableCopy];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(context, 0.6);
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    
    // Add control points to make the math make sense
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    [smoothedPath moveToPoint:POINT(0)];
    
    for (NSUInteger index = 1; index < points.count - 2; index++) {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++) {
            
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            [smoothedPath addLineToPoint:pi];
        }
        
        // Now add p2
        [smoothedPath addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    
    CGContextAddPath(context, smoothedPath.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
    
}

@end
