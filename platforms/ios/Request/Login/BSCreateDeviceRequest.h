//
//  SACreateDeviceRequest.h
//  ShopAssistant
//
//  Created by jimmy on 15/3/16.
//  Copyright (c) 2015年 jimmy. All rights reserved.
//

#import "ICRequest.h"
@interface BSCreateDeviceRequest : ICRequest

- (id)initWithUserName:(NSString *)username password:(NSString *)password;

@end
