//
//  iBeaconManager.h
//  Boss
//
//  Created by jimmy on 16/3/17.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iBeaconServerManager : NSObject

+ (iBeaconServerManager *)sharedManager;

@property(nonatomic, strong)NSString* UUIDString;
@property(nonatomic)NSInteger major;
@property(nonatomic)NSInteger minor;

@end
