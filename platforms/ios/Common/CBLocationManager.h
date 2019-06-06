//
//  CBLocationManager.h
//  CardBag
//
//  Created by XiaXianBing on 14/11/21.
//  Copyright (c) 2014年 Everydaysale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CBLocationManager : NSObject <CLLocationManagerDelegate,UIAlertViewDelegate>
{
    CLLocationManager *locationManager;
}

@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;

+ (CBLocationManager *)defaultManager;

- (void)startLocation;
- (void)stopLocation;

@end
