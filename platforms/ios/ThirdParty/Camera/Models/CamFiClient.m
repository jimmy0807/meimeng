//
//  CamFiClient.m
//  CamFi
//
//  Created by Justin on 16/3/29.
//  Copyright © 2016年 AndFex. All rights reserved.
//

#import "CamFiClient.h"
#import "SSDPService.h"
#import "Constants.h"
#import "Utils.h"

@implementation CamFiClient

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.ssid = [Utils currentWifiSSID];
        self.username = kDefaultCamFiUserName;
        self.password = kDefaultCamFiPassword;
        
        NSString* deviceIPAdress = [Utils deviceIPAdress];
        NSRange rang = [deviceIPAdress rangeOfString:@"." options:NSBackwardsSearch];
        if (rang.location != NSNotFound) {
            
            self.servicePath = [NSString stringWithFormat:@"%@.67", [deviceIPAdress substringToIndex:rang.location]];
        }
    }
    return self;
}

+ (instancetype)camfiClientWithSSDPService:(SSDPService*)aService
{
    CamFiClient* client = [[CamFiClient alloc] init];

    client.ssid = aService.name;
    client.servicePath = aService.servicePath;

    return client;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.ssid forKey:@"ssid"];
    [encoder encodeObject:self.servicePath forKey:@"servicePath"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.password forKey:@"password"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init]) {
        
        self.ssid = [decoder decodeObjectForKey:@"ssid"];
        self.servicePath = [decoder decodeObjectForKey:@"servicePath"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.password = [decoder decodeObjectForKey:@"password"];
    }
    return  self;
}

@end
