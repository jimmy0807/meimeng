//
//  iBeaconClientManager.m
//  Boss
//
//  Created by jimmy on 16/3/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "iBeaconClientManager.h"

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

static iBeaconClientManager *s_sharedManager;

@interface iBeaconClientManager ()<CLLocationManagerDelegate>
{
    NSInteger retryTimes;
}
@property(strong, nonatomic)CLBeaconRegion *myBeaconRegion;
@property(strong, nonatomic)CLLocationManager *locationManager;
@property(strong, nonatomic)NSString* UUIDString;
@property(nonatomic)NSInteger major;
@property(nonatomic)NSInteger minor;
@property(nonatomic, strong)void(^finish)(BOOL finish);
@end

@implementation iBeaconClientManager

+ (iBeaconClientManager *)sharedManager
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
        
    }
    
    return self;
}

- (void)searchIBeaconWithUUID:(NSString*)UUIDString major:(NSInteger)major minor:(NSInteger)minor finsih:(void(^)(BOOL finish))finsih
{
    if ( !self.locationManager )
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUIDString];
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"BornIBeacon"];
    
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
    
    retryTimes = 10;
    
    self.major = major;
    self.minor = minor;
    self.finish = finsih;
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
{
    retryTimes--;
    
    for ( CLBeaconRegion* region in beacons )
    {
        NSString *uuid = region.proximityUUID.UUIDString;
        
        //region.proximity 距离
        
        if ( [uuid isEqualToString:self.UUIDString] && self.major == [region.major integerValue] && self.minor == [region.minor integerValue] )
        {
            self.finish(TRUE);
            [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
            
            return;
        }
    }
    
    if ( retryTimes == 0 )
    {
        self.finish(FALSE);
        [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
    }
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"Did start monitoring for region: %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"state = %d",state);
}

@end
