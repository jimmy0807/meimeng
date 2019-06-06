//
//  PadHandWriteBookVC.m
//  meim
//
//  Created by 刘伟 on 2017/11/10.
//
#import "CBRotateNavigationController.h"
#import "PadHandWriteBookVC.h"
#import "FirstStepView.h"
#import "SecondStepView.h"
#import "ThirdStepView.h"
//#import "meim-Swift.h"
#ifdef meim_dev
#import "meim_dev-Swift.h"
#else
#import "meim-Swift.h"
#endif
#import "BaseStepView.h"
#define kPadNaviHeight                  75.0
#define kPadSettingLeftSideViewWidth    300.0
#define kPadSettingRightSideViewWidth   (IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth)
#import "FourStepView.h"
#import "SevenStepView.h"
#import "PadSettingViewController.h"

@interface PadHandWriteBookVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CBRotateNavigationController *rightNavi;
@property (nonatomic, strong) PadSettingViewController *settingVC;
@end

@implementation PadHandWriteBookVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ///开始扫描手写本设备
    [[BSWILLManager shared] startScan];
    NSLog(@"开始扫描");
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    self.view.bounds = CGRectMake(0.0, 0.0, kPadSettingRightSideViewWidth, IC_SCREEN_HEIGHT);
    
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, kPadNaviHeight)];
    navi.backgroundColor = [UIColor whiteColor];
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(navi.frame.size.width/2-45, navi.frame.size.height/2-10, 90, 20)];
    titleLabel.text = @"连接手写本";
    [navi addSubview:titleLabel];
    
    ///创建一个Label 用来显示链接到的设备
    _currentDevice = [[UILabel alloc]initWithFrame:CGRectMake(40, 40+kPadNaviHeight, 100, 20)];
    _currentDevice.text = @"当前设备";
    [self.view addSubview:_currentDevice];
    
    _connectedDevice = [[UILabel alloc]initWithFrame:CGRectMake(40, 80+kPadNaviHeight, self.view.frame.size.width - 80, 60)];
    _connectedDevice.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_connectedDevice];
    //边框
    _connectedDevice.layer.opacity=1;
    _connectedDevice.layer.borderWidth=1;
    _connectedDevice.layer.borderColor =[UIColor colorWithDisplayP3Red:236/255 green:237/255 blue:237/255 alpha:.1].CGColor;
    _connectedDevice.layer.cornerRadius = 10;
    _connectedDevice.clipsToBounds = YES;
    
    //先隐藏 等到链接成功再显示
    _currentDevice.hidden = YES;
    _connectedDevice.hidden = YES;
    
    
#if 0
    //测试咨询按钮代码
    _sevenStepView = [SevenStepView loadNibNamed:@"SevenStepView"];
    _sevenStepView.frame = CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, self.view.frame.size.height-kPadNaviHeight);
    [_sevenStepView.startZixunbutton addTarget:self action:@selector(startZixun) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sevenStepView];
    
#else
    ///第一步view
    _firstStepView = [FirstStepView loadNibNamed:@"FirstStepView"];
    _firstStepView.frame = CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, self.view.frame.size.height-kPadNaviHeight);
    [_firstStepView.nextStepButton addTarget:self action:@selector(firstStepNextButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_firstStepView];
    
    
#endif
}

