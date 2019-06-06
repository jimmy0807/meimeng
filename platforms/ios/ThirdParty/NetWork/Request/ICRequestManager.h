//
//  ICRequestManager.h
//  BetSize
//
//  Created by jimmy on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "ICRequest.h"
#import "ICAuthentication.h"

@interface ICRequestManager : NSObject
{
    NSMutableArray* requests;
    NSRecursiveLock* _locker;
    ICAuthentication* _auth;
}

@property(nonatomic, retain) NSArray* requests;

+ (ICRequestManager*)sharedManager;

- (void)cancelAllRequests;
- (void)addRequest: (ICRequest*)request;
- (void)removeRequest: (ICRequest*)request;

- (void)saveToken: (NSDictionary*)paramDict;
- (void)saveToken:(NSString*)token userName:(NSString*)userName;

@end
