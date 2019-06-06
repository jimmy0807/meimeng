//
//  PosMachineManager.m
//  ds
//
//  Created by jimmy on 16/11/15.
//
//

#import "PosMachineManager.h"
#import "PosMachineMemberSignInViewController.h"
#import "BSPadPeripheral.h"
#import "BSUserDefaultsManager.h"
#import "PadMaskView.h"
#import "BluetoothZXBLib.h"
#import "LocalMusicPlayerManager.h"

#define Protocol_Header 0xF1
#define Protocol_Footer 0xF2

#define PosMachine_Header 0x03

@interface ReadCharacteristicDataObject : NSObject
@property(nonatomic, strong)NSMutableData *data;
@property(nonatomic)NSInteger length;
- (void)clear;
@end

@implementation ReadCharacteristicDataObject
- (void)clear
{
    self.data = nil;
    self.length = 0;
}
@end

@interface PosMachineManager ()<CBBluetoothManagerDelegate, ZftZXBDelegate>
@property (nonatomic, strong) CBBluetoothManager *bluetoothManager;
@property (nonatomic, strong) BSPadPeripheral *posMachine;
@property (nonatomic, strong) BSPadPeripheral *swipeCard;
@property(nonatomic, strong)PadMaskView *maskView;
@property (nonatomic, strong)ReadCharacteristicDataObject *readCharacteristicData;
@property (nonatomic, strong) BluetoothZXBLib* zft_qpos;
@end

@implementation PosMachineManager

IMPSharedManager(PosMachineManager)

- (id)init
{
    self = [super init];
    if ( self )
    {
        [self registerNofitificationForMainThread:@""];
        
        self.bluetoothManager = [CBBluetoothManager shareManager];
        self.readCharacteristicData = [[ReadCharacteristicDataObject alloc] init];
        [self connectPosMachine];
        
#if !TARGET_IPHONE_SIMULATOR
        self.zft_qpos = [BluetoothZXBLib getInstance];
        [self.zft_qpos setLister:self];
        [BluetoothZXBLib getInstance];
        [self connectSwipeCard];
#endif
    }
    
    return self;
}

- (void)active
{
    self.bluetoothManager.delegate = self;
    [self disConnectSwipeCard];
    if ( self.posMachine.peripheral )
    {
        [self.bluetoothManager cancelPeripheralConnection:self.posMachine.peripheral];
        self.posMachine.peripheral = nil;
    }
    
    //[self GetCardNumber:@"123"];
}

- (void)connectPosMachine
{
    self.bluetoothManager.delegate = self;
    
    NSDictionary* dict = [BSUserDefaultsManager sharedManager].mPadPosMachineRecord;
    self.posMachine = [[BSPadPeripheral alloc] init];
    self.posMachine.deviceName = [dict objectForKey:@"name"];
    self.posMachine.deviceUUID = [dict objectForKey:@"uuid"];
    
    if ( self.posMachine.deviceName.length > 0 )
    {
        if ( self.posMachine.peripheral )
        {
            [self.bluetoothManager connectPeripheral:self.posMachine.peripheral];
        }
        else
        {
            [self.bluetoothManager startScan];
        }
    }
}

- (void)connectSwipeCard
{
    [self.zft_qpos starScan];
    NSDictionary* dict = [BSUserDefaultsManager sharedManager].mPadPrinterRecord;
    self.swipeCard = [[BSPadPeripheral alloc] init];
    self.swipeCard.deviceName = [dict objectForKey:@"name"];
    self.swipeCard.deviceUUID = [dict objectForKey:@"uuid"];
    
    if ( self.swipeCard.deviceName.length > 0 )
    {
        [self connectSwipeCardDevice:self.swipeCard.deviceName];
    }
}

