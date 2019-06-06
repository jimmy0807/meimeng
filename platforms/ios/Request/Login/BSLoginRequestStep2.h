//
//  BSLoginRequestStep2.h
//  Boss
//
//  Created by lining on 15/3/31.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSLoginRequestStep2 : ICRequest

@property(nonatomic, strong) NSNumber *deviceId;
- (id)initWithUserName:(NSString *)username password:(NSString *)password;


@end
