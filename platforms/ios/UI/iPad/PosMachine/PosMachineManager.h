//
//  PosMachineManager.h
//  ds
//
//  Created by jimmy on 16/11/15.
//
//

#import <Foundation/Foundation.h>
#import "CBBluetoothManager.h"

@protocol PosMachineManagerDelegate <NSObject>
- (void)onSwipeCardConnect;
@end

@interface PosMachineManager : NSObject

InterfaceSharedManager(PosMachineManager)

- (void)active;
- (void)connectPosMachine;
- (void)connectSwipeCard;
- (void)disConnectSwipeCard;
- (void)didFindPosMachineCharacteristic:(CBCharacteristic*)characteristic;
- (void)didReadCharacteristicNotify:(CBCharacteristic*)characteristic;
- (void)didPosMachineConnect:(CBPeripheral *)peripheral;

- (void)showMemberSignInView:(NSString*)cardNo;

@property(nonatomic, weak)id<PosMachineManagerDelegate> delegate;

- (BOOL)isSwipeCardConnected;
- (void)connectSwipeCardDevice:(NSString*)name;

@end
