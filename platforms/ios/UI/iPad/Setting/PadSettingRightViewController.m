//
//  PadSettingRightViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <NetworkExtension/NetworkExtension.h>
#import "PadSettingRightViewController.h"
#import "UIImage+Resizable.h"
#import "PadSettingViewController.h"
#import "BSPadPeripheral.h"
#import "CBBluetoothManager.h"
#import "BSUserDefaultsManager.h"
#import "PosAccountManager.h"
#import "PadLoginViewController.h"
#import "CBRotateNavigationController.h"
#import "BSFetchUsers.h"
#import "BSFetchPosConfigRequest.h"
#import "PosMachineManager.h"
//#import "meim-Swift.h"
#ifdef meim_dev
#import "meim_dev-Swift.h"
#else
#import "meim-Swift.h"
#endif
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "SSDPService.h"
#import "SSDPServiceBrowser.h"
#import "SSDPServiceTypes.h"
#import "CamFiClient.h"
#import "PadHandWriteBookVC.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperation.h"
#import "ResetIPManager.h"
#import "CamFiServerInfo.h"

#define kPadSettingDetailCellHeight     60.0
#define kPadSettingDetailHeaderHeight   36.0
#define kPadSettingDetailFooterHeight   64.0

#define kPadSettingDetailBLHeaderHeight 64.0

typedef enum kPadDeviceSectionType
{
    kPadDeviceSectionCurrent,
    kPadDeviceSectionDeviceList,
    kPadDeviceSectionCount
}kPadDeviceSectionType;

typedef enum kPadPayAccountSectionType
{
    kPadPayAccountWholeMachine,
    kPadPayAccountBluetoothMachine,
    kPadPayAccountSectionCount
}kPadPayAccountSectionType;

typedef enum kPadDeviceConnectedRowType
{
    kPadDeviceConnectedCurrent,
    kPadDeviceConnectedRowCount
}kPadDeviceConnectedRowType;

typedef enum BSPadDeviceConnectType
{
    BSPadDeviceConnectDefault,
    BSPadDeviceConnectStarting,
    BSPadDeviceConnectSuccess,
    BSPadDeviceConnectHasSet,
    BSPadDeviceConnectFailed,
    BSPadDeviceConnectNotFound
}BSPadDeviceConnectType;

typedef enum kPadPayAccountOperateType
{
    kPadPayAccountDefault,
    kPadPayAccountAddAccount,
    kPadPayAccountAccountExist
}kPadPayAccountOperateType;

@interface PadSettingRightViewController () <CBBluetoothManagerDelegate, PosMachineManagerDelegate, SSDPServiceBrowserDelegate>

@property (nonatomic, assign) kPadSettingDetailType type;
@property (nonatomic, assign) BSPadDeviceConnectType connectType;
@property (nonatomic, strong) CBBluetoothManager *bluetoothManager;

@property (nonatomic, assign) kPadPayAccountOperateType audioType;
@property (nonatomic, assign) kPadPayAccountOperateType bluetoothType;

@property (nonatomic, strong) NSMutableArray *devices;
@property (nonatomic, strong) BSPadPeripheral *printer;
@property (nonatomic, strong) BSPadPeripheral *codeScanner;
@property (nonatomic, strong) BSPadPeripheral *posMachine;

@property (nonatomic, strong) PersonalProfile *profile;
@property (nonatomic, strong) CDUser *userinfo;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *contentButton;
@property (nonatomic, strong) UIScrollView *accountScrollView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *detailTableView;

@property (nonatomic, strong) NSString *wmUserName;
@property (nonatomic, strong) NSString *wmPassword;
@property (nonatomic, strong) NSString *blUserName;
@property (nonatomic, strong) NSString *blPassword;

@property (nonatomic, strong) NSMutableData *readCharacteristicData;
@property (nonatomic) BOOL didSelectCamera;
@property (nonatomic) BOOL isCameraBridgeModeOn;
@property (nonatomic) int cameraSelectIndex;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) NSString *cameraName;
@property (nonatomic, strong) NSMutableArray *cameraList;
@property (nonatomic, strong) NSString *cameraIP;
@property (nonatomic, strong) NSMutableArray *wifiList;
@property (nonatomic, strong) NSString *joinWifiName;
@property (nonatomic, strong) NSString *encryptMode;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic) BOOL didSetWifiPassword;

@property (nonatomic, strong) SSDPServiceBrowser* browser;
@property (nonatomic, strong) NSMutableArray* clientArray;
@property (nonatomic) kPadSettingDetailType currentType;


@end

@implementation PadSettingRightViewController

- (id)initWithDelegate:(id<PadSettingRightViewControllerDelegate>)delegate
{
    self = [super initWithNibName:@"PadSettingRightViewController" bundle:nil];
    if (self)
    {
        self.delegate = delegate;
        self.wmUserName = @"";
        self.wmPassword = @"";
        self.blUserName = @"";
        self.blPassword = @"";
        self.devices = [NSMutableArray array];
        self.readCharacteristicData = [NSMutableData data];
        self.cameraList = [NSMutableArray array];
        self.browser = [[SSDPServiceBrowser alloc] initWithServiceType:SSDPServiceType_UPnP_CamFi];
        self.browser.delegate = self;
        self.clientArray = [NSMutableArray array];
        self.wifiList = [NSMutableArray array];
        self.type = kPadSettingDetailDefault;
        self.audioType = kPadPayAccountDefault;
        
        if ([PosAccountManager getAudioUserName].length != 0 && [PosAccountManager getAudioPassword].length != 0)
        {
            self.audioType = kPadPayAccountAccountExist;
        }
        
        self.bluetoothType = kPadPayAccountDefault;
        if ([PosAccountManager getBLUserName].length != 0 && [PosAccountManager getBLPassword].length != 0)
        {
            self.bluetoothType = kPadPayAccountAccountExist;
        }
        
        self.profile = [PersonalProfile currentProfile];
        self.cameraName = self.profile.cameraName;
        self.cameraIP = self.profile.cameraIP;
        if (self.cameraName.length == 0) {
            self.didSelectCamera = NO;
        }
        else
        {
            self.didSelectCamera = YES;
        }
        self.isCameraBridgeModeOn = self.profile.isCameraSelected;
        self.userinfo = [[BSCoreDataManager currentManager] findEntity:@"CDUser" withValue:self.profile.userID forKey:@"user_id"];
        
        BSFetchUsers *request = [[BSFetchUsers alloc] init];
        [request execute];
        
        BSFetchPosConfigRequest *posRequest = [[BSFetchPosConfigRequest alloc] initWithPosID:self.profile.posID];
        [posRequest execute];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    self.view.bounds = CGRectMake(0.0, 0.0, kPadSettingRightSideViewWidth, IC_SCREEN_HEIGHT);
    if (self.type == kPadSettingDetailDefault)
    {
        ;
    }
    self.view.hidden = YES;
    
    [self registerNofitificationForMainThread:kBSFetchUsersResponse];
    [self registerNofitificationForMainThread:kBSFetchPayStatementResponse];
    [self registerNofitificationForMainThread:@"RefreshTableView"];
    //self.didSelectCamera= NO;
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(32.0, kPadNaviHeight, kPadSettingRightSideViewWidth - 2 * 32.0, IC_SCREEN_HEIGHT - kPadNaviHeight) style:UITableViewStyleGrouped];
    self.detailTableView.backgroundColor = [UIColor clearColor];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.showsVerticalScrollIndicator = NO;
    self.detailTableView.showsHorizontalScrollIndicator = NO;
    self.detailTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.detailTableView];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadSettingRightSideViewWidth, 16.0)];
    self.headerView.backgroundColor = [UIColor clearColor];
    self.detailTableView.tableHeaderView = self.headerView;
    
    [self initPosAccountScrollView];
    
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, kPadNaviHeight)];
    navi.backgroundColor = [UIColor whiteColor];
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, 0.0, kPadSettingRightSideViewWidth - 2 * kPadNaviHeight, kPadNaviHeight)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [navi addSubview:self.titleLabel];
    
    self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.infoButton.backgroundColor = [UIColor clearColor];
    self.infoButton.frame = CGRectMake(self.view.frame.size.width - kPadNaviHeight, 0.0, kPadNaviHeight, kPadNaviHeight);
    [self.infoButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [self.infoButton setTitleColor:COLOR(169.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
    [self.infoButton setTitle:LS(@"kPadSettingHelpInfo") forState:UIControlStateNormal];
    [self.infoButton addTarget:self action:@selector(didInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.infoButton.hidden = YES;
    [navi addSubview:self.infoButton];
    
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logoutButton.backgroundColor = [UIColor clearColor];
    self.logoutButton.frame = CGRectMake(self.view.frame.size.width - kPadNaviHeight, 0.0, kPadNaviHeight, kPadNaviHeight);
    self.logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.logoutButton setTitle:LS(@"PadAccountLogout") forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:COLOR(168.0, 205.0, 205.0, 1.0) forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(didLogoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.logoutButton.alpha = 0.0;
    [navi addSubview:self.logoutButton];
    
    self.contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.contentButton.backgroundColor = [UIColor clearColor];
    self.contentButton.frame = self.view.bounds;
    [self.contentButton addTarget:self action:@selector(didContentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.contentButton.alpha = 0.0;
    [self.view addSubview:self.contentButton];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = COLOR(255.0, 111.0, 104.0, 1.0);
    self.confirmButton.frame = CGRectMake(self.view.frame.size.width - 120.0, 0.0, 120.0, kPadNaviHeight);
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.confirmButton setTitle:LS(@"PadAccountLogoutConfirm") forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(didLogoutConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.alpha = 0.0;
    [self.view addSubview:self.confirmButton];
    
    [self initData];
    self.didSetWifiPassword = NO;
    [PosMachineManager sharedManager].delegate = self;
    
    if (self.didSelectCamera) {
        [self getWifiListByCamera];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[PosMachineManager sharedManager] active];
}

#pragma mark -
#pragma mark init Methods

- (void)initPosAccountScrollView
{
    self.accountScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, kPadSettingRightSideViewWidth, IC_SCREEN_HEIGHT - kPadNaviHeight)];
    self.accountScrollView.backgroundColor = [UIColor clearColor];
    self.accountScrollView.scrollEnabled = YES;
    self.accountScrollView.showsVerticalScrollIndicator = NO;
    self.accountScrollView.showsHorizontalScrollIndicator = NO;
    self.accountScrollView.contentSize = CGSizeMake(self.accountScrollView.frame.size.width, self.accountScrollView.frame.size.height + 4.0);
    self.accountScrollView.hidden = YES;
    [self.view addSubview:self.accountScrollView];
    
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(14.5, 16.0, self.accountScrollView.frame.size.width - 2 * 14.5, 2 * self.accountScrollView.frame.size.height)];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.image = [[UIImage imageNamed:@"pad_project_background_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    contentView.tag = 101;
    [self.accountScrollView addSubview:contentView];
    
    UIImageView *tipsBackground = [[UIImageView alloc] initWithFrame:CGRectMake(1.5, 0.0, 96.0, 24.0)];
    tipsBackground.backgroundColor = [UIColor clearColor];
    tipsBackground.image = [[UIImage imageNamed:@"pad_project_tips"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    [contentView addSubview:tipsBackground];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 0.0, 96.0 - 2 * 8.0, 24.0)];
    tipsLabel.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"pad_project_tips"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 32.0, 12.0, 32.0)]];
    tipsLabel.numberOfLines = 1;
    tipsLabel.font = [UIFont systemFontOfSize:12.0];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor whiteColor];
    NSArray *localPosOperate = [[BSCoreDataManager currentManager] fetchLocalPosOperates:@"operate_date"];
    tipsLabel.text = [NSString stringWithFormat:LS(@"PadAccountCurrentPosOperate"), localPosOperate.count];
    [tipsBackground addSubview:tipsLabel];
    
    CGSize minSize = [tipsLabel.text sizeWithFont:tipsLabel.font constrainedToSize:CGSizeMake(1024.0, tipsLabel.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat maxWidth = minSize.width;
    if (maxWidth + 16.0 >= 96.0)
    {
        maxWidth = 96.0 - 16.0;
    }
    tipsLabel.frame = CGRectMake(tipsLabel.frame.origin.x, tipsLabel.frame.origin.y, maxWidth, tipsLabel.frame.size.height);
    tipsBackground.frame = CGRectMake(tipsBackground.frame.origin.x, tipsBackground.frame.origin.y, maxWidth + 16.0, tipsBackground.frame.size.height);
    
    CGFloat originX = 68.5;
    CGFloat contentWidth = kPadSettingRightSideViewWidth - 2 * 14.5 - 2 * 68.5;
    CGFloat originY = 40.0 + 32.0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, (contentWidth - 8.0)/2.0, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = LS(@"PadAccountCashier");
    [contentView addSubview:titleLabel];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + contentWidth/2.0 + 4.0, originY, (contentWidth - 8.0)/2.0, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = LS(@"PadAccountLoginTime");
    [contentView addSubview:titleLabel];
    originY += 20.0 + 4.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, (contentWidth - 8.0)/2.0, 32.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:27.0];
    titleLabel.tag = 1001;
    [contentView addSubview:titleLabel];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + contentWidth/2.0 + 4.0, originY, (contentWidth - 8.0)/2.0, 32.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:27.0];
    titleLabel.tag = 1002;
    [contentView addSubview:titleLabel];
    originY += 32.0 + 32.0;
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY - 1.0, contentWidth, 1.0)];
    lineImageView.backgroundColor = COLOR(237.0, 239.0, 239.0, 1.0);
    [contentView addSubview:lineImageView];
    originY += 32.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = LS(@"PadAccountPointOfSale");
    [contentView addSubview:titleLabel];
    originY += 20.0 + 4.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 32.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:27.0];
    titleLabel.tag = 1003;
    [contentView addSubview:titleLabel];
    originY += 32.0 + 32.0;
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY - 1.0, contentWidth, 1.0)];
    lineImageView.backgroundColor = COLOR(237.0, 239.0, 239.0, 1.0);
    [contentView addSubview:lineImageView];
    originY += 32.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = LS(@"PadAccountMembershipCardIncome");
    [contentView addSubview:titleLabel];
    originY += 20.0 + 4.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 32.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:27.0];
    titleLabel.text = [NSString stringWithFormat:LS(@"PadAccountAmount"), 1000.0];
    titleLabel.tag = 1004;
    [contentView addSubview:titleLabel];
    originY += 32.0 + 32.0;
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY - 1.0, contentWidth, 1.0)];
    lineImageView.backgroundColor = COLOR(237.0, 239.0, 239.0, 1.0);
    [contentView addSubview:lineImageView];
    originY += 32.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = LS(@"PadAccountBankCardIncome");
    [contentView addSubview:titleLabel];
    originY += 20.0 + 4.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 32.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:27.0];
    titleLabel.tag = 1005;
    [contentView addSubview:titleLabel];
    originY += 32.0 + 32.0;
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY - 1.0, contentWidth, 1.0)];
    lineImageView.backgroundColor = COLOR(237.0, 239.0, 239.0, 1.0);
    [contentView addSubview:lineImageView];
    originY += 32.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = LS(@"PadAccountCashIncome");
    [contentView addSubview:titleLabel];
    originY += 20.0 + 4.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, contentWidth, 32.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:27.0];
    titleLabel.tag = 1006;
    [contentView addSubview:titleLabel];
    originY += 32.0 + 32.0;
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY - 1.0, contentWidth, 1.0)];
    lineImageView.backgroundColor = COLOR(237.0, 239.0, 239.0, 1.0);
    [contentView addSubview:lineImageView];
    
    [self reloadContentScrollView];
}

