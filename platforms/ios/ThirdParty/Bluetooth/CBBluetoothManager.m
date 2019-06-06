//
//  CBBluetoothManager.m
//  BleCentralDemo
//
//  Created by jimmy on 15/11/2.
//  Copyright © 2015年 Marshal Wu. All rights reserved.
//

#import "CBBluetoothManager.h"
#import "BSUserDefaultsManager.h"

@interface CBBluetoothManager ()
@property (nonatomic, strong) CBCentralManager *centerManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
//@property (nonatomic, strong) NSTimer *connectTimer;

@end

@implementation CBBluetoothManager

static CBBluetoothManager *mManager;
+ (CBBluetoothManager *)shareManager
{
    if (mManager == nil)
    {
        mManager = [[self alloc] init];
    }
    
    return mManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.peripheralArray = [NSMutableArray array];
        self.centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    
    return self;
}

- (id)initWithDelegate:(id<CBBluetoothManagerDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        self.peripheralArray = [NSMutableArray array];
        self.centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    
    return self;
}

- (void)startConnection
{
    if ([self isScanning])
    {
        [self stopScan];
        self.peripheralArray = [NSMutableArray array];
    }
    
    [self startScan];
}


#pragma mark -
#pragma mark CBCentralManager Methods

- (void)startScan
{
    [self stopScan];
    [self.centerManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)stopScan
{
    [self.centerManager stopScan];
}

- (BOOL)isScanning
{
    if ( [self.centerManager respondsToSelector:@selector(isScanning)] )
    {
        return [self.centerManager isScanning];
    }
 
    return TRUE;
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
{
    if ( peripheral && peripheral.state != CBPeripheralStateConnected )
    {
        [self.centerManager connectPeripheral:peripheral options:nil];
    }
}

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral
{
    [self.centerManager cancelPeripheralConnection:peripheral];
}


#pragma mark -
#pragma mark CBPeripheral Methods

- (void)writeValue:(NSData *)data forPeripheral:(CBPeripheral*)peripheral forCharacteristic:(CBCharacteristic *)characteristic
{
    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark -
#pragma mark CBCentralManagerDelegate Methods

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        [self startScan];
    }
    else
    {
        NSLog(@"设备不支持BLE或者未打开");
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    BOOL needAdd = TRUE;

    if ( peripheral.name.length == 0 )
    {
        return;
    }
          
    for (int i = 0; i < self.peripheralArray.count; i++)
    {
        CBPeripheral *per = [self.peripheralArray objectAtIndex:i];
        
        if ( [peripheral.identifier.UUIDString isEqualToString:per.identifier.UUIDString] )
        {
            needAdd = FALSE;
            break;
        }
    }
    
    if ( needAdd )
    {
        [self.peripheralArray addObject:peripheral];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFindDevice:)])
        {
            [self.delegate didFindDevice:peripheral];
        }
    }
    
//    if (self.isAutomatic)
//    {
//        NSDictionary *dict = [BSUserDefaultsManager sharedManager].mPadPrinterRecord;
//        NSString *deviceUUID = [dict objectForKey:@"uuid"];
//        if (deviceUUID.length != 0 && [deviceUUID isEqualToString:peripheral.identifier.UUIDString])
//        {
//            [self connectPeripheral:peripheral];
//        }
//        
//        dict = [BSUserDefaultsManager sharedManager].mPadCodeScannerRecord;
//        deviceUUID = [dict objectForKey:@"uuid"];
//        if (deviceUUID.length != 0 && [deviceUUID isEqualToString:peripheral.identifier.UUIDString])
//        {
//            [self connectPeripheral:peripheral];
//        }
//    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    self.peripheral = peripheral;
    [self.peripheral discoverServices:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeviceConnect:)])
    {
        [self.delegate didDeviceConnect:self.peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeviceConnectFail:)])
    {
        [self.delegate didDeviceConnectFail:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeviceDisconnect:)])
    {
        [self.delegate didDeviceDisconnect:peripheral];
    }
}

#pragma mark -
#pragma mark CBCentralManagerDelegate Methods

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        return;
    }
    
    for (CBService *service in peripheral.services)
    {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if ( [characteristic.UUID.UUIDString isEqualToString:PosMachineCharacteristic] )
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            [self.delegate didFindPosMachineCharacteristic:characteristic];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFindCharacteristics:)])
    {
        [self.delegate didFindCharacteristics:service.characteristics];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    ;
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (characteristic.isNotifying)
    {
        [self didCharacteristicUpdated:characteristic];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    ;
}

- (void)didCharacteristicUpdated:(CBCharacteristic *)characteristic
{
    if ([characteristic.UUID.UUIDString isEqualToString:PosMachineCharacteristic])
    {
        [self.delegate didReadCharacteristicNotify:characteristic];
    }
}

@end
