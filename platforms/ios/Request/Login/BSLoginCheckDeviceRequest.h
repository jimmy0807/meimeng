//
//  BSLoginCheckDeviceRequest.h
//  Boss
//
//  Created by lining on 15/3/31.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSLoginCheckDeviceRequest : ICRequest
- (id)initWithUserName:(NSString *)username passWord:(NSString *)password profile:(PersonalProfile*)profile;
@end