- (void)reloadContentScrollView
{
    UIImageView *contentView = (UIImageView *)[self.accountScrollView viewWithTag:101];
    UILabel *nameLabel = (UILabel *)[contentView viewWithTag:1001];
    UILabel *loginLabel = (UILabel *)[contentView viewWithTag:1002];
    UILabel *addressLabel = (UILabel *)[contentView viewWithTag:1003];
    UILabel *cardLabel = (UILabel *)[contentView viewWithTag:1004];
    UILabel *bankLabel = (UILabel *)[contentView viewWithTag:1005];
    UILabel *cashLabel = (UILabel *)[contentView viewWithTag:1006];
    
    nameLabel.text = self.userinfo.name;
    NSString *datestr = @"-";
    if (self.profile.openDate)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy.MM.dd HH:mm:ss";
        datestr = [dateFormatter stringFromDate:self.profile.openDate];
    }
    loginLabel.text = datestr;
    addressLabel.text = self.profile.posName;
    
    CDPOSPayMode *payMode = [[BSCoreDataManager currentManager] findEntity:@"CDPOSPayMode" withValue:@(kPadPayModeTypeCard) forKey:@"mode"];
    cardLabel.text = [NSString stringWithFormat:LS(@"PadAccountAmount"), payMode.incomeAmount.floatValue];
    payMode = [[BSCoreDataManager currentManager] findEntity:@"CDPOSPayMode" withValue:@(kPadPayModeTypeBankCard) forKey:@"mode"];
    bankLabel.text = [NSString stringWithFormat:LS(@"PadAccountAmount"), payMode.incomeAmount.floatValue];
    payMode = [[BSCoreDataManager currentManager] findEntity:@"CDPOSPayMode" withValue:@(kPadPayModeTypeCash) forKey:@"mode"];
    cashLabel.text = [NSString stringWithFormat:LS(@"PadAccountAmount"), payMode.incomeAmount.floatValue];
}

- (void)initData
{
    NSDictionary *dict = [BSUserDefaultsManager sharedManager].mPadPrinterRecord;
    self.printer = [[BSPadPeripheral alloc] init];
    self.printer.deviceName = [dict objectForKey:@"name"];
    self.printer.deviceUUID = [dict objectForKey:@"uuid"];
    
    dict = [BSUserDefaultsManager sharedManager].mPadCodeScannerRecord;
    self.codeScanner = [[BSPadPeripheral alloc] init];
    self.codeScanner.deviceName = [dict objectForKey:@"name"];
    self.codeScanner.deviceUUID = [dict objectForKey:@"uuid"];
    
    dict = [BSUserDefaultsManager sharedManager].mPadPosMachineRecord;
    self.posMachine = [[BSPadPeripheral alloc] init];
    self.posMachine.deviceName = [dict objectForKey:@"name"];
    self.posMachine.deviceUUID = [dict objectForKey:@"uuid"];
}

-(void)showHandWriteBookViewController{
    PadHandWriteBookVC *handWriteBookVC = [[PadHandWriteBookVC alloc]init];
    handWriteBookVC.view.frame = self.view.frame;
    [self.navigationController pushViewController:handWriteBookVC animated:YES];
}

