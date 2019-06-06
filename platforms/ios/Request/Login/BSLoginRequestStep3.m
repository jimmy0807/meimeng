//
//  SALoginRequestStep3.m
//  ShopAssistant
//
//  Created by jimmy on 15/3/6.
//  Copyright (c) 2015年 jimmy. All rights reserved.
//
#import "BSLoginRequestStep3.h"
#import "PersonalProfile.h"
#import "BSCoreDataManager.h"
#import "HomeCountDataManager.h"
#import "BossPermissionManager.h"
#import "BSFetchPosConfigRequest.h"
#import "BSFetchPermissionModelRequest.h"
#import "FetchHomeAdvertisementReqeust.h"
#import "FetchCompanyUUIDRequest.h"
#import "BSFetchStoreListRequest.h"
#import "BSFetchStartInfoRequest.h"
#import "FetchWXCardUrlRequest.h"
#import "BSBornCategoryRequest.h"
#import "JPushManager.h"
#import "BSFetchStaffRequest.h"
#import "BSPrintPosOperateRequest.h"
#import "FetchAllKeshiRequest.h"

@implementation BSLoginRequestStep3

- (BOOL)willStart
{
    [super willStart];
//    self.needCompany = true;
    PersonalProfile* profile = [PersonalProfile currentProfile];
    self.tableName = @"res.users";
    self.filter = @[@[@"id",@"=",profile.userID]];
    self.field =  @[@"company_id",@"role_option",@"shop_id",@"shop_ids",@"pos_config", @"write_date",@"activity_ids",@"departments_ids"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSMutableDictionary *dict;
    
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *params in resultArray)
        {
            PersonalProfile *personProfile = [PersonalProfile currentProfile];
            NSMutableArray *shopIds;
            personProfile.writeDate = [params stringValueForKey:@"write_date"];
            if ([[params objectForKey:@"shop_ids"] isKindOfClass:[NSArray class]])
            {
                shopIds = [NSMutableArray arrayWithArray:[params objectForKey:@"shop_ids"]];
            }
            
            if ([[params objectForKey:@"shop_id"] isKindOfClass:[NSArray class]])
            {
                NSNumber *shopId = [[params objectForKey:@"shop_id"] objectAtIndex:0];
                personProfile.bshopId = shopId;
                if (![shopIds containsObject:shopId])
                {
                    [shopIds addObject:shopId];
                }
            }
            else
            {
                if (shopIds.count > 0)
                {
                    personProfile.bshopId = [NSNumber numberWithInteger:[[shopIds objectAtIndex:0] integerValue]];
                }
                else
                {
                    personProfile.bshopId = [NSNumber numberWithInteger:0];
                }
            }
            
            if ([[params numberValueForKey:@"role_option"] integerValue] > 0)
            {
                personProfile.roleOption = [[params numberValueForKey:@"role_option"] integerValue];
                if ( personProfile.roleOption == 3 )
                {
                    personProfile.roleOption = RoleOption_shopManager;
                }
            }
            else
            {
                personProfile.roleOption = RoleOption_waiter;
            }
            personProfile.businessId = [[params objectForKey:@"company_id"] objectAtIndex:0];
            personProfile.shopIds = shopIds;
            
            if (personProfile.reachItems == nil)
            {
                personProfile.reachItems = [NSMutableDictionary dictionary];
            }
//            [personProfile.reachItems setObject:[params objectForKey:@"sel_groups_9_38_10"] forKey:BossReachItems_Sale];
//            [personProfile.reachItems setObject:[params objectForKey:@"sel_groups_88_89"] forKey:BossReachItems_Project];
//            [personProfile.reachItems setObject:[params objectForKey:@"sel_groups_31_32"] forKey:BossReachItems_Storage];
//            [personProfile.reachItems setObject:[params objectForKey:@"sel_groups_25_26_27"] forKey:BossReachItems_Account];
//            [personProfile.reachItems setObject:[params objectForKey:@"sel_groups_54_55"] forKey:BossReachItems_Purchase];
//            [personProfile.reachItems setObject:[params objectForKey:@"sel_groups_5_13_14"] forKey:BossReachItems_HR];
//            [personProfile.reachItems setObject:[params objectForKey:@"sel_groups_47_48"] forKey:BossReachItems_SalePoint];
//            [personProfile.reachItems setObject:[params objectForKey:@"sel_groups_23"] forKey:BossReachItems_Share];
//            [personProfile.reachItems setObject:[params objectForKey:@"sel_groups_51_52_53"] forKey:BossReachItems_Vip];
//            [personProfile.reachItems setObject:[params objectForKey:@"sel_groups_3_4"] forKey:BossReachItems_System];
            
            //personProfile.yimeiWorkFlowArray = [params arrayValueForKey:@"activity_ids"];
            
            [dict setValue:@0 forKey:@"rc"];

            [dict setValue:resultArray forKey:@"data"];
            
            personProfile.isLogin = @(TRUE);
            
            [BSCoreDataManager setCurrentUserName:[NSString stringWithFormat:@"%@%@",personProfile.userID,personProfile.sql]];
            
            NSArray *posArray = [params arrayValueForKey:@"pos_config"];
            if(posArray.count > 0)
            {
                personProfile.posID = posArray[0];
                personProfile.posName = posArray[1];
                BSFetchPosConfigRequest *request = [[BSFetchPosConfigRequest alloc] initWithPosID:personProfile.posID];
                [request execute];
            }
            
//            BSFetchStartInfoRequest *request2 = [[BSFetchStartInfoRequest alloc] init];
//            [request2 execute];
            
            [personProfile save];
            [BossPermissionManager sharedManager].haveFetchPermission = false;
            [[BossPermissionManager sharedManager] fetchPermission];
            
            BSFetchStoreListRequest *request = [[BSFetchStoreListRequest alloc] init];
            if (!IS_IPAD)
            {
                request.shopid = shopIds;
                
                [[[BSBornCategoryRequest alloc] init] execute];
            }
            else if ( [personProfile.isYiMei boolValue] )
            {
                
            }
            
            [request execute];
            
            //[[HomeCountDataManager sharedManager] fetchData];
            
            //[[[FetchHomeAdvertisementReqeust alloc] init] execute];
            
            [[[FetchCompanyUUIDRequest alloc] init] execute];
//            
//            [[[FetchWXCardUrlRequest alloc] init] execute];
//            
//            BSFetchStaffRequest *staffRequest = [[BSFetchStaffRequest alloc] init];
//            NSLog(@"UserId : %@",[PersonalProfile currentProfile].userID);
//            staffRequest.userID = [PersonalProfile currentProfile].userID;
//            [staffRequest execute];
//            
            personProfile.departments_ids = [params arrayValueForKey:@"departments_ids"];
//            
//            [[[BSPrintPosOperateRequest alloc] init] getBoardcastIP];
            
#if 0
#ifdef __IPHONE_8_0
            if ( [[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
            {
                UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:notiSettings];
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
            else
            {
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
            }
#else
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
#else
            if ( IS_IPAD )
            {
                [[JPushManager sharedManager] sendRegistrationIDToServer];
            }
#endif
        }
    }
    else
    {
        dict = [self generateResponse:@"请求发生错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSLoginResponse object:self userInfo:dict];
}

@end
