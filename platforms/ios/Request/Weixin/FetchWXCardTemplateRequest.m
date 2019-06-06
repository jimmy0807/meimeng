//
//  FetchWXCardTemplateRequest.m
//  Boss
//
//  Created by jimmy on 16/5/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FetchWXCardTemplateRequest.h"

@implementation FetchWXCardTemplateRequest

-(BOOL)willStart
{
    [super willStart];
    
    NSString *cmd =  cmd = [NSString stringWithFormat:@"%@%@", SERVER_IP ,@"/xmlrpc/2/ds_api"];
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"company_born_uuid"] = profile.companyUUID;
    params[@"shop_born_uuid"] = profile.shopUUID;
    
    NSString *jsonString = [BNXmlRpc jsonWithArray:@[params]];
    NSString *xmlString = [BNXmlRpc xmlMethod:@"wxcard_tpl_list" jsonString:jsonString];
    
    [self sendXmlCommand:cmd params:xmlString];
    
    return true;
}


- (void)didFinishOnMainThread
{
    NSDictionary *retDict = (NSDictionary *)[BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([retDict isKindOfClass:[NSDictionary class]])
    {
        NSNumber *errorRet = [retDict numberValueForKey:@"errcode"];
        NSString *errorMsg = [retDict stringValueForKey:@"errmsg"];
        if (errorRet.integerValue == 0)
        {
            NSArray* oldList = [[BSCoreDataManager currentManager] fetchWXCardTemplatesList];
            [[BSCoreDataManager currentManager] deleteObjects:oldList];
            
            NSArray* templateList = retDict[@"data"];
            
            [templateList enumerateObjectsUsingBlock:^(NSDictionary* params, NSUInteger index, BOOL *stop){
                CDWXCardTemplate* template = [[BSCoreDataManager currentManager] insertEntity:@"CDWXCardTemplate"];
                template.card_type = [params stringValueForKey:@"card_type"];
                template.deal_detail = [params stringValueForKey:@"deal_detail"];
                template.default_detail = [params stringValueForKey:@"default_detail"];
                template.description_detail = [params stringValueForKey:@"description"];
                template.quantity = [params numberValueForKey:@"quantity"];
                template.current_quantity = [params numberValueForKey:@"current_quantity"];
                template.gift_detail = [params stringValueForKey:@"gift"];
                template.template_id = [params numberValueForKey:@"id"];
                template.title = [params stringValueForKey:@"title"];
                template.wxcard_id = [params stringValueForKey:@"wxcard_id"];
                template.sortIndex = @(index);
            }];
            
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            dict = [self generateResponse:errorMsg];
        }
    }
    else
    {
        dict = [self generateResponse:@"请求失败,请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchWXCardTemplateResponse object:nil userInfo:dict];
}

@end