///第一步中“下一步按钮”
-(void)firstStepNextButtonDidPress{
    ///开始扫描手写本设备
    [[BSWILLManager shared] startScan];
    
    //调用下一步共有方法 跳转下一个界面
    [_firstStepView nextStep];

    
    //判断默认设备ID是否存在 存在就跳到链接画面 因为需要长按手写本
    NSString *defaultDeviceID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CDLDefaultDeviceID"];
    if (defaultDeviceID)
    {
        ///第二步view
        _secondStepView = [SecondStepView loadNibNamed:@"SecondStepView"];
        _secondStepView.frame = CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, self.view.frame.size.height-kPadNaviHeight);
        [self.view addSubview:_secondStepView];
        
        //先隐藏连接中Label
        _secondStepView.connecting.hidden = YES;
        _secondStepView.connectStatus.hidden=YES;
        
//        BSWILLManager.shared.findDeviceHandler = ^(NSArray<InkDeviceInfo *> * _Nonnull Devices) {
//
//            //NSLog(@"手写本设备=%@",BSWILLManager.shared.discoveredDevices);
//            ///链接默认设备 等待用户长按手写本 再调此方法？
//            [[BSWILLManager shared] connectDefaultDeviceWithFinished:^(BOOL ret, NSString * _Nonnull message) {
//                NSLog(@"链接默认设备 message = %@",message);
//
//                if([message isEqualToString:@"Device connected"]) {
//                    ///第一次就跳到最后一个指导界面 已经连接过的话就显示设备名称
//                    [_fourStepView removeFromSuperview];
//                    _secondStepView.hidden= YES;
//                    _currentDevice.hidden = NO;
//                    _connectedDevice.hidden = NO;
//
//                    _connectedDevice.text = [NSString stringWithFormat:@"%@%@",@"   ",Devices[0].name];
//
//                }
//                else if ([message isEqualToString:@"Device connecting"]){
//                    ///用户长按 手写本按钮 显示连接中...
//                    _secondStepView.connecting.hidden = NO;
//                    _secondStepView.connectStatus.hidden=NO;
//                    [_secondStepView.connectStatus startAnimating];
//
//                }
//                else if ([message isEqualToString:@"Tap device button to confirm connection"]){
//                    [_secondStepView removeFromSuperview];
//                    ///再次点击确认界面
//                    _fourStepView = [FourStepView loadNibNamed:@"FourStepView"];
//                    _fourStepView.frame = CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, self.view.frame.size.height-kPadNaviHeight);
//                    [self.view addSubview:_fourStepView];
//                }
//                else if ([message isEqualToString:@"Failed to pair to device. Restarting scan"]){
//                    _secondStepView.connecting.hidden = YES;
//                    _secondStepView.connectStatus.hidden= YES;
//                    [_secondStepView.connectStatus stopAnimating];
//
//                }
//
//            }];
//        };
        ///创建step2界面好了 之后就开始监听是否扫描到设备
        BSWILLManager.shared.findDeviceHandler = ^(NSArray<InkDeviceInfo *> * _Nonnull Devices) {
    
            //NSLog(@"手写本设备=%@",BSWILLManager.shared.discoveredDevices);
            ///链接默认设备 等待用户长按手写本 再调此方法？
            [[BSWILLManager shared] connectingInkDevice];
            if (Devices.count>0) {
                ///弹出设备列表
                ///第3步view
                _thirdStepView = [ThirdStepView loadNibNamed:@"ThirdStepView"];
                _thirdStepView.frame = CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, self.view.frame.size.height-kPadNaviHeight);
                _thirdStepView.devicesTableView.delegate = self;
                _thirdStepView.devicesTableView.dataSource =self;
                
               
            }
    
    
        };
    }
    else{
        
        [self.view addSubview:_firstStepView];
        
        ///第3步view
        _thirdStepView = [ThirdStepView loadNibNamed:@"ThirdStepView"];
        _thirdStepView.frame = CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, self.view.frame.size.height-kPadNaviHeight);
        _thirdStepView.devicesTableView.delegate = self;
        _thirdStepView.devicesTableView.dataSource =self;
        
        ///扫描到了设备之后即可显示ThirdStepView
        ///显示手写本设备
        BSWILLManager.shared.findDeviceHandler = ^(NSArray<InkDeviceInfo *> * _Nonnull Devices) {
            NSLog(@"手写本设备=%@",BSWILLManager.shared.discoveredDevices);
            ///显示已连接设备名称
            
            ///先移除_secondStepView
            [UIView animateWithDuration:0.8 animations:^{
                _secondStepView.alpha = 0;
            } completion:^(BOOL finished) {
                [_secondStepView removeFromSuperview];
            }];
            [self.view addSubview:_thirdStepView];
        };
    }
