//
//  ZftQiposLib.h
//  ZftQiposLib
//
//  Created by rjb on 15-9-16.
//  Copyright (c) 2015年 rjb. All rights reserved.
//

#import <Foundation/Foundation.h>
#define blueDeviceName @"name"
#define blueRSSI @"RSSI"

static const int QPOS_PARAM_ERROR_NOT_ENOUGH_LENGTH = 10114;//参数长度不够
static const int QPOS_PARAM_ERROR = 10115;
@protocol ZftZXBDelegate <NSObject>

@optional
/**
 *  发生错误的回调
 *
 *  @param errmsg 错误信息
 */
- (void)Error:(NSString*)errmsg;

/**
 *  扫描到蓝牙设备后的回调:每发现一个蓝牙设备回调一次,将新发现的设备返回
 *
 *  @param device 设备信息:{@"name":设备名称(连接设备时需要),@"RSSI":信号强度(非必要)}
 */
- (void)DiscoverDevice:(NSDictionary *)device;


/**
 *  设备连接后的回调
 */
- (void)Plugin;

/**
 *  设备断开连接后的回调
 */
- (void)PlugOut;

/**
 *  获得设备ID的回调
 *
 设备版本号  DevVersion
 固件版本号  FirmVersion
 设备序列号  DevId
 电量       Adc
 */
- (void)GetTerminal:(NSString *)devVersion andFirmVersion:(NSString *)firmVersion andDevId:(NSString *)devId andAdc:(NSString *)adc;

/**
 *  更新秘钥
 *
 *  @param msg 签到状态信息
 */
- (void)DoSignInStatus:(NSString *)msg;

/**
 *  取消交易后的回调
 *
 *  @param msg 取消交易后返回信息
 */
- (void)CancleTrade:(NSString*)msg;

/**
 *  刷磁条卡的回调
 *
 *  主账号  account
 *  随机数  random
 *  2 3磁  track
 */
- (void)SwipCardAccount:(NSString *)account andRandom:(NSString *)random andTrack2:(NSString *)track2 andTrack3:(NSString *)track3;

/**
 执行结果  result
 终端交易时间  time
 随机数 random
 主账号   account
 IC卡序列号  sqn
 卡有效期  validityDate
 等效二磁数据密文  track
 55域数据 message55
 */
- (void)GetICCardResult:(NSString *)result andTime:(NSString *)time andRandom:(NSString *)random andAccount:(NSString *)account andSqn:(NSString *)sqn andValidityDate:(NSString *)validityDate andTrack:(NSString *)track andMessage:(NSString *)message55;

/**
 *   银行卡卡号的回调
 *   @param cardNumber  卡号
 */
- (void)GetCardNumber:(NSString *)cardNumber;

/**
 *  获得mac后的回调
 *
 *  @param mac mac值
 */
- (void)GetMac:(NSString *)macStr andRandom:(NSString *)ranStr;

//获得pin后的回调
-(void)OnGetPIN:(NSString *)pinStr andRandom:(NSString *)randomStr;

/**
 *  余额信息是否正确展示在设备上的回调
 *
 *  @param isRightShow 正确展示返回YES,否则返回NO
 */
- (void)GetBalance:(BOOL)isRightShow;

//开启读卡器回调   00：刷卡成功   01：刷卡成功，但有IC   02：刷卡失败  03：刷卡超时  04：IC卡已插入，但读卡失败    05：IC卡已插入  06: 行业卡刷卡成功(要调用获取卡号接口)
-(void)GetopenCardReader:(NSString *)openStr;

//取消刷卡回调   giveupCode 0表示取消成功  其他表示失败
-(void)OnGiveUp:(int)giveupCode;

@end
@interface BluetoothZXBLib : NSObject

/**
 *  sdk单例
 *
 *  @return 单例
 */
+ (BluetoothZXBLib *)getInstance;

/**
 *  设置代理
 *
 *  @param lister 遵循代理协议的代理对象
 */
- (void)setLister:(id<ZftZXBDelegate>)lister;

/**
 *  搜索设备;搜索前请停止上次搜索,已节省电量,并保证本次搜索正确执行
 */
- (void)starScan;

/**
 *  停止搜索
 */
- (void)stopScan;

/**
 *  连接设备,注:必须先调用sdk的starScan方法搜索设备,并且保证设备能够搜索到,否则将无法连接到指定的设备
 *
 *  @param name 需要连接的设备名称
 */
- (void)connectDevice:(NSString *)name;
/**
 *  断开蓝牙设备连接
 */
- (void)disconnectionDevice;
/**
 *  检测设备是否连接
 *
 *  @return 连接返回YES,否则返回NO
 */
+ (BOOL)isconnect_21;

/**
 *  发送获取terminalID的指令
 */
- (void)doGetTerminalID;

/**
 *  发送获得mac的指令
 *
 *  @param param param
 *
 *  @return mac值
 */
- (NSInteger)doGetMac:(NSString *)param;
//更新秘钥
- (NSInteger)upDataKey:(NSString *)tdkKey andMacKey:(NSString *)macKey andPinKey:(NSString *)pinKey;
//开启读卡器
-(NSInteger)openCardReader:(int)timeout andScheme:(NSString *)scheme;

/**
 *   发送获得银行卡卡号的指令
 */
-(NSInteger)doGetCardNum;
//读取磁道数据
-(void)doGetCardTrack;
//PBOC流程 读取IC卡数据  time参数为7字节(YYYYMMddHHmmss格式)
-(NSInteger)doGetICCard:(NSString *)amountString andTrandeTime:(NSString *)time andTimeOut:(int)timeOut;
//获得pin
-(NSInteger)GetPIN:(NSString *)pin;

/**
 *  进入刷卡状态后，取消刷卡状态
 */
-(void)giveup;

@end
