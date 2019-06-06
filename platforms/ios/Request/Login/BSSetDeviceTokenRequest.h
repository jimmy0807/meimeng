//
//  BSSetDeviceTokenRequest.h
//  Boss
//
//  Created by jimmy on 15/8/13.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSSetDeviceTokenRequest : ICRequest

- (id)initWithToken:(NSString *)token;
- (instancetype)initWithParams:(NSDictionary *)params;

@end
