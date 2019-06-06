//
//  ICAuthentication.h
//  BetSize
//
//  Created by jimmy on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICKeyChainManager.h"

/* key chain */
#define USER_PASSWORD           @"USER_PASSWORD"
#define USER_Token              @"USER_Token"
#define USER_Name               @"USER_Name"
#define USER_RandomNum          @"USER_RandomNum"

@interface ICAuthentication : NSObject
{
    NSString* _token;
    NSString* _username;
    NSString* _secret;
}

@property(nonatomic, copy) NSString* secret;
@property(nonatomic, copy) NSString* userName;
@property(nonatomic, copy) NSString* token;

- (id)initWithToken: (NSString*)token userName: (NSString*)userName;
- (id)initWithICKeyChainToken: (NSString*)token userName: (NSString*)userName;

- (void)saveToUserDefaults;
+ (ICAuthentication*)authenticationFromUserDefaults;

@end
