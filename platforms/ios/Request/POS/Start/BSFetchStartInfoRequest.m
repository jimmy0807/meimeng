//
//  BSFetchStartInfoRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-3-17.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchStartInfoRequest.h"
#import "BSFetchStartPosRequest.h"
#import "FetchAllWorkFlowActivity.h"
#import "FetchAllKeshiRequest.h"
#import "BSFetchStaffRequest.h"
#import "FetchHPatientCategoryRequest.h"
#import "FetchH9ShoushuTagRequest.h"
#import "FetchHTeamRequest.h"
#import "BSUserDefaultsManager.h"

@implementation BSFetchStartInfoRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:profile.userID, @"user_id", nil];
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"start_info" params:@[params]];
    
    return YES;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if (resultStr.length != 0 && resultList != nil && [resultList isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)resultList;
        NSDictionary *data = [dict objectForKey:@"data"];
        NSLog(@"data: %@", data);
        NSDictionary *accessInfo = [data objectForKey:@"access"];
        NSDictionary *companyInfo = [data objectForKey:@"company"];
        NSDictionary *userInfo = [data objectForKey:@"user_info"];
        NSString *api_version = [data objectForKey:@"api_version"];
        
        NSString* upload_photo_type = [data objectForKey:@"upload_photo_type"];
        if ( [upload_photo_type isEqualToString:@"not_real_time"] )
        {
            [BSUserDefaultsManager sharedManager].useBigPhoto = FALSE;
        }
        else
        {
            [BSUserDefaultsManager sharedManager].useBigPhoto = TRUE;
        }
        // "group_book" : 是否使用预约
        // "group_commission" : 是否需要员工提成
        // "group_employee_service" : 能否预约技师
        // "group_equipment" : 是否开放楼层、房间、包间、桌子管理
        // "group_pad_order" : 是否使用电子菜单
        // "group_telphone" : 是否使用来电宝
        // "group_weika" : 是否使用微卡
        // "group_wexin" : 是否使用微信
        // "group_card_item" : 是否允许项目
        // "group_arrears_amount" : 是否允许欠款
        // "group_different_card_amount" : 是否赠送金额
        PersonalProfile *profile = [PersonalProfile currentProfile];
        profile.isYiMei = [accessInfo numberValueForKey:@"group_medical"];
        profile.isHospital = [profile.isYiMei boolValue];
        profile.group_pad_order = [accessInfo numberValueForKey:@"group_pad_order"];
        profile.medical_api_version = api_version;
        
        profile.provisionString = [data objectForKey:@"provision"];
        profile.promiseString = [data objectForKey:@"promise"];
        
        if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
        {
            [[[FetchAllKeshiRequest alloc] init] execute];
            [[[FetchH9ShoushuTagRequest alloc] init] execute];
            [[[FetchHTeamRequest alloc] init] execute];
            
            if ( [profile.medical_api_version isEqualToString:@"nine"] )
            {
                [[[FetchHPatientCategoryRequest alloc] init] execute];
            }
        }
        
        profile.upload_pic_url = [data stringValueForKey:@"upload_pic_url"];
        
        profile.isAllowItem = [NSNumber numberWithBool:[[accessInfo objectForKey:@"group_card_item"] boolValue]];
        profile.isAllowArrears = [NSNumber numberWithBool:[[accessInfo objectForKey:@"group_arrears_amount"] boolValue]];
        profile.isPresentAmount = [NSNumber numberWithBool:[[accessInfo objectForKey:@"group_different_card_amount"] boolValue]];
        
        profile.isTakeout = [NSNumber numberWithBool:[[accessInfo objectForKey:@"group_food"] boolValue]];
        if ( [profile.isTable boolValue] )
        {
            profile.isTable = [NSNumber numberWithBool:[[accessInfo objectForKey:@"group_equipment"] boolValue]];
        }
        else
        {
            profile.isTable = @(FALSE);
        }
        
        profile.isBook = [NSNumber numberWithBool:[[accessInfo objectForKey:@"group_book"] boolValue]];
//        profile.isBook = @(true);
        profile.companyAddress = [companyInfo stringValueForKey:@"contact_address"];
        profile.is_show_consume_product = [[companyInfo numberValueForKey:@"is_show_consume_product"] boolValue];
        
        profile.defaultProductId = [NSNumber numberWithInteger:[[data objectForKey:@"default_product_id"] integerValue]];
        profile.defaultProductName = [data stringValueForKey:@"default_product_name"];
        
        profile.is_customize_coupon = [userInfo numberValueForKey:@"is_customize_coupon"];
        profile.is_accept_see_partner = [[userInfo numberValueForKey:@"is_accept_see_partner"] boolValue];
        
        NSMutableArray* models = [NSMutableArray array];
        profile.accessModels = [userInfo arrayValueForKey:@"access_models"];
        profile.operate_models = [userInfo arrayValueForKey:@"operate_models"];
        
        [models addObjectsFromArray:profile.operate_models];
        [models addObjectsFromArray:profile.accessModels];
        
        profile.accessModels = models;
        
        profile.access_write_reservation = [[userInfo numberValueForKey:@"access_write_reservation"] boolValue];
        
        NSDictionary* shopInfo = [data objectForKey:@"shop"];
        profile.shopUUID = shopInfo[@"born_uuid"];
        //profile.yimeiWorkFlowID = [shopInfo numberValueForKey:@"workflow_id"];
        
        NSDictionary* pos_config = [data objectForKey:@"pos_config"];
        //profile.printIP = [pos_config stringValueForKey:@"proxy_ip"];
        profile.printType = [pos_config stringValueForKey:@"pos_template_name"];
        profile.printUrl = [data objectForKey:@"print_url"];
        profile.printID = [data objectForKey:@"print_id"];

        [profile save];
        
        BSFetchStartPosRequest *request = [[BSFetchStartPosRequest alloc] init];
        [request execute];
        
        BSFetchStaffRequest *request4 = [[BSFetchStaffRequest alloc] init];
        [request4 execute];
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchStartInfoResponse object:self userInfo:params];
}

@end