- (void)disConnectSwipeCard
{
    NSDictionary* dict = [BSUserDefaultsManager sharedManager].mPadPrinterRecord;
    self.swipeCard = [[BSPadPeripheral alloc] init];
    self.swipeCard.deviceName = [dict objectForKey:@"name"];
    self.swipeCard.deviceUUID = [dict objectForKey:@"uuid"];
    
    if ( self.swipeCard.deviceName.length > 0 )
    {
        [self.zft_qpos disconnectionDevice];
    }
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ( [notification.name isEqualToString:@""] )
    {
        
    }
}

- (void)didFindDevice:(CBPeripheral *)peripheral
{
    if ( [peripheral.name isEqualToString:self.posMachine.deviceName] )
    {
        self.posMachine.peripheral = peripheral;
        [self.bluetoothManager connectPeripheral:peripheral];
    }
}

- (void)didPosMachineConnect:(CBPeripheral *)peripheral
{
    NSDictionary* dict = [BSUserDefaultsManager sharedManager].mPadPosMachineRecord;
    self.posMachine = [[BSPadPeripheral alloc] init];
    self.posMachine.deviceName = [dict objectForKey:@"name"];
    self.posMachine.deviceUUID = [dict objectForKey:@"uuid"];
    self.posMachine.peripheral = peripheral;
}

- (void)didDeviceConnect:(CBPeripheral *)peripheral
{
    
}

- (void)didDeviceConnectFail:(CBPeripheral *)peripheral
{
    
}

- (void)didDeviceDisconnect:(CBPeripheral *)peripheral
{
    
}

- (void)didFindCharacteristics:(NSArray *)characteristics
{
    
}

- (void)didFindPosMachineCharacteristic:(CBCharacteristic*)characteristic
{
    char header = Protocol_Header;
    short length = htons(0x0002);
    short reverseLength = htons(~0x0002 + 1);
    short content = htons(0x0300);
    char addContent = 0x03;
    char footer = Protocol_Footer;
    
    NSMutableData* dataToSend = [NSMutableData data];
    [dataToSend appendBytes:&header length:1];
    [dataToSend appendBytes:&length length:2];
    [dataToSend appendBytes:&reverseLength length:2];
    [dataToSend appendBytes:&content length:2];
    [dataToSend appendBytes:&addContent length:1];
    [dataToSend appendBytes:&footer length:1];
    
    [[CBBluetoothManager shareManager] writeValue:dataToSend forPeripheral:self.posMachine.peripheral forCharacteristic:characteristic];
}