- (void)reloadWithType:(kPadSettingDetailType)type
{
    //NSLog(@"%@",self.navigationController.viewControllers);
//    if (!self.isCameraBridgeModeOn && type != kPadSettingDetailCamera && self.currentType == kPadSettingDetailCamera) {
//        UIAlertController *alertControll = [UIAlertController alertControllerWithTitle:@"请配置网络！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        [alertControll addAction:okAction];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControll animated:YES completion:nil];
//        return;
//    }
    self.currentType = type;
    
    for (UIViewController *subVC in self.navigationController.viewControllers) {
        if ([subVC isKindOfClass:[PadHandWriteBookVC class]]) {
            [subVC.navigationController popViewControllerAnimated:YES];
        }
    }
    self.type = type;
    self.infoButton.hidden = YES;
    self.headerView.frame = CGRectMake(0.0, 0.0, kPadSettingRightSideViewWidth, 16.0);
    self.detailTableView.tableHeaderView = self.headerView;
    self.detailTableView.hidden = NO;
    self.accountScrollView.hidden = YES;
    self.logoutButton.alpha = 0.0;
    self.confirmButton.alpha = 0.0;
    if (self.type == kPadSettingDetailDefault)
    {
        self.view.hidden = YES;
        return;
    }
    else if (self.type == kPadSettingDetailHandNumber)
    {
        self.view.hidden = NO;
        self.titleLabel.text = LS(@"kPadSettingHandNumber");
        self.headerView.frame = CGRectMake(0.0, 0.0, kPadSettingRightSideViewWidth, 32.0);
        self.headerView.backgroundColor = [UIColor clearColor];
        self.detailTableView.tableHeaderView = self.headerView;
    }
    else if (self.type == kPadSettingDetailFreeCombination)
    {
        self.view.hidden = NO;
        self.titleLabel.text = LS(@"kPadSettingFreeCombination");
        self.headerView.frame = CGRectMake(0.0, 0.0, kPadSettingRightSideViewWidth, 32.0);
        self.headerView.backgroundColor = [UIColor clearColor];
        self.detailTableView.tableHeaderView = self.headerView;
    }
    else if (self.type == kPadSettingDetailBlueToothKeyBoard)
    {
        self.view.hidden = NO;
        self.titleLabel.text = @"使用蓝牙键盘";
        self.headerView.frame = CGRectMake(0.0, 0.0, kPadSettingRightSideViewWidth, 32.0);
        self.headerView.backgroundColor = [UIColor clearColor];
        self.detailTableView.tableHeaderView = self.headerView;
    }
    else if (self.type == kPadSettingDetailMultiKeshi)
    {
        self.view.hidden = NO;
        self.titleLabel.text = @"设置多科室";
        self.headerView.frame = CGRectMake(0.0, 0.0, kPadSettingRightSideViewWidth, 32.0);
        self.headerView.backgroundColor = [UIColor clearColor];
        self.detailTableView.tableHeaderView = self.headerView;
    }
    else if (self.type == kPadSettingDetailPayAccount)
    {
        self.view.hidden = NO;
        self.titleLabel.text = LS(@"PadSettingPayAccount");
    }
    else if (self.type == kPadSettingDetailPosAccount)
    {
        self.view.hidden = NO;
        self.titleLabel.text = LS(@"PadSettingPosAccount");
        self.detailTableView.hidden = YES;
        self.accountScrollView.hidden = NO;
        self.logoutButton.alpha = 1.0;
        self.confirmButton.alpha = 0.0;
    }
    else
    {
        self.view.hidden = NO;
        self.infoButton.hidden = NO;
        if (self.type == kPadSettingDetailPrinter)
        {
            self.titleLabel.text = LS(@"kPadSettingPrinter");
        }
        else if (self.type == kPadSettingDetailCodeScanner)
        {
            self.titleLabel.text = LS(@"kPadSettingCodeScanner");
        }
        else if (self.type == kPadSettingDetailPosMachine)
        {
            self.titleLabel.text = LS(@"kPadSettingPosMachine");
        }
        else if (self.type == kPadSettingDetailHandWriteBook)
        {
            self.titleLabel.text = LS(@"kPadSettingHandWriteBook");
        }
        else if (self.type == kPadSettingDetailCamera)
        {
            self.titleLabel.text = LS(@"kPadSettingCamera");
        }
        self.devices = [NSMutableArray array];
        self.connectType = BSPadDeviceConnectDefault;
        self.bluetoothManager = [CBBluetoothManager shareManager];
        self.devices = [NSMutableArray arrayWithArray:self.bluetoothManager.peripheralArray];
        BSPadPeripheral *bsPeripheral = [self currentPeripheral];
        for (int i = 0; i < self.devices.count; i++)
        {
            CBPeripheral *peripheral = [self.devices objectAtIndex:i];
            NSLog(@"peripheral.identifier = %@",peripheral.identifier);
            if ([peripheral.identifier.UUIDString isEqualToString:bsPeripheral.deviceUUID])
            {
                if ( self.type == kPadSettingDetailPrinter )
                {
                    self.printer.peripheral = peripheral;
                    if ( [PosMachineManager sharedManager].isSwipeCardConnected )
                    {
                        self.connectType = BSPadDeviceConnectSuccess;
                    }
                    else
                    {
                        self.connectType = BSPadDeviceConnectHasSet;
                    }
                }
                else
                {
                    if ( peripheral.state == CBPeripheralStateDisconnected )
                    {
                        self.connectType = BSPadDeviceConnectStarting;
                    }
                    else if ( peripheral.state == CBPeripheralStateConnecting )
                    {
                        self.connectType = BSPadDeviceConnectStarting;
                    }
                    else if ( peripheral.state == CBPeripheralStateConnected )
                    {
                        self.connectType = BSPadDeviceConnectSuccess;
                    }
                    
                    if (self.type == kPadSettingDetailPrinter)
                    {
                        self.printer.peripheral = peripheral;
                    }
                    else if (self.type == kPadSettingDetailCodeScanner)
                    {
                        self.codeScanner.peripheral = peripheral;
                    }
                    else if (self.type == kPadSettingDetailPosMachine)
                    {
                        self.posMachine.peripheral = peripheral;
                    }
                }
                
                [self.devices removeObject:peripheral];
                i--;
            }
        }
        self.bluetoothManager.delegate = self;
        if (![self.bluetoothManager isScanning])
        {
            [self.bluetoothManager startScan];
        }
        
    }
    [self.detailTableView reloadData];
}

#pragma mark -
#pragma mark Required Methods

- (void)didLogoutButtonClick:(id)sender
{
    [UIView animateWithDuration:0.24 animations:^{
        self.logoutButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.24 animations:^{
            self.confirmButton.alpha = 1.0;
            self.contentButton.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)didLogoutConfirmButtonClick:(id)sender
{
    [PersonalProfile deleteProfile];
    [[PersonalProfile currentProfile] save];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPadAccountLogoutResponse object:nil userInfo:nil];
    
    [self performSelector:@selector(delayPopToRoot) withObject:nil afterDelay:0.5];
}

- (void)delayPopToRoot
{
    //PadSettingViewController *viewController = (PadSettingViewController *)self.delegate;
    //[viewController.navigationController popToRootViewControllerAnimated:NO];
}

- (void)didContentButtonClick:(id)sender
{
    [UIView animateWithDuration:0.24 animations:^{
        self.confirmButton.alpha = 0.0;
        self.contentButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.24 animations:^{
            self.logoutButton.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }];
}


#pragma mark -
#pragma mark NSNotification Methods
- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchUsersResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.userinfo = [[BSCoreDataManager currentManager] findEntity:@"CDUser" withValue:self.profile.userID forKey:@"user_id"];
            [self reloadContentScrollView];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchPayStatementResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self reloadContentScrollView];
        }
    }
    else if ([notification.name isEqualToString:@"RefreshTableView"])
    {
        [self.detailTableView reloadData];
    }
}


#pragma mark -
#pragma mark CBBluetoothManagerDelegate Methods

- (BSPadPeripheral *)currentPeripheral
{
    BSPadPeripheral *peripheral = nil;
    if (self.type == kPadSettingDetailPrinter)
    {
        peripheral = self.printer;
    }
    else if (self.type == kPadSettingDetailCodeScanner)
    {
        peripheral = self.codeScanner;
    }
    else if (self.type == kPadSettingDetailPosMachine)
    {
        peripheral = self.posMachine;
    }
    
    return peripheral;
}

- (void)setCurrentPeripheral:(CBPeripheral *)peripheral
{
    if (self.type == kPadSettingDetailPrinter)
    {
        self.printer.peripheral = peripheral;
    }
    else if (self.type == kPadSettingDetailCodeScanner)
    {
        self.codeScanner.peripheral = peripheral;
    }
    else if (self.type == kPadSettingDetailPosMachine)
    {
        self.posMachine.peripheral = peripheral;
    }
}

- (BOOL)shouldCancelPeripheralConnection:(CBPeripheral *)peripheral
{
    NSInteger count = 0;
    if ([self.printer.deviceUUID isEqualToString:peripheral.identifier.UUIDString])
    {
        count++;
    }
    if ([self.codeScanner.deviceUUID isEqualToString:peripheral.identifier.UUIDString])
    {
        count++;
    }
    if ([self.posMachine.deviceUUID isEqualToString:peripheral.identifier.UUIDString])
    {
        count++;
    }
    
    if (count <= 1)
    {
        return YES;
    }
    
    return NO;
}

- (void)didInfoButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadSettingInfoWithType:)])
    {
        [self.delegate didPadSettingInfoWithType:self.type];
    }
}


- (BOOL)isAddCurrentPrinterDevice:(CBPeripheral *)peripheral
{
    BOOL isCurrent = NO;
    if (self.printer.deviceUUID.length != 0 && [self.printer.deviceUUID isEqualToString:peripheral.identifier.UUIDString])
    {
        self.printer.peripheral = peripheral;
        if (self.type == kPadSettingDetailPrinter)
        {
            isCurrent = YES;
            self.connectType = BSPadDeviceConnectStarting;
        }
        [self.bluetoothManager connectPeripheral:self.printer.peripheral];
    }
    
    return isCurrent;
}

- (BOOL)isAddCurrentCodeScannerDevice:(CBPeripheral *)peripheral
{
    BOOL isCurrent = NO;
    if (self.codeScanner.deviceUUID.length != 0 && [self.codeScanner.deviceUUID isEqualToString:peripheral.identifier.UUIDString])
    {
        self.codeScanner.peripheral = peripheral;
        if (self.type == kPadSettingDetailCodeScanner)
        {
            isCurrent = YES;
            self.connectType = BSPadDeviceConnectStarting;
        }
        [self.bluetoothManager connectPeripheral:self.codeScanner.peripheral];
    }
    
    return isCurrent;
}

- (BOOL)isAddCurrentPosMachineDevice:(CBPeripheral *)peripheral
{
    BOOL isCurrent = NO;
    if (self.posMachine.deviceUUID.length != 0 && [self.posMachine.deviceUUID isEqualToString:peripheral.identifier.UUIDString])
    {
        self.posMachine.peripheral = peripheral;
        if (self.type == kPadSettingDetailPosMachine)
        {
            isCurrent = YES;
            self.connectType = BSPadDeviceConnectHasSet;
        }
    }
    
    return isCurrent;
}


#pragma mark -
#pragma mark CBBluetoothManagerDelegate Methods

- (void)didFindDevice:(CBPeripheral *)peripheral
{
    BOOL isCurrentPrinter = [self isAddCurrentPrinterDevice:peripheral];
    BOOL isCurrentCodeScanner = [self isAddCurrentCodeScannerDevice:peripheral];
    BOOL isCurrentPosMachine = [self isAddCurrentPosMachineDevice:peripheral];
    if (isCurrentPrinter || isCurrentCodeScanner || isCurrentPosMachine)
    {
        ;
    }
    else
    {
        [self.devices addObject:peripheral];
    }
    
    [self.detailTableView reloadData];
}

