//
//  PersonalProfile.m
//  ScanQR
//
//  Created by jimmy on 13-11-7.
//  Copyright (c) 2013年 jimmy. All rights reserved.
//

#import "PersonalProfile.h"

#import "ICKeyChainManager.h"
#import "ICAuthentication.h"
#import "NSData+Additions.h"
#import "HomeCountData.h"

static PersonalProfile* sProfile = nil;

@interface PersonalProfile ()
@property(nonatomic, strong)NSString* localUUID;
@property(nonatomic, strong)NSString* localUUIDMD5;
@end

@implementation PersonalProfile

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.isLogin forKey:@"isLogin"];
    [coder encodeObject:self.loginDate forKey:@"loginDate"];
    
    [coder encodeObject:self.homeSelectedShopID forKey:@"homeSelectedShopID"];
    [coder encodeObject:self.bshopId forKey:@"bshopId"];
    [coder encodeObject:self.shopIds forKey:@"shopIds"];
    [coder encodeObject:self.userName forKey:@"userName"];
    [coder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [coder encodeObject:self.businessId forKey:@"businessId"];
    [coder encodeInt:self.roleOption forKey:@"roleOption"];
    [coder encodeObject:self.reachItems forKey:@"reachItems"];
    
    [coder encodeObject:self.baseUrl forKey:@"baseUrl"];
    [coder encodeObject:self.sql forKey:@"sql"];
    [coder encodeObject:self.born_uuid forKey:@"born_uuid"];
    [coder encodeObject:self.userID forKey:@"userID"];
    [coder encodeObject:self.password forKey:@"password"];
    [coder encodeObject:self.deviceString forKey:@"deviceString"];
    [coder encodeObject:self.employeeID forKey:@"employeeID"];
    
    [coder encodeObject:self.logoCreateDate forKey:@"logoCreateDate"];
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.writeDate forKey:@"writeDate"];
    [coder encodeObject:self.posID forKey:@"posID"];
    [coder encodeObject:self.posName forKey:@"posName"];
    [coder encodeObject:self.havePos forKey:@"havePos"];
    [coder encodeObject:self.sessionID forKey:@"sessionID"];
    [coder encodeObject:self.openDate forKey:@"openDate"];
    [coder encodeObject:self.closeDate forKey:@"closeDate"];
    
    [coder encodeObject:self.companyUUID forKey:@"companyUUID"];
    [coder encodeObject:self.shopUUID forKey:@"shopUUID"];
    [coder encodeObject:self.isLineRound forKey:@"isLineRound"];
    [coder encodeObject:self.roundAccuracy forKey:@"roundAccuracy"];
    
    [coder encodeObject:self.isAllowItem forKey:@"isAllowItem"];
    [coder encodeObject:self.isAllowArrears forKey:@"isAllowArrears"];
    [coder encodeObject:self.isPresentAmount forKey:@"isPresentAmount"];
    [coder encodeObject:self.isFreeCombination forKey:@"isFreeCombination"];
    [coder encodeObject:self.multiKeshiSetting forKey:@"multiKeshiSetting"];
    [coder encodeObject:self.isUseHandNumber forKey:@"isUseHandNumber"];
    [coder encodeObject:self.isBookOperate forKey:@"isBookOperate"];
    [coder encodeObject:self.isYiMei forKey:@"isYiMei"];
    [coder encodeObject:self.bookOperateTime forKey:@"bookOperateTime"];
    [coder encodeObject:self.token forKey:@"token"];
    
    [coder encodeObject:self.isTable forKey:@"isTable"];
    [coder encodeObject:self.isTakeout forKey:@"isTakeout"];
    [coder encodeObject:self.isBook forKey:@"isBook"];
    [coder encodeObject:self.companyAddress forKey:@"companyAddress"];
    [coder encodeObject:self.defaultProductId forKey:@"defaultProductId"];
    [coder encodeObject:self.defaultProductName forKey:@"defaultProductName"];
    
    [coder encodeObject:self.is_customize_coupon forKey:@"is_customize_coupon"];
    
    [coder encodeObject:self.wxcard_url forKey:@"wxcard_url"];
    
    //yimei
    [coder encodeObject:self.yimeiWorkFlowArray forKey:@"yimeiWorkFlowArray"];
    [coder encodeObject:self.yimeiWorkFlowName forKey:@"yimeiWorkFlowName"];
    //[coder encodeObject:self.yimeiWorkFlowID forKey:@"yimeiWorkFlowID"];
    [coder encodeObject:self.departments_ids forKey:@"departments_ids"];
    [coder encodeObject:self.accessModels forKey:@"accessModels"];
    [coder encodeObject:self.operate_models forKey:@"operate_models"];
    
    //打印
    [coder encodeObject:self.printIP forKey:@"printIP"];
    [coder encodeObject:self.printType forKey:@"printType"];
    [coder encodeObject:self.printUrl forKey:@"printUrl"];
    [coder encodeObject:self.printID forKey:@"printID"];
    
    //相机
    [coder encodeObject:self.cameraIP forKey:@"cameraIP"];
    [coder encodeObject:self.cameraName forKey:@"cameraName"];
    [coder encodeObject:self.cameraWIFI forKey:@"cameraWIFI"];
    [coder encodeBool:self.isCameraSelected forKey:@"isCameraSelected"];
    [coder encodeBool:self.isCameraConnected forKey:@"isCameraConnected"];
    
    //医院
    [coder encodeBool:self.isHospital forKey:@"isHospital"];
    [coder encodeBool:self.useBlueToothKeyBoard forKey:@"useBlueToothKeyBoard"];
    [coder encodeBool:self.is_accept_see_partner forKey:@"is_accept_see_partner"];
    [coder encodeBool:self.access_write_reservation forKey:@"access_write_reservation"];
    
    [coder encodeObject:self.provisionString forKey:@"provisionString"];
    [coder encodeObject:self.promiseString forKey:@"promiseString"];
    [coder encodeObject:self.medical_api_version forKey:@"medical_api_version"];
    [coder encodeBool:self.is_show_consume_product forKey:@"is_show_consume_product"];
    [coder encodeObject:self.shoushuTagModifyDate forKey:@"shoushuTagModifyDate"];
    [coder encodeObject:self.upload_pic_url forKey:@"upload_pic_url"];
    [coder encodeBool:self.is_multi_department forKey:@"is_multi_department"];
    [coder encodeBool:self.is_post_checkout forKey:@"is_post_checkout"];
    
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.isLogin = [coder decodeObjectForKey:@"isLogin"];
        self.loginDate = [coder decodeObjectForKey:@"loginDate"];
        self.homeSelectedShopID = [coder decodeObjectForKey:@"homeSelectedShopID"];
        self.bshopId = [coder decodeObjectForKey:@"bshopId"];
        self.shopIds = [coder decodeObjectForKey:@"shopIds"];
        self.userName = [coder decodeObjectForKey:@"userName"];
        self.phoneNumber = [coder decodeObjectForKey:@"phoneNumber"];
        self.businessId = [coder decodeObjectForKey:@"businessId"];
        self.roleOption = [coder decodeIntForKey:@"roleOption"];
        self.reachItems = [coder decodeObjectForKey:@"reachItems"];
        self.baseUrl = [coder decodeObjectForKey:@"baseUrl"];
        self.sql = [coder decodeObjectForKey:@"sql"];
        self.born_uuid = [coder decodeObjectForKey:@"born_uuid"];
        self.userID = [coder decodeObjectForKey:@"userID"];
        self.password = [coder decodeObjectForKey:@"password"];
        self.deviceString = [coder decodeObjectForKey:@"deviceString"];
        self.employeeID = [coder decodeObjectForKey:@"employeeID"];
        self.employeeName = [coder decodeObjectForKey:@"employeeName"];
        
        self.logoCreateDate = [coder decodeObjectForKey:@"logoCreateDate"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.writeDate = [coder decodeObjectForKey:@"writeDate"];
        self.posID = [coder decodeObjectForKey:@"posID"];
        self.posName = [coder decodeObjectForKey:@"posName"];
        self.havePos = [coder decodeObjectForKey:@"havePos"];
        self.sessionID = [coder decodeObjectForKey:@"sessionID"];
        self.openDate = [coder decodeObjectForKey:@"openDate"];
        self.closeDate = [coder decodeObjectForKey:@"closeDate"];
        
        self.companyUUID = [coder decodeObjectForKey:@"companyUUID"];
        self.shopUUID = [coder decodeObjectForKey:@"shopUUID"];
        self.isLineRound = [coder decodeObjectForKey:@"isLineRound"];
        self.roundAccuracy = [coder decodeObjectForKey:@"roundAccuracy"];
        
        self.isAllowItem = [coder decodeObjectForKey:@"isAllowItem"];
        self.isAllowArrears = [coder decodeObjectForKey:@"isAllowArrears"];
        self.isPresentAmount = [coder decodeObjectForKey:@"isPresentAmount"];
        self.isFreeCombination = [coder decodeObjectForKey:@"isFreeCombination"];
        self.multiKeshiSetting = [coder decodeObjectForKey:@"multiKeshiSetting"];
        self.isUseHandNumber = [coder decodeObjectForKey:@"isUseHandNumber"];
        self.isBookOperate = [coder decodeObjectForKey:@"isBookOperate"];
        self.isYiMei = [coder decodeObjectForKey:@"isYiMei"];
        self.bookOperateTime = [coder decodeObjectForKey:@"bookOperateTime"];
        self.token = [coder decodeObjectForKey:@"token"];
        
        self.isTable = [coder decodeObjectForKey:@"isTable"];
        self.isTakeout = [coder decodeObjectForKey:@"isTakeout"];
        self.isBook = [coder decodeObjectForKey:@"isBook"];
        self.companyAddress = [coder decodeObjectForKey:@"companyAddress"];
        self.defaultProductId = [coder decodeObjectForKey:@"defaultProductId"];
        self.defaultProductName = [coder decodeObjectForKey:@"defaultProductName"];
        
        self.is_customize_coupon = [coder decodeObjectForKey:@"is_customize_coupon"];
        
        self.wxcard_url = [coder decodeObjectForKey:@"wxcard_url"];
        
        //yimei
        self.yimeiWorkFlowArray = [coder decodeObjectForKey:@"yimeiWorkFlowArray"];
        self.yimeiWorkFlowName = [coder decodeObjectForKey:@"yimeiWorkFlowName"];
        //self.yimeiWorkFlowID = [coder decodeObjectForKey:@"yimeiWorkFlowID"];
        self.departments_ids = [coder decodeObjectForKey:@"departments_ids"];
        self.accessModels = [coder decodeObjectForKey:@"accessModels"];
        self.operate_models = [coder decodeObjectForKey:@"operate_models"];
        
        //打印
        self.printIP = [coder decodeObjectForKey:@"printIP"];
        self.printType = [coder decodeObjectForKey:@"printType"];
        self.printUrl = [coder decodeObjectForKey:@"printUrl"];
        self.printID = [coder decodeObjectForKey:@"printID"];
        
        //相机
        self.cameraIP = [coder decodeObjectForKey:@"cameraIP"];
        self.cameraName = [coder decodeObjectForKey:@"cameraName"];
        self.cameraWIFI = [coder decodeObjectForKey:@"cameraWIFI"];
        self.isCameraSelected = [coder decodeBoolForKey:@"isCameraSelected"];
        self.isCameraConnected = [coder decodeBoolForKey:@"isCameraConnected"];
        
        self.isHospital = [coder decodeBoolForKey:@"isHospital"];
        self.useBlueToothKeyBoard = [coder decodeBoolForKey:@"useBlueToothKeyBoard"];
        self.is_accept_see_partner = [coder decodeBoolForKey:@"is_accept_see_partner"];
        self.access_write_reservation = [coder decodeBoolForKey:@"access_write_reservation"];
        
        self.provisionString = [coder decodeObjectForKey:@"provisionString"];
        self.promiseString = [coder decodeObjectForKey:@"promiseString"];
        self.medical_api_version = [coder decodeObjectForKey:@"medical_api_version"];
        self.is_show_consume_product = [coder decodeBoolForKey:@"is_show_consume_product"];
        self.shoushuTagModifyDate = [coder decodeObjectForKey:@"shoushuTagModifyDate"];
        self.upload_pic_url = [coder decodeObjectForKey:@"upload_pic_url"];
        self.is_multi_department = [coder decodeObjectForKey:@"is_multi_department"];
        self.is_post_checkout = [coder decodeObjectForKey:@"is_post_checkout"];
        
    }
    
    return self;
}

