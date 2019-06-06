//
//  VIdleTimerSwitch.h
//  YUNIO
//
//  Created by Vincent on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIdleTimerSwitch : NSObject
{
    NSMutableDictionary* switchDict;
}

+ (VIdleTimerSwitch*)sharedSwitch;
- (void)turnTimer: (BOOL)on key: (id)key;

- (id)generateOneSwitchKey;
- (void)removeOnSwitch: (id)key;

@end