- (void)didDeviceConnect:(CBPeripheral *)peripheral
{
    BSPadPeripheral *bsPeripheral = [self currentPeripheral];
    if ([bsPeripheral.deviceUUID isEqualToString:peripheral.identifier.UUIDString])
    {
        if (bsPeripheral.peripheral.state == CBPeripheralStateConnected)
        {
            self.connectType = BSPadDeviceConnectSuccess;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (bsPeripheral.peripheral.name.length != 0) ? bsPeripheral.peripheral.name : @"", @"name",
                                    bsPeripheral.peripheral.identifier.UUIDString, @"uuid", nil];
            if (self.type == kPadSettingDetailPrinter)
            {
                [[BSUserDefaultsManager sharedManager] setMPadPrinterRecord:params];
            }
            else if (self.type == kPadSettingDetailCodeScanner)
            {
                [[BSUserDefaultsManager sharedManager] setMPadCodeScannerRecord:params];
            }
            else if (self.type == kPadSettingDetailPosMachine)
            {
                [[BSUserDefaultsManager sharedManager] setMPadPosMachineRecord:params];
            }
            bsPeripheral.deviceName = bsPeripheral.peripheral.name;
            bsPeripheral.deviceUUID = bsPeripheral.peripheral.identifier.UUIDString;
        }
        else
        {
            self.connectType = BSPadDeviceConnectFailed;
        }
        
        [self.detailTableView reloadData];
    }
    
    if ([self.printer.deviceUUID isEqualToString:peripheral.identifier.UUIDString])
    {
        self.printer.peripheral = peripheral;
    }
    if ([self.codeScanner.deviceUUID isEqualToString:peripheral.identifier.UUIDString])
    {
        self.codeScanner.peripheral = peripheral;
    }
    if ([self.posMachine.deviceUUID isEqualToString:peripheral.identifier.UUIDString])
    {
        self.posMachine.peripheral = peripheral;
        [[PosMachineManager sharedManager] didPosMachineConnect:peripheral];
    }
}

- (void)didDeviceConnectFail:(CBPeripheral *)peripheral
{
    BSPadPeripheral *bsPeripheral = [self currentPeripheral];
    if (bsPeripheral.peripheral != nil && [bsPeripheral.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString])
    {
        bsPeripheral.peripheral = peripheral;
        self.connectType = BSPadDeviceConnectFailed;
        [self.detailTableView reloadData];
    }
}

- (void)didDeviceDisconnect:(CBPeripheral *)peripheral
{
    ;
}

- (void)didFindCharacteristics:(NSArray *)characteristics
{
    ;
}

- (void)didFindPosMachineCharacteristic:(CBCharacteristic*)characteristic
{
    [[PosMachineManager sharedManager] didFindPosMachineCharacteristic:characteristic];
}

- (void)didReadCharacteristicNotify:(CBCharacteristic*)characteristic
{
    [[PosMachineManager sharedManager] didReadCharacteristicNotify:characteristic];
}