+(PersonalProfile*)currentProfile
{
    if ( sProfile )
        return sProfile;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData* profileData = [userDefault valueForKey:@"UserAccount"];
    if ( profileData )
    {
        sProfile = (PersonalProfile*)[NSKeyedUnarchiver unarchiveObjectWithData:profileData];
        return sProfile;
    }
    
    return nil;
}

-(void)save
{
    sProfile = self;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject: [NSKeyedArchiver archivedDataWithRootObject:self] forKey: @"UserAccount"];
    [userDefault synchronize];
}

+(void)deleteProfile
{
    sProfile = nil;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"UserAccount"];
    [userDefault removeObjectForKey:@"secret"];
    [userDefault synchronize];
    
    [HomeCountData deleteHomeCountData];
    
    [ICKeyChainManager deleteItemForUsername:USER_Token];
    [ICKeyChainManager deleteItemForUsername:USER_Name];
    
    [[BSCoreDataManager currentManager] deleteObjects:[[BSCoreDataManager currentManager] fetchItems:@"CDBook"]];
    [[BSCoreDataManager currentManager] deleteObjects:[[BSCoreDataManager currentManager] fetchItems:@"CDMember"]];
    [[BSCoreDataManager currentManager] deleteObjects:[[BSCoreDataManager currentManager] fetchItems:@"CDPosOperate"]];
}