//    ///第二步view
//    _secondStepView = [SecondStepView loadNibNamed:@"SecondStepView"];
//    //先隐藏连接中Label
//    _secondStepView.connecting.hidden = YES;
//    _secondStepView.connectStatus.hidden=YES;
//
//    ///创建step2界面
//    _secondStepView.frame = CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, self.view.frame.size.height-kPadNaviHeight);
//    _secondStepView.alpha = 0;
//    [UIView animateWithDuration:0.8 animations:^{
//        _secondStepView.alpha = 1;
//    } completion:^(BOOL finished) {
//        [self.view addSubview:_secondStepView];
//    }];
//
//    ///创建step2界面好了 之后就开始监听是否扫描到设备
//    BSWILLManager.shared.findDeviceHandler = ^(NSArray<InkDeviceInfo *> * _Nonnull Devices) {
//
//        //NSLog(@"手写本设备=%@",BSWILLManager.shared.discoveredDevices);
//        ///链接默认设备 等待用户长按手写本 再调此方法？
//        [[BSWILLManager shared] connectingInkDevice];
//        if (Devices.count>0) {
//            ///弹出设备列表
//            ///第3步view
//            _thirdStepView = [ThirdStepView loadNibNamed:@"ThirdStepView"];
//            _thirdStepView.frame = CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, self.view.frame.size.height-kPadNaviHeight);
//            _thirdStepView.devicesTableView.delegate = self;
//            _thirdStepView.devicesTableView.dataSource =self;
//            [self.view addSubview:_thirdStepView];
//        }
//
//
//    };
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return BSWILLManager.shared.discoveredDevices.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = BSWILLManager.shared.discoveredDevices[indexPath.row].name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = COLOR(96, 211, 212, 1);
    
    ///点击手写本
    InkDeviceInfo *deviceInfo = BSWILLManager.shared.discoveredDevices[indexPath.row];
    
    [[BSWILLManager shared] connectDeviceWithDeviceInfo:deviceInfo finished:^(BOOL ret, NSString * _Nonnull message) {
        //NSLog(@"ret = %d , message = %@ , deviceID = %@",ret, message,deviceInfo.deviceID);
        
        if([message isEqualToString:@"Device connecting"]){
            
            //此时用户长按手写本了
            _secondStepView.connecting.hidden = NO;
            _secondStepView.connectStatus.hidden = NO;
            [_secondStepView.connectStatus startAnimating];
            
        }
        else if ([message isEqualToString:@"Tap device button to confirm connection"])
        {
            [_thirdStepView removeFromSuperview];
            
            ///创建点击界面
            _fourStepView = [FourStepView loadNibNamed:@"FourStepView"];
            _fourStepView.frame = CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, self.view.frame.size.height-kPadNaviHeight);
            
            [self.view addSubview:_fourStepView];
  
        }
        else if([message isEqualToString:@"Device connected"]) {
            ///链接成功 调到最后一个界面
            [_fourStepView removeFromSuperview];
            _sevenStepView = [SevenStepView loadNibNamed:@"SevenStepView"];
            _sevenStepView.frame = CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, self.view.frame.size.height-kPadNaviHeight);
            [_sevenStepView.startZixunbutton addTarget:self action:@selector(startZixun) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_sevenStepView];
            
            ///保存defalutID
            [BSWILLManager shared].defaultDeviceID = deviceInfo.deviceID;
        }
    }];
}

/// "开始咨询"
-(void)startZixun{
    
    ///跳转到咨询界面 ZixunViewController
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"ZixunBoard" bundle:nil];
    UIViewController* centerViewController = [tableViewStoryboard instantiateInitialViewController];
    CBRotateNavigationController *naviController = [[CBRotateNavigationController alloc] initWithRootViewController:centerViewController];
    [naviController setNavigationBarHidden:YES animated:NO];
    [[SingletonManager sharedInstance].setttingVC.mm_drawerController setCenterViewController:naviController];
    [[SingletonManager sharedInstance].setttingVC.mm_drawerController closeDrawerAnimated:YES completion:nil];
    
    //跳转后也要刷新一下左侧的IndexTableView
    
    //[SingletonManager sharedInstance].connectingInkDevice = BSWILLManager.shared.connectingInkDevice;

}

/**
 NSLog(@"链接默认设备 message = %@",message);
 
 if([message isEqualToString:@"Device connected"]) {
 //第一次就跳到最后一个指导界面_sevenStepView 已经连接过的话就显示设备名称
 ///链接成功 调到最后一个界面
 _sevenStepView = [SevenStepView loadNibNamed:@"SevenStepView"];
 _sevenStepView.frame = CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, self.view.frame.size.height-kPadNaviHeight);
 [self.view addSubview:_sevenStepView];
 
 }
 else if ([message isEqualToString:@"Device connecting"]){
 //用户长按 手写本按钮 显示连接中...
 _secondStepView.connecting.hidden = NO;
 _secondStepView.connectStatus.hidden=NO;
 [_secondStepView.connectStatus startAnimating];
 
 }
 else if ([message isEqualToString:@"Tap device button to confirm connection"]){
 //再次点击确认界面
 _fourStepView = [FourStepView loadNibNamed:@"FourStepView"];
 _fourStepView.frame = CGRectMake(0.0, kPadNaviHeight, IC_SCREEN_WIDTH - kPadSettingLeftSideViewWidth, self.view.frame.size.height-kPadNaviHeight);
 [self.view addSubview:_fourStepView];
 }
 else if ([message isEqualToString:@"Failed to pair to device. Restarting scan"]){
 _secondStepView.connecting.hidden = YES;
 _secondStepView.connectStatus.hidden= YES;
 [_secondStepView.connectStatus stopAnimating];
 
 }
 */

@end
