//
//  iBeaconClientManager.h
//  Boss
//
//  Created by jimmy on 16/3/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iBeaconClientManager : NSObject

+ (iBeaconClientManager *)sharedManager;
- (void)searchIBeaconWithUUID:(NSString*)UUIDString major:(NSInteger)major minor:(NSInteger)minor finsih:(void(^)(BOOL finish))finsih;

@end