#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.type == kPadSettingDetailDefault)
    {
        return 0;
    }
    else if (self.type == kPadSettingDetailHandNumber || self.type == kPadSettingDetailFreeCombination || self.type == kPadSettingDetailBlueToothKeyBoard || self.type == kPadSettingDetailMultiKeshi)
    {
        return 1;
    }
    else if (self.type == kPadSettingDetailPayAccount)
    {
        return kPadPayAccountSectionCount;
    }
    else if (self.type == kPadSettingDetailCamera)
    {
        return 3;
    }
    else
    {
        return kPadDeviceSectionCount;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == kPadSettingDetailDefault)
    {
        return 0;
    }
    else if (self.type == kPadSettingDetailHandNumber || self.type == kPadSettingDetailFreeCombination || self.type == kPadSettingDetailBlueToothKeyBoard)
    {
        return 1;
    }
    else if (self.type == kPadSettingDetailMultiKeshi)
    {
        return 3;
    }
    else if (self.type == kPadSettingDetailPayAccount)
    {
        return 1;
    }
    else
    {
        if (section == kPadDeviceSectionCurrent)
        {
            return kPadDeviceConnectedRowCount;//1
        }
        else if (section == kPadDeviceSectionDeviceList)
        {
            ///如果是手写本
            if (self.type == kPadSettingDetailHandWriteBook && (BSWILLManager.shared.discoveredDevices.count!=0 || !BSWILLManager.shared.discoveredDevices)) {
                return BSWILLManager.shared.discoveredDevices.count;
            }
            else if (self.type == kPadSettingDetailCamera)
            {
                return 1;
            }
            else{
                return self.devices.count;
            }
            
        }
        else
        {
            if (self.type == kPadSettingDetailCamera)
            {
                if (section == 2) {
                    if (self.isCameraBridgeModeOn)
                    {
                        return self.wifiList.count;
                    }
                    else
                    {
                        return 0;
                    }
                }
                return 1;
            }
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == kPadSettingDetailPayAccount)
    {
        if ((indexPath.section == kPadPayAccountWholeMachine && self.audioType == kPadPayAccountDefault) || (indexPath.section == kPadPayAccountBluetoothMachine && self.bluetoothType == kPadPayAccountDefault))
        {
            return kPadPayAccountDefaultCellHeight;
        }
        else if ((indexPath.section == kPadPayAccountWholeMachine && self.audioType == kPadPayAccountAddAccount) || (indexPath.section == kPadPayAccountBluetoothMachine && self.bluetoothType == kPadPayAccountAddAccount))
        {
            return kPadPayAccountAddCellHeight;
        }
        else if ((indexPath.section == kPadPayAccountWholeMachine && self.audioType == kPadPayAccountAccountExist) || (indexPath.section == kPadPayAccountBluetoothMachine && self.bluetoothType == kPadPayAccountAccountExist))
        {
            return kPadPayAccountExistCellHeight;
        }
    }
    
    return kPadSettingDetailCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == kPadSettingDetailDefault)
    {
        return nil;
    }
    else if (self.type == kPadSettingDetailHandNumber || self.type == kPadSettingDetailFreeCombination || self.type == kPadSettingDetailBlueToothKeyBoard)
    {
        static NSString *CellIdentifier = @"PadSettingSwitchCellIdentifier";
        PadSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadSettingSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        
        cell.indexPath = indexPath;
        if (self.type == kPadSettingDetailHandNumber)
        {
            cell.titleLabel.text = LS(@"kPadSettingHandNumber");
            if (self.profile.isUseHandNumber.boolValue)
            {
                cell.isSwitchOn = YES;
            }
            else
            {
                cell.isSwitchOn = NO;
            }
        }
        else if (self.type == kPadSettingDetailFreeCombination)
        {
            cell.titleLabel.text = LS(@"kPadSettingFreeCombination");
            if (self.profile.isFreeCombination.boolValue)
            {
                cell.isSwitchOn = YES;
            }
            else
            {
                cell.isSwitchOn = NO;
            }
        }
        else if (self.type == kPadSettingDetailBlueToothKeyBoard)
        {
            cell.titleLabel.text = @"使用蓝牙键盘";
            if (self.profile.useBlueToothKeyBoard)
            {
                cell.isSwitchOn = YES;
            }
            else
            {
                cell.isSwitchOn = NO;
            }
        }
        
        return cell;
    }
    else if (self.type == kPadSettingDetailMultiKeshi)
    {
        static NSString *CellIdentifier = @"PadSettingDetailMultiKeshiCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            cell.delegate = self;
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"使用服务器设置";
        }
        else if (indexPath.row == 1)
        {
            [cell addSubview:line];
            cell.textLabel.text = @"单科室";
        }
        else if (indexPath.row == 2)
        {
            [cell addSubview:line];
            cell.textLabel.text = @"多科室";
        }
        NSLog(@"%d",[self.profile.multiKeshiSetting intValue]);
        if (indexPath.row == [self.profile.multiKeshiSetting intValue])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        return cell;
    }
    else if (self.type == kPadSettingDetailPayAccount)
    {
        if ((indexPath.section == kPadPayAccountWholeMachine && self.audioType == kPadPayAccountDefault) || (indexPath.section == kPadPayAccountBluetoothMachine && self.bluetoothType == kPadPayAccountDefault))
        {
            static NSString *CellIdentifier = @"PadPayAccountDefaultCellIdentifier";
            PadPayAccountDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadPayAccountDefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
            }
            
            cell.accountType = indexPath.section;
            
            return cell;
        }
        else if ((indexPath.section == kPadPayAccountWholeMachine && self.audioType == kPadPayAccountAddAccount) || (indexPath.section == kPadPayAccountBluetoothMachine && self.bluetoothType == kPadPayAccountAddAccount))
        {
            static NSString *CellIdentifier = @"PadPayAccountAddCellIdentifier";
            PadPayAccountAddCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadPayAccountAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
            }
            
            cell.accountType = indexPath.section;
            if (indexPath.section == kPadPayAccountWholeMachine)
            {
                cell.usernameTextField.text = self.wmUserName;
                cell.passwordTextField.text = self.wmPassword;
            }
            else if (indexPath.section == kPadPayAccountBluetoothMachine)
            {
                cell.usernameTextField.text = self.blUserName;
                cell.passwordTextField.text = self.blPassword;
            }
            
            return cell;
        }
        else if ((indexPath.section == kPadPayAccountWholeMachine && self.audioType == kPadPayAccountAccountExist) || (indexPath.section == kPadPayAccountBluetoothMachine && self.bluetoothType == kPadPayAccountAccountExist))
        {
            static NSString *CellIdentifier = @"PadPayAccountExistCellIdentifier";
            PadPayAccountExistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadPayAccountExistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
            }
            
            cell.accountType = indexPath.section;
            if (indexPath.section == kPadPayAccountWholeMachine)
            {
                cell.accountName = [PosAccountManager getAudioUserName];
            }
            else if (indexPath.section == kPadPayAccountBluetoothMachine)
            {
                cell.accountName = [PosAccountManager getBLUserName];
            }
            
            return cell;
        }
    }
    else if (self.type == kPadSettingDetailCamera)
    {
        if (indexPath.section == 0) {
            static NSString *CellIdentifier = @"PadSettingConnectionCellIdentifier23";
            PadSettingConnectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadSettingConnectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if ( self.didSelectCamera)
            {
                cell.titleLabel.text = @"";
                cell.titleLabel1.text = self.cameraName;
                cell.titleLabel2.text = [NSString stringWithFormat:@"IP: %@",self.profile.cameraIP];
                cell.detailLabel.text = @"已连接";
                cell.detailLabel.textColor = COLOR(96, 211, 212, 1);
            }
            else
            {
                cell.titleLabel.text = @"暂无设备";
                cell.titleLabel1.text = @"";
                cell.titleLabel2.text = @"";
                cell.detailLabel.text = @"";
                cell.detailLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
            }
            return cell;
        }
        else if (indexPath.section == 1)
        {
            if (!self.didSelectCamera) {
                static NSString *CellIdentifier = @"PadSettingDetailCameraCellIdentifier";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    //            cell.delegate = self;
                }
                cell.backgroundColor = [UIColor clearColor];
                cell.layer.cornerRadius = 6;
                cell.layer.borderColor = COLOR(197, 210, 210, 0.7).CGColor;
                cell.layer.borderWidth = 1;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 662, 65)];
                titleLabel.text = @"连接相机";
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.textColor = COLOR(96, 211, 212, 1);
                [cell addSubview:titleLabel];
                return cell;
            }
            else
            {
                static NSString *CellIdentifier = @"PadSettingSwitchCellIdentifier";
                PadSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil)
                {
                    cell = [[PadSettingSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.delegate = self;
                }
                cell.titleLabel.text = @"请配置网络";
                cell.isSwitchOn = self.isCameraBridgeModeOn;
//                if (self.profile.useBlueToothKeyBoard)
//                {
//                    cell.isSwitchOn = YES;
//                }
//                else
//                {
//                    cell.isSwitchOn = NO;
//                }
                cell.indexPath = indexPath;
                
                
                return cell;
            }
        }
        else
        {
            NSString *normalstr = @"pad_setting_cell_n";
            NSString *selectedstr = @"pad_setting_cell_h";
            
            static NSString *CameraDeviceCellIdentifier = @"PadSettingDetailCameraDeviceCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CameraDeviceCellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CameraDeviceCellIdentifier];
                cell.frame = CGRectMake(0, 0, 660, 60);
            }
            NSLog(@"%@",self.profile.cameraWIFI);
            if ([self.wifiList[indexPath.row] isEqualToString:self.profile.cameraWIFI]) {
                cell.imageView.image = [UIImage imageNamed:@"yimei_blue_check_n"];
            }
            else
            {
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
                UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                cell.imageView.image = blank;
            }
            cell.textLabel.text = self.wifiList[indexPath.row];
            
            if ( self.wifiList.count != 1 )
            {
                if (indexPath.row == 0)
                {
                    normalstr = @"pad_setting_cell_top_n";
                    selectedstr = @"pad_setting_cell_top_h";
                }
                else if (indexPath.row == self.devices.count - 1)
                {
                    normalstr = @"pad_setting_cell_bottom_n";
                    selectedstr = @"pad_setting_cell_bottom_h";
                }
                else
                {
                    normalstr = @"pad_setting_cell_content_n";
                    selectedstr = @"pad_setting_cell_content_h";
                }
            }
            
            UIImageView *normalImageView = [[UIImageView alloc] init];
            normalImageView.backgroundColor = [UIColor clearColor];
            normalImageView.image = [[UIImage imageNamed:normalstr] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
            cell.backgroundView = normalImageView;
            UIImageView *selectedImageView = [[UIImageView alloc] init];
            selectedImageView.backgroundColor = [UIColor clearColor];
            selectedImageView.image = [[UIImage imageNamed:selectedstr] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
            cell.selectedBackgroundView = selectedImageView;
    
            return cell;
        }
    }
    else
    {
        static NSString *CellIdentifier = @"PadSettingConnectionCellIdentifier";
        PadSettingConnectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadSettingConnectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSString *normalstr = @"pad_setting_cell_n";
        NSString *selectedstr = @"pad_setting_cell_h";
        if (indexPath.section == kPadDeviceConnectedCurrent)
        {
            BSPadPeripheral *bsPeripheral = [self currentPeripheral];
            if (bsPeripheral.peripheral != nil)
            {
                cell.titleLabel.text = (bsPeripheral.peripheral.name.length != 0) ? bsPeripheral.peripheral.name : bsPeripheral.peripheral.identifier.UUIDString;
                if (self.connectType == BSPadDeviceConnectDefault)
                {
                    if (bsPeripheral.peripheral.state == CBPeripheralStateConnecting)
                    {
                        cell.detailLabel.text = LS(@"kPadSettingConnecting");
                    }
                    else if (bsPeripheral.peripheral.state == CBPeripheralStateConnected)
                    {
                        cell.detailLabel.text = LS(@"kPadSettingConnected");
                    }
                    else if (bsPeripheral.peripheral.state == BSPadDeviceConnectHasSet)
                    {
                        cell.detailLabel.text = LS(@"kPadSettingConnectHasSet");
                    }
                    else
                    {
                        cell.detailLabel.text = @"";
                    }
                }
                else if (self.connectType == BSPadDeviceConnectStarting)
                {
                    cell.detailLabel.text = LS(@"kPadSettingConnecting");
                }
                else if (self.connectType == BSPadDeviceConnectSuccess)
                {
                    cell.detailLabel.text = LS(@"kPadSettingConnected");
                }
                else if (self.connectType == BSPadDeviceConnectHasSet)
                {
                    cell.detailLabel.text = LS(@"kPadSettingConnectHasSet");
                }
                else if (self.connectType == BSPadDeviceConnectFailed)
                {
                    cell.detailLabel.text = LS(@"kPadSettingConnectionFailed");
                }
                else if (self.connectType == BSPadDeviceConnectNotFound)
                {
                    cell.detailLabel.text = LS(@"kPadSettingDeviceNotFound");
                }
            }
            else
            {
                if (bsPeripheral.deviceName.length != 0 || bsPeripheral.deviceUUID != 0)
                {
                    cell.titleLabel.text = (bsPeripheral.deviceName.length != 0) ? bsPeripheral.deviceName : bsPeripheral.deviceUUID;
                    cell.detailLabel.text = LS(@"kPadSettingSearchDevice");
                    if (self.connectType == BSPadDeviceConnectHasSet)
                    {
                        cell.detailLabel.text = LS(@"kPadSettingConnectHasSet");
                    }
                    else if (self.connectType == BSPadDeviceConnectNotFound)
                    {
                        cell.detailLabel.text = LS(@"kPadSettingDeviceNotFound");
                    }
                }
                else
                {
                    cell.titleLabel.text = LS(@"暂无设备");
                    cell.detailLabel.text = @"";
                }
            }
        }
        else if (indexPath.section == kPadDeviceSectionDeviceList)
        {
            if (self.devices.count != 1)
            {
                if (indexPath.row == 0)
                {
                    normalstr = @"pad_setting_cell_top_n";
                    selectedstr = @"pad_setting_cell_top_h";
                }
                else if (indexPath.row == self.devices.count - 1)
                {
                    normalstr = @"pad_setting_cell_bottom_n";
                    selectedstr = @"pad_setting_cell_bottom_h";
                }
                else
                {
                    normalstr = @"pad_setting_cell_content_n";
                    selectedstr = @"pad_setting_cell_content_h";
                }
            }
    
            CBPeripheral *peripheral = [self.devices objectAtIndex:indexPath.row];
            cell.titleLabel.text = (peripheral.name.length != 0) ? peripheral.name : peripheral.identifier.UUIDString;
        }
        
        UIImageView *normalImageView = [[UIImageView alloc] init];
        normalImageView.backgroundColor = [UIColor clearColor];
        normalImageView.image = [[UIImage imageNamed:normalstr] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        cell.backgroundView = normalImageView;
        UIImageView *selectedImageView = [[UIImageView alloc] init];
        selectedImageView.backgroundColor = [UIColor clearColor];
        selectedImageView.image = [[UIImage imageNamed:selectedstr] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        cell.selectedBackgroundView = selectedImageView;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BSPadPeripheral *bsPeripheral = [self currentPeripheral];
    if (self.type == kPadSettingDetailMultiKeshi)
    {
        self.profile.multiKeshiSetting = [NSNumber numberWithInt:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kBSPadDidMultiKeshiChange" object:nil userInfo:nil];
    }
    if (self.type == kPadSettingDetailCamera)
    {
        if (indexPath.section == 0) {
            return;
        }
        else if (indexPath.section == 1)
        {
            if (self.didSelectCamera) {
                return;
            }
            [self fetchCameraDevice];
            return;
        }
        else
        {
            self.joinWifiName = self.wifiList[indexPath.row];
            [self showInputWIFIPasswordView];
            return;
        }
    }
    if (indexPath.section == kPadDeviceConnectedCurrent)
    {
        if (bsPeripheral.peripheral != nil)
        {
            if (bsPeripheral.peripheral.state == CBPeripheralStateConnected)
            {
                if (self.connectType != BSPadDeviceConnectSuccess)
                {
                    self.connectType = BSPadDeviceConnectSuccess;
                    [self.detailTableView reloadData];
                }
            }
            else
            {
                self.connectType = BSPadDeviceConnectStarting;
                [self.bluetoothManager connectPeripheral:bsPeripheral.peripheral];
            }
        }
        else if (bsPeripheral.deviceUUID.length != 0)
        {
            BOOL isExist = NO;
            for (int i = 0; i < self.bluetoothManager.peripheralArray.count; i++)
            {
                CBPeripheral *peripheral = [self.bluetoothManager.peripheralArray objectAtIndex:i];
                if ([peripheral.identifier.UUIDString isEqualToString:bsPeripheral.deviceUUID])
                {
                    isExist = YES;
                    if (self.type == kPadSettingDetailPrinter)
                    {
                        self.connectType = BSPadDeviceConnectStarting;
                        [self setCurrentPeripheral:peripheral];
                        [[PosMachineManager sharedManager] connectSwipeCardDevice:peripheral.name];
                    }
                    else
                    {
                        self.connectType = BSPadDeviceConnectStarting;
                        [self setCurrentPeripheral:peripheral];
                        [self.bluetoothManager connectPeripheral:peripheral];
                    }
                    
                    break;
                }
            }
            
            if (!isExist)
            {
                self.connectType = BSPadDeviceConnectNotFound;
            }
            [self.detailTableView reloadData];
        }
    }
    else if (indexPath.section == kPadDeviceSectionDeviceList)
    {
        CBPeripheral *peripheral = [self.devices objectAtIndex:indexPath.row];
        [self.devices removeObjectAtIndex:indexPath.row];
        
        if (bsPeripheral.peripheral != nil)
        {
            [self.devices insertObject:bsPeripheral.peripheral atIndex:0];
            if ([self shouldCancelPeripheralConnection:bsPeripheral.peripheral])
            {
                [self.bluetoothManager cancelPeripheralConnection:bsPeripheral.peripheral];
            }
        }
        
        if (peripheral.state == CBPeripheralStateConnected)
        {
            self.connectType = BSPadDeviceConnectSuccess;
            if (self.type == kPadSettingDetailPosMachine)
            {
                self.connectType = BSPadDeviceConnectHasSet;
                [self.bluetoothManager cancelPeripheralConnection:peripheral];
                
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                        (peripheral.name.length != 0) ? peripheral.name : @"", @"name",
                                        peripheral.identifier.UUIDString, @"uuid", nil];
                [[BSUserDefaultsManager sharedManager] setMPadPosMachineRecord:params];
            }
        }
        else
        {
            self.connectType = BSPadDeviceConnectStarting;
            if ( self.type == kPadSettingDetailPrinter )
            {
                [[PosMachineManager sharedManager] connectSwipeCardDevice:peripheral.name];
                self.printer.peripheral = peripheral;
            }
            else
            {
                [self.bluetoothManager connectPeripheral:peripheral];
            }
            
        }
        [self setCurrentPeripheral:peripheral];
        
       
    }
    
    [self.detailTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.type == kPadSettingDetailDefault || self.type == kPadSettingDetailHandNumber || self.type == kPadSettingDetailFreeCombination || self.type == kPadSettingDetailBlueToothKeyBoard || self.type == kPadSettingDetailMultiKeshi)
    {
        return 0;
    }
    else if (self.type == kPadSettingDetailPayAccount)
    {
        if (section == kPadPayAccountWholeMachine)
        {
            return kPadSettingDetailHeaderHeight;
        }
        else if (section == kPadPayAccountBluetoothMachine)
        {
            return kPadSettingDetailBLHeaderHeight;
        }
    }
    else
    {
        return kPadSettingDetailHeaderHeight;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.type == kPadSettingDetailPayAccount)
    {
        if (section == kPadPayAccountWholeMachine)
        {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadSettingRightSideViewWidth, kPadSettingDetailHeaderHeight)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:14.0];
            titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
            titleLabel.text = LS(@"kPadPayAccountWholeMachine");
            
            return titleLabel;
        }
        else if (section == kPadPayAccountBluetoothMachine)
        {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadSettingRightSideViewWidth, kPadSettingDetailBLHeaderHeight)];
            headerView.backgroundColor = [UIColor clearColor];
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, (kPadSettingDetailBLHeaderHeight - kPadSettingDetailHeaderHeight - 1.0)/2.0, kPadSettingRightSideViewWidth, 1.0)];
            lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
            [headerView addSubview:lineImageView];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, kPadSettingDetailBLHeaderHeight - kPadSettingDetailHeaderHeight, kPadSettingRightSideViewWidth, kPadSettingDetailHeaderHeight)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:14.0];
            titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
            titleLabel.text = LS(@"kPadPayAccountBluetoothMachine");
            [headerView addSubview:titleLabel];
            
            return headerView;
        }
    }
    else if (self.type == kPadSettingDetailMultiKeshi)
    {
        return nil;
    }
    else
    {
        if (self.type == kPadSettingDetailCamera && section == 1)
        {
            return nil;
        }
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadSettingRightSideViewWidth, kPadSettingDetailHeaderHeight)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        if (section == kPadDeviceSectionCurrent)
        {
            titleLabel.text = LS(@"PadCurrentDevice");
        }
        else if (section == kPadDeviceSectionDeviceList)
        {
            NSString *str = @"";
            if (self.type == kPadSettingDetailPrinter)
            {
                str = LS(@"kPadSettingPrinter");
            }
            else if (self.type == kPadSettingDetailCodeScanner)
            {
                str = LS(@"kPadSettingCodeScanner");
            }
            else if (self.type == kPadSettingDetailPosMachine)
            {
                str = LS(@"kPadSettingPosMachine");
            }
            else if (self.type == kPadSettingDetailHandWriteBook)
            {
                str = LS(@"kPadSettingHandWriteBook");
            }
            else if (self.type == kPadSettingDetailCamera)
            {
                str = LS(@"kPadSettingCamera");
            }
            titleLabel.text = [NSString stringWithFormat:LS(@"PadSelectDevice"), str];
        }
        else
        {
            if (self.isCameraBridgeModeOn && self.didSelectCamera)
            {
                titleLabel.text = @"选取网络...";
            }
        }
        
        return titleLabel;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.type == kPadSettingDetailHandNumber || self.type == kPadSettingDetailFreeCombination || self.type == kPadSettingDetailBlueToothKeyBoard )
    {
        return kPadSettingDetailFooterHeight;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.type == kPadSettingDetailHandNumber || self.type == kPadSettingDetailFreeCombination || self.type == kPadSettingDetailBlueToothKeyBoard )
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadSettingLeftSideViewWidth - 2 * 32.0, kPadSettingDetailFooterHeight)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        titleLabel.numberOfLines = 0;
        if (self.type == kPadSettingDetailHandNumber)
        {
            titleLabel.text = LS(@"kPadHandHandNumberRemindInfo");
        }
        else if (self.type == kPadSettingDetailFreeCombination)
        {
            titleLabel.text = LS(@"kPadFreeCombinationRemindInfo");
        }
        else if (self.type == kPadSettingDetailBlueToothKeyBoard)
        {
            titleLabel.text = @"如果您正在使用蓝牙键盘, 请开启此项";
        }
        
        CGSize minSize = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(kPadSettingLeftSideViewWidth - 2 * 32.0, kPadSettingDetailFooterHeight) lineBreakMode:NSLineBreakByWordWrapping];
        titleLabel.frame = CGRectMake(0.0, 0.0, kPadSettingRightSideViewWidth - 2 * 32.0, minSize.height);
        
        return titleLabel;
    }
    
    return nil;
}


