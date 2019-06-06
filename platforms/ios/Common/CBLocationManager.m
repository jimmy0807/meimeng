//
//  CBLocationManager.m
//  CardBag
//
//  Created by XiaXianBing on 14/11/21.
//  Copyright (c) 2014年 Everydaysale. All rights reserved.
//

#import "CBLocationManager.h"
#import "ICRequestDef.h"

@implementation CBLocationManager
{
    BOOL isLocated;
}

static CBLocationManager *locManager;
+ (CBLocationManager *)defaultManager
{
    if (locManager == nil)
    {
        locManager = [[self alloc] init];
    }
    
    return locManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        locationManager = [[CLLocationManager alloc] init];
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager requestWhenInUseAuthorization];
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.distanceFilter = 0.5;
    }
    
    return self;
}

- (void)dealloc
{
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
    locationManager = nil;
}


#pragma mark -
#pragma mark Required Methods

- (void)startLocation
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return;
    }
    else
    {
        isLocated = NO;
        locationManager.delegate = self;
        
        [locationManager startUpdatingLocation];
    }
}

- (void)stopLocation
{
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
}


#pragma mark -
#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"经纬度: %f, %f", newLocation.coordinate.longitude, newLocation.coordinate.latitude);
    if (!CLLocationCoordinate2DIsValid(newLocation.coordinate))
    {
        return;
    }
    
    self.currentLocation = newLocation.coordinate;
    if (!isLocated)
    {
        isLocated = YES;
        [self performSelector:@selector(didLocationSuccess) withObject:nil afterDelay:2];
    }
}

- (void)didLocationSuccess
{
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCBLocationManagerSuccess object:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    ;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:LS(@"PleaseStartLocationServices") delegate:nil cancelButtonTitle:LS(@"Cancel") otherButtonTitles:LS(@"IKnewButtonTitle"), nil];
        alertView.delegate = self;
        [alertView show];
        
    }
    else if (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (IS_SDK8) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}
@end
