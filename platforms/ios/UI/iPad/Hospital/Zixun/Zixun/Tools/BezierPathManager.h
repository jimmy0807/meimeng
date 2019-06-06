//
//  BezierPathManager.h
//  meim
//
//  Created by 刘伟 on 2017/12/14.
//

#import <Foundation/Foundation.h>

@interface BezierPathManager : NSObject

///测试数组
@property(nonatomic,strong)NSMutableArray *pathStrArr;

+ (BezierPathManager *)sharedInstance ;

-(void)removeBezierPathArr:(NSString *)key;

-(void)saveBezierPathArrToPointsStr2: (NSArray *)bezierPathArr andImgKey:(NSString *)key;
-(NSArray *)dealPointsStrToBezierPathArr2: (NSArray *)pointArr;

+ (NSString*)convertBezierPathToNSString:(UIBezierPath*) bezierPath;
+ (UIBezierPath*)convertNSStringToBezierPath:(NSString*) bezierPathString;

@end
