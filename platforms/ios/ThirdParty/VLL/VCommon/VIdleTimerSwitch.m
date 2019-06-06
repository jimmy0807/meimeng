//
//  YNIdleTimerSwitch.m
//  YUNIO
//
//  Created by Vincent on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VIdleTimerSwitch.h"
#import <UIKit/UIKit.h>

VIdleTimerSwitch* s_sharedSwitch;

@interface VIdleTimerSwitch()
- (void)decideIdleTimer;
@end

@implementation VIdleTimerSwitch

- (NSString *)generateUuidString
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    // transfer ownership of the string
    // to the autorelease pool
    [uuidString autorelease];
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        switchDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [switchDict release];
    [super dealloc];
}

+ (VIdleTimerSwitch*)sharedSwitch
{
    @synchronized(s_sharedSwitch)
    {
        if (s_sharedSwitch == nil) 
        {
            s_sharedSwitch = [[VIdleTimerSwitch alloc] init];
        }
    }
    return s_sharedSwitch;
}

- (void)turnTimer: (BOOL)on key: (id)key
{
    NSNumber* isOn = [switchDict valueForKey: key];
    if (isOn) 
    {
        [switchDict setValue: [NSNumber numberWithBool: on] forKey: key];
    }
    [self decideIdleTimer];
}

- (id)generateOneSwitchKey
{
    NSString* key = [self generateUuidString];
    [switchDict setValue: [NSNumber numberWithBool: NO] forKey: key];
    return key;
}

- (void)removeOnSwitch: (id)key
{
    [switchDict removeObjectForKey: key];
}

- (void)decideIdleTimer
{
    BOOL toDisable = NO;
    // As long as there's one module which needs to disable idleTimer,
    // we just let it disabled.
    for (NSString* key in switchDict) 
    {
        NSNumber* number = [switchDict valueForKey: key];
        toDisable |= [number boolValue];
    }
//    NSLog(@"$$$$$$$$$$$$$$$$$$$");
//    NSLog(@"toDisable = %d", toDisable);
    [UIApplication sharedApplication].idleTimerDisabled = toDisable;
}
@end
