//
//  ResetIPManager.m
//  meim
//
//  Created by jimmy on 2018/8/13.
//

#import "ResetIPManager.h"
#import "SSDPService.h"
#import "SSDPServiceBrowser.h"
#import "SSDPServiceTypes.h"
#import "CamFiClient.h"
#import "CamFiServerInfo.h"

@interface ResetIPManager () <SSDPServiceBrowserDelegate>

@property (nonatomic, strong) SSDPServiceBrowser* browser;

@end

@implementation ResetIPManager

+ (ResetIPManager *)sharedInstance {
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}


- (id) init
{
    if (self = [super init])
    {
        self.browser = [[SSDPServiceBrowser alloc] initWithServiceType:SSDPServiceType_UPnP_CamFi];
        self.browser.delegate = self;
        
        [self.browser startBrowsingForServices];
    }
    
    return self;
}

- (void)reload
{
    [self.browser stopBrowsingForServices];
    self.browser = nil;
    
    self.browser = [[SSDPServiceBrowser alloc] initWithServiceType:SSDPServiceType_UPnP_CamFi];
    self.browser.delegate = self;
    
    [self.browser startBrowsingForServices];
}

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didNotStartBrowsingForServices:(NSError *)error {
    
    NSLog(@"SSDP Browser got error: %@", error);
}

- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didFindService:(SSDPService *)service {
    
    CamFiClient *client = [CamFiClient camfiClientWithSSDPService:service];
    if ( [client.ssid isEqualToString:[PersonalProfile currentProfile].cameraName] )
    {
        [PersonalProfile currentProfile].cameraIP = client.servicePath;
        [CamFiServerInfo sharedInstance].serverIP = client.servicePath;
    }
}

-(void)ssdpBrowser:(SSDPServiceBrowser *)browser didRemoveService:(SSDPService *)service
{
    NSLog(@"SSDP Browser didRemove: %@", service);
}

@end
