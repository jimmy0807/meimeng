//
//  BSPadPeripheral.m
//  Boss
//
//  Created by XiaXianBing on 15/12/4.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSPadPeripheral.h"

@implementation BSPadPeripheral

@synthesize peripheral = _peripheral;

- (void)setPeripheral:(CBPeripheral *)peripheral
{
    _peripheral = peripheral;
    self.deviceName = _peripheral.name;
    self.deviceUUID = _peripheral.identifier.UUIDString;
}

@end
