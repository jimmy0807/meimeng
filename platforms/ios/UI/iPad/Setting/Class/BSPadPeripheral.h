//
//  BSPadPeripheral.h
//  Boss
//
//  Created by XiaXianBing on 15/12/4.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface BSPadPeripheral : NSObject

@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *deviceUUID;
@property (nonatomic, strong) CBPeripheral *peripheral;

@end
