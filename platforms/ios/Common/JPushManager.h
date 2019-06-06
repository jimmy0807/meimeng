//
//  JPushManager.h
//  Mata
//
//  Created by jimmy on 16/10/25.
//  Copyright © 2016年 Mata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPushManager : NSObject

+ (JPushManager*)sharedManager;

@property(nonatomic, strong)NSString* registrationID;

- (void)sendRegistrationIDToServer;

@end