-(NSString*)getUUID
{
    if ( self.localUUID )
        return self.localUUID;
    
    if ( IS_SDK7 )
    {
        NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.born.app"];
        NSString *value = [shared valueForKey:@"GROUP_UUID"];
        if ( value )
        {
            [ICKeyChainManager storeUsername:@"generateUUID" andPassword:value forServiceName:IC_DEFAULT_SERVICE_NAME];
            return value;
        }
    }
    
    NSString* _uuid = [ICKeyChainManager getPasswordForUsername:@"generateUUID" forServiceName:IC_DEFAULT_SERVICE_NAME];
    if ( !_uuid )
    {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        _uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
        CFRelease(uuid);
    }
    
    if ( IS_SDK7 )
    {
        NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.born.app"];
        [shared setObject:_uuid forKey:@"GROUP_UUID"];
        [shared synchronize];
    }
    [ICKeyChainManager storeUsername:@"generateUUID" andPassword:_uuid forServiceName:IC_DEFAULT_SERVICE_NAME];
    
    self.localUUID = _uuid;
    
    return _uuid;
}

-(NSString*)getMD5ForUUID
{
    if ( self.localUUIDMD5 )
        return self.localUUIDMD5;
    
    NSData *userData = [[self getUUID] dataUsingEncoding:NSUTF8StringEncoding];
    self.localUUIDMD5 = [userData md5Hash];
    return self.localUUIDMD5;
}

- (NSNumber*)getCurrentStoreID
{
    return [self.homeSelectedShopID integerValue] > 0 ? self.homeSelectedShopID : self.bshopId;
}

- (NSString*)getCurrentStoreName
{
    return [self getCurrentStore].storeName;
}

- (CDStore*)getCurrentStore
{
    return [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:[self getCurrentStoreID] forKey:@"storeID"];
}

@end