- (void)didReadCharacteristicNotify:(CBCharacteristic*)characteristic
{
    /*
     Printing description of characteristic:
     <CBCharacteristic: 0x1700bb0c0, UUID = FFE1, properties = 0x1E, value = <f1000eff f2030035 ffdb054d 53373810 670951f7>, notifying = YES>
     Printing description of characteristic:
     <CBCharacteristic: 0x1700bb0c0, UUID = FFE1, properties = 0x1E, value = <f2>, notifying = YES>
     */
    //[[NSNotificationCenter defaultCenter] postNotificationName:kBSPosMachineReadCardResponse object:nil userInfo:nil];
    NSData* receieveData = characteristic.value;
    if ( receieveData )
    {
        u_char header;
        u_short length;
        u_short lengthCRC;
        u_char footer;
        u_char sunCRC;
        
        if ( self.readCharacteristicData.length == 0 )
        {
            [receieveData getBytes:&header length:1];
            if ( header == Protocol_Header )
            {
                [receieveData getBytes:&length range:NSMakeRange(1, 2)];
                [receieveData getBytes:&lengthCRC range:NSMakeRange(3, 2)];
                length = htons(length);
                lengthCRC = htons(lengthCRC);
                
                if ( lengthCRC == (u_short)(~length + 1) )
                {
                    if ( length + 7 == receieveData.length )
                    {
                        [receieveData getBytes:&footer range:NSMakeRange(receieveData.length - 1, 1)];
                        if ( footer == Protocol_Footer )
                        {
                            self.readCharacteristicData.data = [NSMutableData dataWithData:[receieveData subdataWithRange:NSMakeRange(5, length)]];
                            self.readCharacteristicData.length = length;
                            [receieveData getBytes:&sunCRC range:NSMakeRange(receieveData.length - 2, 1)];
                            if ( [self checkContentCRC:sunCRC] )
                            {
                                [self dealWithFinalData];
                            }
                            else
                            {
                                NSLog(@"校验SunCRC错误");
                            }
                        }
                        else
                        {
                            NSLog(@"校验Footer错误");
                        }
                    }
                    else if ( length + 7 > receieveData.length )
                    {
                        if ( length + 6 == receieveData.length )
                        {
                            self.readCharacteristicData.data = [NSMutableData dataWithData:[receieveData subdataWithRange:NSMakeRange(5, length)]];
                            self.readCharacteristicData.length = length;
                            [receieveData getBytes:&sunCRC range:NSMakeRange(receieveData.length - 1, 1)];
                            [self checkContentCRC:sunCRC];
                        }
                        else
                        {
                            self.readCharacteristicData.data = [NSMutableData dataWithData:[receieveData subdataWithRange:NSMakeRange(5, receieveData.length - 5)]];
                            self.readCharacteristicData.length = length;
                        }
                    }
                }
            }
        }
        else
        {
            if ( self.readCharacteristicData.length == self.readCharacteristicData.data.length )
            {
                if ( receieveData.length == 1 )
                {
                    [receieveData getBytes:&footer range:NSMakeRange(receieveData.length - 1, 1)];
                    if ( footer == Protocol_Footer )
                    {
                        [self dealWithFinalData];
                    }
                    else
                    {
                        NSLog(@"receieveData.length == 1 错误");
                    }
                }
                else if ( receieveData.length == 2 )
                {
                    [receieveData getBytes:&footer range:NSMakeRange(receieveData.length - 1, 1)];
                    [receieveData getBytes:&sunCRC range:NSMakeRange(receieveData.length - 2, 1)];
                    if ( [self checkContentCRC:sunCRC] && footer == Protocol_Footer )
                    {
                        [self dealWithFinalData];
                    }
                    else
                    {
                         NSLog(@"第二次CRC检验错误");
                    }
                }
                else
                {
                    NSLog(@"第二次收到的不是2位");
                }
            }
            else if ( self.readCharacteristicData.data.length + receieveData.length <= self.readCharacteristicData.length )
            {
                [self.readCharacteristicData.data appendData:receieveData];
            }
            else if ( self.readCharacteristicData.data.length + receieveData.length == self.readCharacteristicData.length  + 1 )
            {
                [self.readCharacteristicData.data appendData:[receieveData subdataWithRange:NSMakeRange(0, receieveData.length - 1)]];
                [receieveData getBytes:&sunCRC range:NSMakeRange(receieveData.length - 1, 1)];
                [self checkContentCRC:sunCRC];
            }
            else if ( self.readCharacteristicData.data.length + receieveData.length == self.readCharacteristicData.length  + 2 )
            {
                [self.readCharacteristicData.data appendData:[receieveData subdataWithRange:NSMakeRange(0, receieveData.length - 2)]];
                [receieveData getBytes:&footer range:NSMakeRange(receieveData.length - 1, 1)];
                [receieveData getBytes:&sunCRC range:NSMakeRange(receieveData.length - 2, 1)];
                if ( [self checkContentCRC:sunCRC] && footer == Protocol_Footer )
                {
                    [self dealWithFinalData];
                }
                else
                {
                    NSLog(@"第二次CRC检验错误");
                }
            }

        }
    }
}

-(BOOL)checkContentCRC:(u_char)sunCRC
{
    const void *p = self.readCharacteristicData.data.bytes;
    int sun = 0;
    for ( int i = 0; i < self.readCharacteristicData.length; i++ )
    {
        sun = sun + (*(int*)p++);
    }
    
    if ( (u_char)(sun & 0xff) == sunCRC)
    {
        return TRUE;
    }
    
    [self.readCharacteristicData clear];
    
    return FALSE;
}

