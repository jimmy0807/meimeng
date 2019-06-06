//
//  PadBindViewController.m
//  meim
//
//  Created by 波恩公司 on 2018/7/23.
//

#import "PadBindViewController.h"
#import "PadProjectConstant.h"
#import "CBLoadingView.h"
#import "BSMemberCardOperateRequest.h"
#import "PadCardOperateCell.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <ACSBluetooth/ACSBluetooth.h>
#import "ABDHex.h"
#import "BSUserDefaultsManager.h"
#import "BSEditMemberCardRequest.h"

@interface PadBindViewController ()<ABTBluetoothReaderManagerDelegate, ABTBluetoothReaderDelegate,CBCentralManagerDelegate>
{
    CBCentralManager *_centralManager;
    CBPeripheral *_peripheral;
    ABTBluetoothReader *_bluetoothReader;
    ABTBluetoothReaderManager *_bluetoothReaderManager;
    NSData *_commandApdu;
    NSData *_masterKey;
}

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) UITableView *bindTableView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *remarkstr;

@end


@implementation PadBindViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard
{
    self = [super initWithNibName:@"PadBindViewController" bundle:nil];
    if (self)
    {
        self.memberCard = memberCard;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _bluetoothReaderManager = [[ABTBluetoothReaderManager alloc] init];
    _bluetoothReaderManager.delegate = self;
    _commandApdu = [ABDHex byteArrayFromHexString:@"FF CA 00 00 00"];

    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSEditMemberCardResponse];

    self.bindTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight + 60.0, self.view.frame.size.width, IC_SCREEN_HEIGHT - kPadNaviHeight - 32.0 - 60.0 - 60.0 - 32.0) style:UITableViewStylePlain];
    self.bindTableView.backgroundColor = [UIColor clearColor];
    self.bindTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bindTableView.delegate = self;
    self.bindTableView.dataSource = self;
    self.bindTableView.showsVerticalScrollIndicator = NO;
    self.bindTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.bindTableView];
    
    CGFloat originY = self.view.frame.size.height - 32.0 - 60.0 - 32.0;
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, originY - 0.5, self.view.frame.size.width, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [self.view addSubview:lineImageView];
    originY += 32.0;
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = [UIColor clearColor];
    self.confirmButton.frame = CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0);
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    [self.confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, 60.0)];
//    headerView.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
//    [self.view addSubview:headerView];
//
//    UIImage *checkImage = [UIImage imageNamed:@"pad_check_n"];
//    UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(24.0, (60.0 - checkImage.size.height)/2.0, checkImage.size.width, checkImage.size.height)];
//    checkImageView.backgroundColor = [UIColor clearColor];
//    checkImageView.image = checkImage;
//    [headerView addSubview:checkImageView];
    
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + checkImage.size.width + 12.0, (60.0 - 20.0)/2.0, self.view.frame.size.width - 2 * 24.0 - checkImage.size.width - 12.0, 20.0)];
//    headerLabel.backgroundColor = [UIColor clearColor];
//    headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
//    headerLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
//    headerLabel.text = [NSString stringWithFormat:LS(@"PadMasterCardNum"), self.memberCard.cardNumber];
//    [headerView addSubview:headerLabel];
    
    UIImage *naviImage = [UIImage imageNamed:@"pad_navi_background"];
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, naviImage.size.height)];
    navi.backgroundColor = [UIColor clearColor];
    navi.image = naviImage;
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_n"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_h"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.alpha = 1.0;
    [navi addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, 0.0, self.view.frame.size.width - 2 * kPadNaviHeight, kPadNaviHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = @"绑卡";
    [navi addSubview:titleLabel];
    
    [self refreshConfirmButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self stopScanPos];
    [self performSelector:@selector(startScanPos) withObject:nil afterDelay:0.5];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self startScanPos];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ( _peripheral != nil )
    {
        [_centralManager cancelPeripheralConnection:_peripheral];
    }
    
    [super viewWillDisappear: animated];
}

- (void)didBackButtonClick:(id)sender
{
    [self stopScanPos];
//    _centralManager = nil;
//    _bluetoothReaderManager = nil;
    [self.maskView hidden];
    [_bluetoothReader detach];
}

- (void)didConfirmButtonClick:(id)sender
{
    if (self.cardNumber.length == 0)
    {
        return;
    }
    
    BSEditMemberCardRequest *request = [[BSEditMemberCardRequest alloc] initWithCard:self.memberCard];
    request.params = @{@"default_code":self.cardNumber};
    [request execute];
    
    
    //[self stopScanPos];

}
    
- (void)refreshConfirmButton
{
    if (self.cardNumber.length == 0)
    {
        self.confirmButton.enabled = NO;
    }
    else
    {
        self.confirmButton.enabled = YES;
    }
    
    self.confirmButton.enabled = YES;
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSEditMemberCardResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self stopScanPos];
            [self.maskView hidden];
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadCardOperateCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PadCardOperateCellIdentifier";
    PadCardOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PadCardOperateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentTextField.tag = 1000 + indexPath.row;
        cell.contentTextField.delegate = self;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString: @"请刷卡！卡号会显示在这里" attributes: @{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:cell.contentTextField.font}];
        cell.contentTextField.attributedPlaceholder = attrString;
        cell.contentTextField.textAlignment = NSTextAlignmentCenter;
        //cell.contentTextField.placeholder = @"请刷卡！卡号会显示在这里";
    }
    
    cell.titleLabel.text = @"";
    cell.contentTextField.text = self.cardNumber;
    [self refreshConfirmButton];
    
    return cell;
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self refreshConfirmButton];
}

