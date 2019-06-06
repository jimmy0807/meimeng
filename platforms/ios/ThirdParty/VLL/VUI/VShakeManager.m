//
//  VShakeManager.m
//  Spark
//
//  Created by jimmy on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VShakeManager.h"
#import <UIKit/UIKit.h>

@implementation VShakeManager
@synthesize shakeRadians;
@synthesize shakeTime;
@synthesize shakeViewArray;

-(id)init
{
    self = [super init];
    if (self)
    {
        shakeRadians = 1.0;
        shakeTime = 0.07;
    }
    
    return self;
}

- (void)beginShake
{
	static BOOL shakeLeft = NO;
	
	if (isShaking)
    {
		CGFloat rotation = (shakeRadians * M_PI) / 180.0;
		CGAffineTransform left = CGAffineTransformMakeRotation(rotation);
		CGAffineTransform right = CGAffineTransformMakeRotation(-rotation);
		
		[UIView beginAnimations:nil context:nil];
		
		NSInteger i = 0;
        
		for (UIView *view in shakeViewArray)
        {
            if (i % 2)
            {
                view.transform = shakeLeft ? right : left;
            }
            else
            {
                view.transform = shakeLeft ? left : right;
            }
            
            i++;
		}
		
        [UIView setAnimationDuration:shakeTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(beginShake)];
        shakeLeft = !shakeLeft;
			
		[UIView commitAnimations];
	}
}

-(void)start
{
    if ( shakeViewArray.count == 0 || isShaking)
        return;
    
    isShaking = YES;
    
    [self beginShake];
}

-(void)stop
{
    if (durationTimer) 
    {
        [durationTimer invalidate];
        SAFE_RELEASE(durationTimer);
    }
    if ( isShaking )
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
	
        for (UIView *view in shakeViewArray)
        {
            view.transform = CGAffineTransformIdentity;
        }
    
        [UIView commitAnimations];
        
        isShaking = NO;
    }
}

-(void)startWithDuration: (NSTimeInterval) duration
{
    [self start];
    durationTimer = [[NSTimer scheduledTimerWithTimeInterval: duration target: self selector: @selector(stop) userInfo: nil repeats: NO] retain];
}

-(void)dealloc
{
    [self stop];
    [shakeViewArray release];
    [super dealloc];
}
@end