#pragma mark -
#pragma mark PadPayAccountDefaultCellDelegate Methods

- (void)didPadPayAccountAddButtonClick:(PadPayAccountDefaultCell *)cell
{
    if (cell.accountType == kPadSettingPayAccountWholeMachine)
    {
        self.audioType = kPadPayAccountAddAccount;
    }
    else if (cell.accountType == kPadSettingPayAccountBluetoothMachine)
    {
        self.bluetoothType = kPadPayAccountAddAccount;
    }
    
    [self.detailTableView reloadData];
}


#pragma mark -
#pragma mark PadPayAccountAddCellDelegate Methods

- (void)didPadPayAccountConfirmButtonClick:(PadPayAccountAddCell *)cell
{
    if (cell.accountType == kPadSettingPayAccountWholeMachine)
    {
        [PosAccountManager setAudioUserName:self.wmUserName password:self.wmPassword];
        self.audioType = kPadPayAccountAccountExist;
        
        self.wmUserName = @"";
        self.wmPassword = @"";
    }
    else if (cell.accountType == kPadSettingPayAccountBluetoothMachine)
    {
        [PosAccountManager setBLUserName:self.blUserName password:self.blPassword];
        self.bluetoothType = kPadPayAccountAccountExist;
        
        self.blUserName = @"";
        self.blPassword = @"";
    }
    
    [self.detailTableView reloadData];
}

- (void)padPayAccountAddCell:(PadPayAccountAddCell *)cell didTextFieldEndEdit:(UITextField *)textField
{
    if (cell.accountType == kPadSettingPayAccountWholeMachine)
    {
        if (textField.tag == 101)
        {
            self.wmUserName = textField.text;
        }
        else if (textField.tag == 102)
        {
            self.wmPassword = textField.text;
        }
    }
    else if (cell.accountType == kPadSettingPayAccountBluetoothMachine)
    {
        if (textField.tag == 101)
        {
            self.blUserName = textField.text;
        }
        else if (textField.tag == 102)
        {
            self.blPassword = textField.text;
        }
    }
}


#pragma mark -
#pragma mark PadPayAccountExistCellDelegate Methods

- (void)didPadPayAccountDeleteButtonClick:(PadPayAccountExistCell *)cell
{
    if (cell.accountType == kPadSettingPayAccountWholeMachine)
    {
        [PosAccountManager deleteAudioUserName];
        self.audioType = kPadPayAccountDefault;
    }
    else if (cell.accountType == kPadSettingPayAccountBluetoothMachine)
    {
        [PosAccountManager deleteBLUserName];
        self.bluetoothType = kPadPayAccountDefault;
    }
    
    [self.detailTableView reloadData];
}


#pragma mark -
#pragma mark PadSettingSwitchCellDelegate Methods

- (void)didPadSettingSwitchButtonClick:(PadSettingSwitchCell *)cell
{
    if (self.type == kPadSettingDetailHandNumber)
    {
        self.profile.isUseHandNumber = [NSNumber numberWithBool:cell.isSwitchOn];
        [self.profile save];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSPadDidHandNumberChange object:nil userInfo:nil];
    }
    else if (self.type == kPadSettingDetailFreeCombination)
    {
        self.profile.isFreeCombination = [NSNumber numberWithBool:cell.isSwitchOn];
        [self.profile save];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSPadDidFreeCombinationChange object:nil userInfo:nil];
    }
    else if (self.type == kPadSettingDetailBlueToothKeyBoard)
    {
        self.profile.useBlueToothKeyBoard = cell.isSwitchOn;
        [self.profile save];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSPadDidBlueToothKeyBoardChange object:nil userInfo:nil];
    }
    else if (self.type == kPadSettingDetailCamera)
    {
        self.isCameraBridgeModeOn = cell.isSwitchOn;
        if (cell.isSwitchOn) {
            [self getWifiListByCamera];
        }
        else
        {
            //[self changeCameraToAPMode];
            //[self.wifiList removeAllObjects];
            [self.detailTableView reloadData];
        }
        //[self.detailTableView reloadData];
    }
}

