//
//  BossPermissionManager.h
//  Boss
//
//  Created by jimmy on 15/5/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BossReachItems_Sale       @"BossReachItems_Sale"      //销售
#define BossReachItems_Project    @"BossReachItems_Project"   //项目
#define BossReachItems_Storage    @"BossReachItems_Storage"   //仓库
#define BossReachItems_Account    @"BossReachItems_Account"   //会计
#define BossReachItems_Purchase   @"BossReachItems_Purchase"  //采购
#define BossReachItems_HR         @"BossReachItems_HR"        //人力资源
#define BossReachItems_SalePoint  @"BossReachItems_SalePoint" //销售点
#define BossReachItems_Share      @"BossReachItems_Share"     //共享
#define BossReachItems_Vip        @"BossReachItems_Vip"       //会员管理
#define BossReachItems_System     @"BossReachItems_System"    //系统管理

#define BossAccountCashier      51 //收银员
#define BossAccountUser         52 //用户
#define BossAccountManager      53 //经理

typedef enum BossPermission
{
    BossPermission_Read     = 1 << 0,
    BossPermission_Write    = 1 << 1,
    BossPermission_Create   = 1 << 2,
    BossPermission_Delete   = 1 << 3
}BossPermission;

@interface BossPermissionManager : NSObject

@property (nonatomic, assign) bool haveFetchPermission;

InterfaceSharedManager(BossPermissionManager)

-(void)fetchPermission;

-(BOOL)isReadAccess:(NSString*)item model:(NSString*)model;
-(BOOL)isWriteAccess:(NSString*)item model:(NSString*)model;
-(BOOL)isCreateAccess:(NSString*)item model:(NSString*)model;
-(BOOL)isDeleteAccess:(NSString*)item model:(NSString*)model;

@end
