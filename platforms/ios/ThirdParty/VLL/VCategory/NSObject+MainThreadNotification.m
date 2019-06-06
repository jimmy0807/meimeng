//
//  UIViewController+MainThreadNotification.m
//  mojito
//
//  Created by Vincent Xiao on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSObject+MainThreadNotification.h"

@implementation NSObject (MainThreadNotification)

-(void)registerNofitificationForMainThread:(NSString*)name
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(doNotificationProOnMainThread:) name: name object: nil];
}

-(void)registerNofitificationForMainThread:(NSString*)name object: (id)object
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(doNotificationProOnMainThread:) name: name object: object];
}

-(void)doNotificationProOnMainThread:(NSNotification*)notification
{
    [self performSelectorOnMainThread: @selector(didReceiveNotificationOnMainThread:) withObject:notification waitUntilDone: NO];
}

-(void)removeNotificationOnMainThread:(NSString*)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

// Should be overrided by subclass
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    NSLog(@"[] Warning: didReceiveNotificationOnMainThread should be overrided by sub class!!");
}

@end
