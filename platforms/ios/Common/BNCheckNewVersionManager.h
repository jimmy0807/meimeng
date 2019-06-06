//
//  BNCheckNewVersionManager.h
//  Boss
//
//  Created by jimmy on 15/9/8.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCheckNewVersionResponse @"kCheckNewVersionResponse"

@interface BNCheckNewVersionManager : NSObject

InterfaceSharedManager(BNCheckNewVersionManager)

@property(nonatomic, strong)NSString* localVersion;
@property(nonatomic, strong)NSString* serverVersion;
@property(nonatomic, strong)NSString* versionDescription;

- (void)fetchServerVersion;
- (BOOL)hasNewVersion;
- (void)update;
@end
