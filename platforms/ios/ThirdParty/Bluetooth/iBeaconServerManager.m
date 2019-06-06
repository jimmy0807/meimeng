//
//  iBeaconManager.m
//  Boss
//
//  Created by jimmy on 16/3/17.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "iBeaconServerManager.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

static iBeaconServerManager *s_sharedManager;

@interface iBeaconServerManager ()<CBPeripheralManagerDelegate>
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@end

@implementation iBeaconServerManager

+ (iBeaconServerManager *)sharedManager
{
    if ( s_sharedManager == nil)
    {
        s_sharedManager = [[self alloc] init];
    }
    
    return s_sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    }
    
    return self;
}

- (void)setupService
{
    if ( !self.peripheralManager.isAdvertising )
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"FDA50693-A4E2-4FB1-AFCF-C6EB07647825"]
                                                                         major:10037
                                                                         minor:36543
                                                                    identifier:@"BornIBeacon"];
        
        NSDictionary *peripheralData = [region peripheralDataWithMeasuredPower:nil];
        [self.peripheralManager startAdvertising:peripheralData];
    }
}

#pragma mark -CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state)
    {
        case CBPeripheralManagerStatePoweredOn:
        {
            [self setupService];
        }
            break;
            
        default:
        {
            NSLog(@"Peripheral Manager did change state");
        }
            break;
    }
}

@end
