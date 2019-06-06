//
//  CBBluetoothManager.h
//  BleCentralDemo
//
//  Created by jimmy on 15/11/2.
//  Copyright © 2015年 Marshal Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define PosMachineCharacteristic @"FFE1"

@protocol CBBluetoothManagerDelegate <NSObject>
- (void)didFindDevice:(CBPeripheral *)peripheral;
- (void)didDeviceConnect:(CBPeripheral *)peripheral;
- (void)didDeviceConnectFail:(CBPeripheral *)peripheral;
- (void)didDeviceDisconnect:(CBPeripheral *)peripheral;
- (void)didFindCharacteristics:(NSArray *)characteristics;
- (void)didFindPosMachineCharacteristic:(CBCharacteristic*)characteristic;
- (void)didReadCharacteristicNotify:(CBCharacteristic*)characteristic;
@end

@interface CBBluetoothManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, assign) BOOL isAutomatic;
@property (nonatomic, strong) NSMutableArray *peripheralArray;
@property (nonatomic, weak) id<CBBluetoothManagerDelegate> delegate;

+ (CBBluetoothManager *)shareManager;
- (id)initWithDelegate:(id<CBBluetoothManagerDelegate>)delegate;

- (void)startConnection;

#pragma mark -
#pragma mark CBCentralManager Methods
- (void)startScan;
- (void)stopScan;
- (BOOL)isScanning;
- (void)connectPeripheral:(CBPeripheral *)peripheral;
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

#pragma mark -
#pragma mark CBPeripheral Methods

- (void)writeValue:(NSData *)data forPeripheral:(CBPeripheral*)peripheral forCharacteristic:(CBCharacteristic *)characteristic;

@end
