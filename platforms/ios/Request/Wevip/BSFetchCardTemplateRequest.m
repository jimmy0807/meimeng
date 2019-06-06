//
//  BSFetchGiveTemplateRequest.m
//  Boss
//
//  Created by lining on 16/3/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchCardTemplateRequest.h"
#import "BSFetchCardTemplateProductsRequest.h"

@implementation BSFetchCardTemplateRequest
- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.weika.product";
    NSMutableArray *filterAarray = [NSMutableArray arrayWithArray:[PersonalProfile currentProfile].shopIds];
    [filterAarray addObject:@0];
    self.filter = @[@[@"is_featured",@"=",@1],@[@"shop_id",@"in",filterAarray]];
    
//    self.needCompany = true;
//    self.filter = @[@[@"is_featured",@"=",@1]];
    self.field = @[@"id",@"name",@"short_description",@"description",@"discount",@"type",@"price",@"money",@"company_id",@"shop_id",@"__last_update",@"default_cut",@"is_customize",@"image_url"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldTemplates = [NSMutableArray arrayWithArray:[dataManager fetchCardTemplatesWithType:0]];
        for (NSDictionary *params in retArray) {
            NSNumber *template_id = [params numberValueForKey:@"id"];
            CDCardTemplate *cardTemplate = [dataManager findEntity:@"CDCardTemplate" withValue:template_id forKey:@"template_id"];
            if (cardTemplate == nil) {
                cardTemplate = [dataManager insertEntity:@"CDCardTemplate"];
                cardTemplate.template_id = template_id;
            }
            else
            {
                [oldTemplates removeObject:cardTemplate];
            }
            
            cardTemplate.template_name = [params stringValueForKey:@"name"];
            cardTemplate.expire_date = [params stringValueForKey:@"expire_date"];
            cardTemplate.short_description = [params stringValueForKey:@"short_description"];
            cardTemplate.long_description = [params stringValueForKey:@"description"];
            
            cardTemplate.discount = [params numberValueForKey:@"discount"];
            cardTemplate.need_share = [params numberValueForKey:@"need_share"];
            cardTemplate.card_type = [params numberValueForKey:@"type"]; //('1', u'会员卡'), ('2', u'礼品券'), ('3', u'礼品卡')
            cardTemplate.buy_price = [params numberValueForKey:@"price"];
            cardTemplate.money = [params numberValueForKey:@"money"];
            
            
            cardTemplate.company_id = [params arrayIDValueForKey:@"company_id"];
            cardTemplate.company_name = [params arrayNameValueForKey:@"company_id"];
            
            cardTemplate.shop_id = [params arrayIDValueForKey:@"shop_id"];
            cardTemplate.shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            cardTemplate.last_update = [params stringValueForKey:@"__last_update"];
            cardTemplate.default_cut = [params numberValueForKey:@"default_cut"];
            
            cardTemplate.is_customize = [params numberValueForKey:@"is_customize"];
            
            //cardTemplate.is_customize = [PersonalProfile currentProfile].is_customize_coupon;
            
            cardTemplate.template_pic_url = [params stringValueForKey:@"image_url"];
        
            
//            BSFetchCardTemplateProductsRequest *productsRequest = [[BSFetchCardTemplateProductsRequest alloc] initWithTemplate:cardTemplate];
//            [productsRequest execute];
        }
        [dataManager deleteObjects:oldTemplates];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchCardTemplateResponse object:nil userInfo:dict];
}

@end
