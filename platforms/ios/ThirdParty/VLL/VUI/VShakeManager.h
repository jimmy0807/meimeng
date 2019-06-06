//
//  VShakeManager.h
//  Spark
//
//  Created by jimmy on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VShakeManager : NSObject
{
    CGFloat shakeRadians;
    NSTimeInterval shakeTime;
    NSArray* shakeViewArray;
    NSTimer* durationTimer;
@private
    BOOL isShaking;
}

@property(nonatomic) CGFloat shakeRadians;
@property(nonatomic) NSTimeInterval shakeTime;
@property(nonatomic, retain) NSArray* shakeViewArray;

-(void)start;
-(void)stop;
-(void)startWithDuration: (NSTimeInterval) duration;


@end
