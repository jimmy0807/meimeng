//
//  PersonalProfile.h
//  ScanQR
//
//  Created by jimmy on 13-11-7.
//  Copyright (c) 2013年 jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSCoreDataManager+Customized.h"

typedef enum RoleOption
{
    RoleOption_boss = 1,
    RoleOption_shopManager = 2,
    RoleOption_shopIncome = 4,
    RoleOption_waiter = 5,
    RoleOption_consultant,//顾问
    RoleOption_beauty,//美疗师
}RoleOption;

@interface PersonalProfile : NSObject<NSCoding>
@property(nonatomic, strong)NSNumber* isLogin;
@property(nonatomic, strong)NSDate* loginDate;

@property(nonatomic, strong) NSNumber * homeSelectedShopID;
@property(nonatomic, strong) NSNumber * bshopId;
@property(nonatomic, strong) NSArray * shopIds;
@property(nonatomic, strong) NSString* userName;
@property(nonatomic, strong) NSNumber* businessId; // BNRequest.companyID
@property(nonatomic, strong) NSString* phoneNumber;
@property(nonatomic, assign) RoleOption roleOption;
@property(nonatomic, strong) NSMutableDictionary* reachItems;

@property(nonatomic, strong) NSString* baseUrl;
@property(nonatomic, strong) NSString* sql;
@property(nonatomic, strong) NSString* born_uuid;
@property(nonatomic, strong) NSNumber* userID;
@property(nonatomic, strong) NSString* password;
@property(nonatomic, strong) NSString* deviceString;
@property(nonatomic, strong) NSNumber* employeeID;
@property(nonatomic, strong) NSString* employeeName;

@property(nonatomic, strong) NSString* logoCreateDate;
@property(nonatomic, strong) NSString* email;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* writeDate;
@property(nonatomic, strong) NSString* token;

@property(nonatomic, strong) NSNumber* posID;
@property(nonatomic, strong) NSString* posName;
@property(nonatomic, strong) NSNumber* havePos;
@property(nonatomic, strong) NSNumber* sessionID;
@property(nonatomic, strong) NSDate *openDate;
@property(nonatomic, strong) NSDate *closeDate;

@property(nonatomic, strong) NSString *companyUUID;
@property(nonatomic, strong) NSString *shopUUID;
@property(nonatomic, strong) NSNumber *isLineRound;
@property(nonatomic, strong) NSNumber *roundAccuracy;

@property(nonatomic, strong) NSNumber *isAllowItem;//项目
@property(nonatomic, strong) NSNumber *isAllowArrears;//欠款
@property(nonatomic, strong) NSNumber *isPresentAmount;//赠送金额
@property(nonatomic, strong) NSNumber *isFreeCombination;//定制组合
@property(nonatomic, strong) NSNumber *multiKeshiSetting;//多科室设置
@property(nonatomic, strong) NSNumber *isUseHandNumber;  // 手牌号
@property(nonatomic, strong) NSNumber *isYiMei;//项目
@property(nonatomic) BOOL isCameraSelected;//相机
@property(nonatomic) BOOL isCameraConnected;//相机已连接

@property(nonatomic, strong) NSString *cameraName;//相机名
@property(nonatomic, strong) NSString *cameraIP;//相机地址
@property(nonatomic, strong) NSString *cameraWIFI;//相机地址

@property(nonatomic, strong) NSNumber *isBookOperate;
@property(nonatomic, strong) NSNumber *bookOperateTime;//分钟

@property(nonatomic, strong) NSNumber *isTable;
@property(nonatomic, strong) NSNumber *isTakeout;
@property(nonatomic, strong) NSNumber *isBook;
@property(nonatomic, strong) NSNumber *group_pad_order;//是否使用电子菜单

@property(nonatomic, strong) NSString *companyAddress;
@property(nonatomic, strong) NSNumber *defaultProductId;
@property(nonatomic, strong) NSString *defaultProductName;

@property(nonatomic, strong) NSNumber *is_customize_coupon; //是否可自定义卡券模板

@property(nonatomic, strong) NSString* wxcard_url;

@property(nonatomic, strong) NSArray* yimeiWorkFlowArray; //该用户的流程有哪些 比如即洗脸也可以拍照
@property(nonatomic, strong) NSString* yimeiWorkFlowName; //该用户的流程有哪些 比如即洗脸也可以拍照

//@property(nonatomic, strong) NSNumber* yimeiWorkFlowID;
@property(nonatomic, strong) NSArray* departments_ids; //操作员可以看到哪些科室
@property(nonatomic, strong) NSArray* accessModels; //操作员可以看到哪些科室
@property(nonatomic, strong) NSArray* operate_models; //操作对应的名字和id

@property(nonatomic, strong) NSString* printIP;
@property(nonatomic, strong) NSString* printType;
@property(nonatomic, strong) NSString* printUrl; //给叫号里面用的
@property(nonatomic, strong) NSNumber* printID;

@property(nonatomic) BOOL isHospital;

@property(nonatomic) BOOL useBlueToothKeyBoard;

@property(nonatomic) BOOL is_accept_see_partner;
@property(nonatomic) BOOL access_write_reservation; //是否能改别人的预约

@property(nonatomic, strong) NSString* provisionString;
@property(nonatomic, strong) NSString* promiseString;
@property(nonatomic, strong) NSString* medical_api_version;
@property(nonatomic) BOOL is_show_consume_product;

@property(nonatomic, strong) NSString* shoushuTagModifyDate;
@property(nonatomic, strong) NSString* upload_pic_url;
@property(nonatomic) BOOL is_multi_department;
@property(nonatomic) BOOL is_post_checkout;

-(NSString*)getUUID;
-(NSString*)getMD5ForUUID;

- (NSNumber*)getCurrentStoreID;
- (NSString*)getCurrentStoreName;
- (CDStore*)getCurrentStore;

+(PersonalProfile* _Nonnull)currentProfile;
-(void)save;
+(void)deleteProfile;

@end