- (void)dealWithFinalData
{
    u_char header;
    u_char function;
    [self.readCharacteristicData.data getBytes:&header length:1];
    [self.readCharacteristicData.data getBytes:&function range:NSMakeRange(1, 1)];
    
    if ( header == PosMachine_Header )
    {
        if ( function == 0x00 ) //握手
        {
            //硬件ID
        }
        else if ( function == 0x05 ) //<0305220a afae>
        {
            NSString* cardNo = [self dateToString:[self.readCharacteristicData.data subdataWithRange:NSMakeRange(2, self.readCharacteristicData.length - 2)]];
            [self showMemberSignInView:cardNo];
        }
    }
    
    [self.readCharacteristicData clear];
}

- (void)showMemberSignInView:(NSString*)cardNo
{
    self.maskView = [[UIApplication sharedApplication].keyWindow viewWithTag:9824];
    if ( self.maskView && self.maskView.navi )
    {
        PosMachineMemberSignInViewController* viewController = self.maskView.navi.viewControllers[0];
        viewController.cardNo = cardNo;
        [viewController realoadData:TRUE];
    }
    else
    {
        self.maskView = [[PadMaskView alloc] init];
        self.maskView.tag = 9824;
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
        
        PosMachineMemberSignInViewController* viewController = [[PosMachineMemberSignInViewController alloc] initWithNibName:@"PosMachineMemberSignInViewController" bundle:nil];
        viewController.cardNo = [cardNo uppercaseString];
        viewController.maskView = self.maskView;
        
        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        self.maskView.navi.navigationBarHidden = YES;
        self.maskView.navi.view.frame = CGRectMake((1024 - 725) / 2, 0, 725, 768);
        [self.maskView addSubview:self.maskView.navi.view];
        [self.maskView show];
    }
}

- (NSString*)dateToString:(NSData*)data
{
    NSMutableString* s = [[NSMutableString alloc] init];
    
    const void *p = data.bytes;
    //0722831810
    NSUInteger cardNo = 0;
    
    for ( int i = 0; i < data.length; i++ )
    {
//#if 0
        
        //[s appendFormat:@"%02x",*(u_char*)p];
//#else
        u_char byte = *(u_char*)p++;
        cardNo = cardNo | byte << (8 * i);
//#endif
    }
    
    s = [NSMutableString stringWithFormat:@"%010u",cardNo];
    
    return s;
}

- (BOOL)isSwipeCardConnected
{
#if TARGET_IPHONE_SIMULATOR
    return FALSE;
#else
    return [BluetoothZXBLib isconnect_21];
#endif
}

- (void)connectSwipeCardDevice:(NSString*)name
{
    if ( ![self isSwipeCardConnected] )
    {
        [self.zft_qpos connectDevice:name];
    }
}

-(void)Plugin
{
//    UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"已连接" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
//    [v show];
    
    [self.delegate onSwipeCardConnect];
    
    [self performSelector:@selector(test) withObject:nil afterDelay:1];
    
}

- (void)test
{
    [self.zft_qpos giveup];
    [self.zft_qpos openCardReader:0 andScheme:@"00"];
}

-(void)PlugOut
{
    //[self performSelectorOnMainThread:@selector(StatusInText:) withObject:@"设备已断开" waitUntilDone:NO];
}

-(void)GetopenCardReader:(NSString *)openStr
{
    if([openStr isEqualToString:@"06"])
    {
#if !TARGET_IPHONE_SIMULATOR
        [[BluetoothZXBLib getInstance] doGetCardNum];
#endif
    }
    else
    {
        [self performSelector:@selector(test) withObject:nil afterDelay:1];
    }
}

- (void)GetCardNumber:(NSString *)cardNumber
{
    [self performSelector:@selector(test) withObject:nil afterDelay:1];
    [self showMemberSignInView:cardNumber];
}

- (void)DiscoverDevice:(NSDictionary *)device
{
    if ( [device[@"name"] isEqualToString:self.swipeCard.deviceName] )
    {
        [self connectSwipeCardDevice:self.swipeCard.deviceName];
    }
}
@end