-(void)onSwipeCardConnect
{
    [self reloadWithType:self.type];
    [self.detailTableView reloadData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                (self.printer.peripheral.name.length != 0) ? self.printer.peripheral.name : @"", @"name",
                                self.printer.peripheral.identifier.UUIDString, @"uuid", nil];
    [[BSUserDefaultsManager sharedManager] setMPadPrinterRecord:params];
}


- (NSString *)getWifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

-(void)fetchCameraDevice
{
    //NSLog(@"%@",[self getWifiName]);
    NSString *wifiName = [self getWifiName];
    if ([wifiName containsString:@"CamFi"])
    {
        self.isCameraBridgeModeOn = NO;
        [self getCameraName:[self getIPAddress]];
        [self performSelector:@selector(showCameraList) withObject:nil afterDelay:5.0];
    }
    else
    {
        self.isCameraBridgeModeOn = YES;
        [self getCameraListAlreadySet];
        [self performSelector:@selector(searchCameraListResult) withObject:nil afterDelay:2.0];
    }
    
    if (self.maskView == nil)
    {
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        self.maskView.backgroundColor = COLOR(0, 0, 0, 0.4);
    }
    else
    {
        for (UIView *view in self.maskView.subviews)
        {
            [view removeFromSuperview];
        }
        [self.maskView removeFromSuperview];
    }
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(242, 74, 540, 620)];
    infoView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 540, 85)];
    titleLabel.text = @"搜索设备";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = COLOR(37, 37, 37, 1);
    [infoView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 85, 540, 1)];
    line.backgroundColor = COLOR(178, 178, 178, 1);
    [infoView addSubview:line];
    
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 159, 220, 220)];
    centerImageView.image = [UIImage imageNamed:@"pad_setting_wifi"];
    [infoView addSubview:centerImageView];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 408, 540, 30)];
    statusLabel.text = @"正在搜索当前网络中的 CamFi";
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = [UIFont systemFontOfSize:24];
    statusLabel.textColor = COLOR(96, 211, 212, 1);
    [infoView addSubview:statusLabel];
    
    UILabel *netnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 448, 540, 14)];
    netnameLabel.text = [NSString stringWithFormat:@"网络名：%@",wifiName];
    netnameLabel.textAlignment = NSTextAlignmentCenter;
    netnameLabel.font = [UIFont systemFontOfSize:14];
    netnameLabel.textColor = COLOR(37, 37, 37, 1);
    [infoView addSubview:netnameLabel];
    
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(219, 479, 20, 20)];
    loadingView.color = COLOR(54, 165, 271, 1);
    [loadingView startAnimating];
    [infoView addSubview:loadingView];
    
    UILabel *waitingLabel = [[UILabel alloc] initWithFrame:CGRectMake(247, 479, 240, 14)];
    waitingLabel.text = @"等待中……";
    waitingLabel.textAlignment = NSTextAlignmentLeft;
    waitingLabel.font = [UIFont systemFontOfSize:14];
    waitingLabel.textColor = COLOR(37, 37, 37, 1);
    [infoView addSubview:waitingLabel];
    
    [self.maskView addSubview:infoView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
}

- (NSString *)getCameraName:(NSString *)ipAddress
{
    
    NSMutableArray *array = [[self getIPAddress] componentsSeparatedByString:@"."];
    if (array.count < 4) {
        return nil;
    }
    array[3] = @"67";
    self.cameraIP = [array componentsJoinedByString:@"."];
    self.profile.cameraIP = [NSString stringWithString:self.cameraIP];
    [self.profile save];
    NSLog(@"%@",array);
    [self.cameraList removeAllObjects];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/networkmode", self.cameraIP]];
    
    //2.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //3.根据会话对象创建一个Task(发送请求）
    /*
        第一个参数：请求路径
        第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
        data：响应体信息（期望的数据）
        response：响应头信息，主要是对服务器端的描述
        error：错误信息，如果请求失败，则error有值
        注意：
        1）该方法内部会自动将请求路径包装成一个请求对象，该请求对象默认包含了请求头信息和请求方法（GET）
        2）如果要发送的是POST请求，则不能使用该方法
    */
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //5.解析数据
        if (data != nil)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict != nil) {
                NSLog(@"%@",dict);
                WeakSelf
                weakSelf.cameraName = [dict objectForKey:@"ap_ssid"];
                [weakSelf.cameraList addObject:weakSelf.cameraName];
            }
            else
            {
            
            }
        }
    }];
    
    //4.执行任务
    [dataTask resume];
    NSString *str = nil;
    return str;
}

-(void)getCameraListAlreadySet
{
    [self.browser stopBrowsingForServices];
    [self.cameraList removeAllObjects];
    [self.clientArray removeAllObjects];
    [self.browser startBrowsingForServices];
    [self performSelector:@selector(stopBrowser) withObject:nil afterDelay:5.0];
}

-(void)searchCameraListResult
{
    if (self.clientArray.count == 0)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadSettingInfoWithType:)])
        {
            [self.maskView removeFromSuperview];
            [self.delegate didPadSettingInfoWithType:self.type];
        }
    }
}

-(void)showCameraList
{
    if(self.cameraList.count == 0)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadSettingInfoWithType:)])
        {
            [self.maskView removeFromSuperview];
            [self.delegate didPadSettingInfoWithType:self.type];
        }
        return;
    }
    
    if (self.maskView == nil)
    {
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        self.maskView.backgroundColor = COLOR(0, 0, 0, 0.4);
    }
    else
    {
        for (UIView *view in self.maskView.subviews)
        {
            [view removeFromSuperview];
        }
        [self.maskView removeFromSuperview];
    }
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(242, 74, 540, 620)];
    infoView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 540, 85)];
    titleLabel.text = @"装置";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = COLOR(37, 37, 37, 1);
    [infoView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 85, 540, 1)];
    line.backgroundColor = COLOR(178, 178, 178, 1);
    [infoView addSubview:line];
    
    UILabel *chooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 196, 540, 30)];
    chooseLabel.text = @"选择设备";
    chooseLabel.textAlignment = NSTextAlignmentCenter;
    chooseLabel.font = [UIFont systemFontOfSize:36];
    chooseLabel.textColor = COLOR(37, 37, 37, 1);
    [infoView addSubview:chooseLabel];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(120, 267, 300, 148)];
    mainView.layer.cornerRadius = 8;
    mainView.layer.borderColor = COLOR(178, 178, 178, 1).CGColor;
    mainView.layer.borderWidth = 1;
    self.cameraSelectIndex = 0;
    UIScrollView *deviceListScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 12, 300, 124)];
    for (int i = 0; i < self.cameraList.count; i++ )
    {
        if (self.cameraList.count == 0) {
            break;
        }
        else
        {
            self.cameraName = self.cameraList[self.cameraSelectIndex];
        }
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, i*31, 300, 31)];
        if (i == self.cameraSelectIndex)
        {
            button.backgroundColor = COLOR(96, 211, 212, 1);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:COLOR(96, 211, 212, 1) forState:UIControlStateNormal];
        }
        button.tag = i;
        [button setTitle:self.cameraList[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectCamera:) forControlEvents:UIControlEventTouchUpInside];
        [deviceListScrollView addSubview:button];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, i*31+30, 300, 1)];
        line.backgroundColor = COLOR(178, 178, 178, 1);
        //[deviceListScrollView addSubview:line];
    }
    [mainView addSubview:deviceListScrollView];
    [infoView addSubview:mainView];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(222, 508, 97, 40)];
    confirmButton.backgroundColor = COLOR(96, 211, 212, 1);
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmCamera) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:confirmButton];
    
    [self.maskView addSubview:infoView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
}

-(void)selectCamera:(UIButton *)button
{
    self.cameraSelectIndex = button.tag;
    [self showCameraList];
}

-(void)confirmCamera
{
    [self.maskView removeFromSuperview];
    self.didSelectCamera = YES;
    if (self.cameraList.count > self.cameraSelectIndex) {
        self.cameraName = self.cameraList[self.cameraSelectIndex];
    }
    if (self.clientArray.count > self.cameraSelectIndex && self.didSelectCamera && self.isCameraBridgeModeOn) {
        self.cameraIP = ((CamFiClient *)self.clientArray[self.cameraSelectIndex]).servicePath;
    }
    self.profile.cameraName = [NSString stringWithString:self.cameraName];
    self.profile.cameraIP = [NSString stringWithString:self.cameraIP];
    [self getWifiListByCamera];
    [self.profile save];
    [self.detailTableView reloadData];
    
    [[ResetIPManager sharedInstance] reload];
    [CamFiServerInfo sharedInstance].serverIP = self.cameraIP;
}

-(void)getWifiListByCamera
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/iwlist", self.cameraIP]];
    
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
////    NSDictionary *params = @{
////                             @"uuid":@"4e3abc0f-1824-4a5d-982f-7d9dee92d9cd",
////                             @"referrer":@"http://www.jianshu.com/p/e15592ce40ae"
////                             };
//    NSURLSessionDataTask *task = [manager GET:[NSString stringWithFormat:@"http://%@/iwlist", newIP] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"返回数据：%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"返回错误：%@",error);
//    }];
//    //NSURLSessionDataTask *task = [manager POST:@"http://www.jianshu.com//notes/e15592ce40ae/mark_viewed.json" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"进度更新");
////    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        NSLog(@"返回数据：%@",responseObject);
////    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////        NSLog(@"返回错误：%@",error);
////    }];
//    [task resume];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //5.解析数据
        if (data != nil)
        {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (array.count > 0) {
                WeakSelf
                [weakSelf.wifiList removeAllObjects];
                for(NSDictionary *dict in array)
                {
                    if (![dict isKindOfClass:[NSDictionary class]])
                    {
                        break;
                    }
                    NSLog(@"%@",dict);
                    if ([dict objectForKey:@"ssid"] != nil && [dict objectForKey:@"authentication"] != nil)
                    {
                        [weakSelf.wifiList addObject:[dict objectForKey:@"ssid"]];
                        weakSelf.encryptMode = [dict objectForKey:@"authentication"];
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTableView" object:nil];
                //[weakSelf.detailTableView reloadData];
                //            weakSelf.cameraName = [dict objectForKey:@"ap_ssid"];
                //            [weakSelf.cameraList addObject:weakSelf.cameraName];
            }
            else
            {
                
            }
        }
        else
        {

        }
        
    }];
    [dataTask resume];
}

