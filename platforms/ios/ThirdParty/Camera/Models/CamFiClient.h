//
//  CamFiClient.h
//  CamFi
//
//  Created by Justin on 16/3/29.
//  Copyright © 2016年 AndFex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSDPService;

@interface CamFiClient : NSObject

@property (nonatomic, copy  ) NSString       *ssid;
@property (nonatomic, copy  ) NSString       *servicePath;
@property (nonatomic, copy  ) NSString       *username;
@property (nonatomic, copy  ) NSString       *password;
@property (nonatomic, copy  ) NSString       *channel;

+(instancetype)camfiClientWithSSDPService:(SSDPService*)aService;

@end
