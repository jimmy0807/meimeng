//
//  NSObject+MainThreadNotification.h
//  mojito
//
//  Created by Vincent Xiao on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (MainThreadNotification)

-(void)registerNofitificationForMainThread:(NSString*)name object: (id)object;
-(void)registerNofitificationForMainThread:(NSString*)name;
-(void)doNotificationProOnMainThread:(NSNotification*)notification;
-(void)removeNotificationOnMainThread:(NSString*)name;

@end