-(void)network
{
    
//    if (@available(iOS 11.0, *)) {
//        [[NEHotspotConfigurationManager sharedManager] getConfiguredSSIDsWithCompletionHandler:^(NSArray * array) {
//
//            for(NSString* str in array) {
//
//                NSLog(@"结果：%@",str);
//
//            }
//
//        }];
//    } else {
//        // Fallback on earlier versions
//    }
//    NSArray * networkInterfaces = [NEHotspotHelper supportedNetworkInterfaces];
//
//    NSLog(@"Networks %@",networkInterfaces);
//
//    //获取wifi列表
//
//    for(NEHotspotNetwork *hotspotNetwork in [NEHotspotHelper supportedNetworkInterfaces]) {
//
//        NSString *ssid = hotspotNetwork.SSID;
//
//        NSString *bssid = hotspotNetwork.BSSID;
//
//        BOOL secure = hotspotNetwork.secure;
//
//        BOOL autoJoined = hotspotNetwork.autoJoined;
//
//        double signalStrength = hotspotNetwork.signalStrength;
//
//    }
    
//    NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
//
//    [options setObject:@"hanmiao" forKey:kNEHotspotHelperOptionDisplayName];//这里写的是你的副标题
//
//    dispatch_queue_t queue = dispatch_queue_create("com.born.boss.test", 0);//你的bundle id－如果没有申请下来写的话－ －里面的内容是获取不到的
//
//    BOOL returnType = [NEHotspotHelper registerWithOptions:options queue:queue handler:^(NEHotspotHelperCommand * cmd){
//
//        [cmd createResponse:kNEHotspotHelperResultAuthenticationRequired];
//
//        if(cmd.commandType == kNEHotspotHelperCommandTypeEvaluate || cmd.commandType == kNEHotspotHelperCommandTypeFilterScanList){
//
//            NSLog(@"bbbb = %lu",cmd.networkList.count);
//
//            for(NEHotspotNetwork* network in cmd.networkList){ //下面是获取系统wifi的信心
//
//                NSString* ssid = network.SSID;//ssid - wifi名字
//
//                NSString* bssid = network.BSSID;//bssid 相当于apmac
//
//                BOOL secure = network.secure;//是否加密
//
//                BOOL autoJoined = network.autoJoined;
//
//                double signalStrength = network.signalStrength;//信号的强弱
//
//                NSLog(@"SSID:%@ # BSSID:%@ # SIGNAL:%f ",ssid,bssid,signalStrength);
//
//            }
//
//               }
//
//    }];
//
//    NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
//    [options setObject:@"kNEHotspotHelperOptionDisplayName" forKey:kNEHotspotHelperOptionDisplayName];
//
//     dispatch_queue_t queue = dispatch_queue_create("com.myapp.ex", NULL);
//     BOOL returnType = [NEHotspotHelper registerWithOptions:options queue:queue handler: ^(NEHotspotHelperCommand * cmd) {
//        NEHotspotNetwork* network;
//        NSLog(@"COMMAND TYPE:   %ld", (long)cmd.commandType);
//        [cmd createResponse:kNEHotspotHelperResultAuthenticationRequired];
//        if (cmd.commandType == kNEHotspotHelperCommandTypeEvaluate || cmd.commandType ==kNEHotspotHelperCommandTypeFilterScanList) {
//            NSLog(@"WIFILIST:   %@", cmd.networkList);
//
//            for (network  in cmd.networkList) {
//
//                NSLog(@"COMMAND TYPE After:   %ld", (long)cmd.commandType);
//
//                if ([network.SSID isEqualToString:@"ssid"]|| [network.SSID isEqualToString:@"WISPr Hotspot"]) {
//
//                    double signalStrength = network.signalStrength;
//                    NSLog(@"Signal Strength: %f", signalStrength);
//                    [network setConfidence:kNEHotspotHelperConfidenceHigh];
//                    [network setPassword:@"password"];
//
//                    NEHotspotHelperResponse *response = [cmd createResponse:kNEHotspotHelperResultSuccess];
//                    NSLog(@"Response CMD %@", response);
//
//                    [response setNetworkList:@[network]];
//                    [response setNetwork:network];
//                    [response deliver];
//                }
//            }
//        }
//
//    }];
//
//     NSLog(@"result :%d", returnType);
//
//     NSArray *array = [NEHotspotHelper supportedNetworkInterfaces];
//
//     NSLog(@"wifiArray:%@", array);
//
//     NEHotspotNetwork *connectedNetwork = [array lastObject];
//
//     NSLog(@"supported Network Interface: %@", connectedNetwork);
}

-(void)changeCameraToAPMode
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //"mode":"sta", "router_ssid":foo, "password":foo, "encryption"
    NSDictionary *params = @{@"mode":@"ap"};
    [manager POST:[NSString stringWithFormat:@"http://%@/networkmode",self.cameraIP] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"返回数据：%@",responseObject);
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
        NSLog(@"the response state code is %ld", (long)urlResponse.statusCode);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"返回错误：%@",error);
    }];
}

-(void)changeCameraToBridgeMode:(NSString *)router_ssid withPassword:(NSString *)password
{
    WeakSelf
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //"mode":"sta", "router_ssid":foo, "password":foo, "encryption"
//    [manager POST:[NSString stringWithFormat:@"http://%@/networkmode",self.cameraIP] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"返回数据：%@",responseObject);
//        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
//        NSLog(@"the response state code is %ld", (long)urlResponse.statusCode);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"返回错误：%@",error);
//    }];
    NSDictionary *params = @{@"mode":@"sta",@"router_ssid":router_ssid,@"password":password,@"encryption":@"psk2"};

    NSData * data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString * json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //字典转Json串 为了方便，避免自己拼串出错]]
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/networkmode",self.cameraIP]]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //]]
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    //]]
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功]]
        NSLog(@"返回数据：%@",responseObject);
        UIAlertController *alertControll = [UIAlertController alertControllerWithTitle:@"请重启CamFi后等待信号灯亮后再点击确定" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.didSelectCamera = NO;
            weakSelf.isCameraBridgeModeOn = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTableView" object:nil];
        }];
        [alertControll addAction:okAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControll animated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败
        NSLog(@"返回错误：%@",error);
    }];
    [operation start];
}

-(void)showInputWIFIPasswordView
{
    if (self.maskView == nil)
    {
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        self.maskView.backgroundColor = COLOR(0, 0, 0, 0.4);
    }
    else
    {
        for (UIView *view in self.maskView.subviews)
        {
            [view removeFromSuperview];
        }
        [self.maskView removeFromSuperview];
    }
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(242, 30, 540, 470)];
    infoView.backgroundColor = COLOR(242, 245, 245, 1);
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540, 85)];
    topView.backgroundColor = [UIColor whiteColor];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 540, 18)];
    topLabel.text = [NSString stringWithFormat:@"输入“%@”的密码", self.joinWifiName];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont boldSystemFontOfSize:14];
    topLabel.textColor = COLOR(37, 37, 37, 1);
    [topView addSubview:topLabel];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 540, 57)];
    titleLabel.text = @"输入密码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = COLOR(37, 37, 37, 1);
    [topView addSubview:titleLabel];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(18, 45, 40, 20)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR(0, 92, 255, 1) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelPassword) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelButton];
    
    UIButton *joinButton = [[UIButton alloc] initWithFrame:CGRectMake(480, 45, 40, 20)];
    [joinButton setTitle:@"加入" forState:UIControlStateNormal];
    [joinButton setTitleColor:COLOR(0, 92, 255, 1) forState:UIControlStateNormal];
    [joinButton addTarget:self action:@selector(joinWifi) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:joinButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 85, 540, 1)];
    line.backgroundColor = COLOR(178, 178, 178, 1);
    [topView addSubview:line];
    [infoView addSubview:topView];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(20, 117, 500, 65)];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.layer.cornerRadius = 8;
    mainView.layer.borderColor = COLOR(197, 210, 210, 0.7).CGColor;
    mainView.layer.borderWidth = 1;
    
    UILabel *passwordTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 76, 65)];
    passwordTitle.text = @"密码";
    passwordTitle.textAlignment = NSTextAlignmentCenter;
    passwordTitle.textColor = COLOR(37, 37, 37, 1);
    passwordTitle.font = [UIFont systemFontOfSize:16];
    [mainView addSubview:passwordTitle];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(76, 0, 400, 65)];
    self.passwordTextField.secureTextEntry = NO;
    [self.passwordTextField becomeFirstResponder];
    [mainView addSubview:self.passwordTextField];
    [infoView addSubview:mainView];
    
    [self.maskView addSubview:infoView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
}

- (void)cancelPassword
{
    [self.maskView removeFromSuperview];
}

- (void)joinWifi
{
    [self.maskView removeFromSuperview];
    [self changeCameraToBridgeMode:self.joinWifiName withPassword:self.passwordTextField.text];
    self.didSetWifiPassword = YES;
    self.profile.cameraWIFI = self.joinWifiName;
    self.profile.isCameraSelected = YES;
    [self.profile save];
}

- (void)stopBrowser
{
    [self.browser stopBrowsingForServices];
}

#pragma mark - SSDP browser delegate methods

- (void) ssdpBrowser:(SSDPServiceBrowser *)browser didNotStartBrowsingForServices:(NSError *)error {
    
    NSLog(@"SSDP Browser got error: %@", error);
}

- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didFindService:(SSDPService *)service {
    
    NSLog(@"SSDP Browser found: %@", service.servicePath);
    [self.clientArray addObject:[CamFiClient camfiClientWithSSDPService:service]];
    for (CamFiClient *client in self.clientArray)
    {
//        NSLog(@"%@", client.ssid);
//        NSLog(@"%@", client.servicePath);
//        NSLog(@"%@", client.username);
//        NSLog(@"%@", client.password);
//        NSLog(@"%@", client.channel);
        
        [self.cameraList addObject:client.ssid];
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:self.cameraList.count];
    
    [self.cameraList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [dict setValue:obj forKey:obj];
        
    }];
    
    self.cameraList = [NSMutableArray arrayWithArray:dict.allValues];
    
    [self performSelector:@selector(showCameraList) withObject:nil afterDelay:1.0];
}

-(void)ssdpBrowser:(SSDPServiceBrowser *)browser didRemoveService:(SSDPService *)service
{
    NSLog(@"SSDP Browser didRemove: %@", service);
}
@end