#pragma mark -
#pragma mark Connect to Pos Machine


- (void)startScanPos
{
    //_peripheral =
    [_centralManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)stopScanPos
{
    [_centralManager stopScan];
}

#pragma mark - Bluetooth Reader Manager

- (void)bluetoothReaderManager:(ABTBluetoothReaderManager *)bluetoothReaderManager didDetectReader:(ABTBluetoothReader *)reader peripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        
    } else {
        
        // Store the Bluetooth reader.
        _bluetoothReader = reader;
        _bluetoothReader.delegate = self;
        
        // Attach the peripheral to the Bluetooth reader.
        [_bluetoothReader attachPeripheral:peripheral];
    }
}

- (void)bluetoothReader:(ABTBluetoothReader *)bluetoothReader didAttachPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        
    } else {
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"The reader is attached to the peripheral successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        [_bluetoothReader authenticateWithMasterKey:_masterKey];
        
        
    }
}

- (void)bluetoothReader:(ABTBluetoothReader *)bluetoothReader didAuthenticateWithError:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        
    } else {
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"The reader is authenticated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        if ([_bluetoothReader isKindOfClass:[ABTAcr1255uj1Reader class]]) {
            
            uint8_t command[] = { 0xE0, 0x00, 0x00, 0x40, 0x01 };
            
            [_bluetoothReader transmitEscapeCommand:command length:sizeof(command)];
        }
    }
}

- (void)bluetoothReader:(ABTBluetoothReader *)bluetoothReader didReturnResponseApdu:(NSData *)apdu error:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        
    } else {
        
        // Show the response APDU.
        //self.responseApduLabel.text = [ABDHex hexStringFromByteArray:apdu];
        
        NSString *newString = [[ABDHex hexStringFromByteArray:apdu] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ( newString.length > 4 )
        {
            NSString* testString = [newString substringFromIndex:newString.length - 4];
            if ( [testString isEqualToString:@"9000"] )
            {
                newString = [newString substringToIndex:newString.length - 4];
            }
        }
        self.cardNumber = newString;
        [self.bindTableView reloadData];
    }
}

- (void)bluetoothReader:(ABTBluetoothReader *)bluetoothReader didReturnCardStatus:(ABTBluetoothReaderCardStatus)cardStatus error:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        
    } else {
        
        // Show the card status.
        [self ABD_stringFromCardStatus:cardStatus];
    }
}

- (void)bluetoothReader:(ABTBluetoothReader *)bluetoothReader didChangeCardStatus:(ABTBluetoothReaderCardStatus)cardStatus error:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        
    } else {
        
        // Show the card status.
        [self ABD_stringFromCardStatus:cardStatus];
        //        [self.tableView reloadData];
    }
}

- (NSString *)ABD_stringFromCardStatus:(ABTBluetoothReaderCardStatus)cardStatus {
    
    NSString *string = nil;
    
    switch (cardStatus) {
            
        case ABTBluetoothReaderCardStatusUnknown:
            string = @"Unknown";
            break;
            
        case ABTBluetoothReaderCardStatusAbsent:
            string = @"Absent";
            break;
            
        case ABTBluetoothReaderCardStatusPresent:
            string = @"Present";
            
            [_bluetoothReader transmitApdu:_commandApdu];
            
            break;
            
        case ABTBluetoothReaderCardStatusPowered:
            string = @"Powered";
            break;
            
        case ABTBluetoothReaderCardStatusPowerSavingMode:
            string = @"Power Saving Mode";
            break;
            
        default:
            string = @"Unknown";
            break;
    }
    
    return string;
}

#pragma mark - Central Manager

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    static BOOL firstRun = YES;
    NSString *message = nil;
    
    switch (central.state) {
            
        case CBCentralManagerStateUnknown:
        case CBCentralManagerStateResetting:
            message = @"The update is being started. Please wait until Bluetooth is ready.";
            break;
            
        case CBCentralManagerStateUnsupported:
            message = @"This device does not support Bluetooth low energy.";
            break;
            
        case CBCentralManagerStateUnauthorized:
            message = @"This app is not authorized to use Bluetooth low energy.";
            break;
            
        case CBCentralManagerStatePoweredOff:
            if (!firstRun) {
                message = @"You must turn on Bluetooth in Settings in order to use the reader.";
            }
            break;
            
        default:
            break;
    }
    
    if (message != nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bluetooth" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    firstRun = NO;
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    // If the peripheral is not found, then add it to the array.
    if ([[[BSUserDefaultsManager sharedManager].mPadPosMachineRecord objectForKey:@"name"] isEqualToString:peripheral.name]) {
        
        _masterKey = [ABDHex byteArrayFromHexString:@"41 43 52 31 32 35 35 55 2D 4A 31 20 41 75 74 68"];
        _peripheral = peripheral;
        [_centralManager connectPeripheral:_peripheral options:nil];
        
    }
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    // Detect the Bluetooth reader.
    [_bluetoothReaderManager detectReaderWithPeripheral:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    // Show the error
    if (error != nil) {
        //[self ABD_showError:error];
        [self stopScanPos];
        [self performSelector:@selector(startScanPos) withObject:nil afterDelay:0.5];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"连接失败，请重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (error != nil) {
        
        // Show the error
        //[self ABD_showError:error];
        [self stopScanPos];
        [self performSelector:@selector(startScanPos) withObject:nil afterDelay:0.5];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"设备断开" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    } else {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"The reader is disconnected successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
    }
}

@end
