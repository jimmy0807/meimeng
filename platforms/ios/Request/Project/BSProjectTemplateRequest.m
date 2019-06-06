//
//  BSProjectTemplateRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSProjectTemplateRequest.h"
#import "BSCoreDataManager.h"
#import "BSProjectTemplateIDRequest.h"
#import "ChineseToPinyin.h"
#import "BSProjectItemRequest.h"



@interface BSProjectTemplateRequest ()

@property (nonatomic, strong) NSString *lastUpdate;

@end


@implementation BSProjectTemplateRequest

- (id)initWithLastUpdate
{
    self = [super init];
    if (self)
    {
        self.lastUpdate = [[BSCoreDataManager currentManager] fetchLastUpdateTimeWithEntityName:@"CDProjectTemplate"];
    }
    
    return self;
}

- (BOOL)willStart
{
    NSMutableArray* shopids = [NSMutableArray arrayWithObject:@(0)];
    if ( [PersonalProfile currentProfile].shopIds.count > 0 )
    {
        [shopids addObjectsFromArray:[PersonalProfile currentProfile].shopIds];
    }
    
    self.tableName = @"product.template";
    //self.filter = @[@"|", @[@"active", @"=", [NSNumber numberWithBool:NO]], @[@"active", @"=", [NSNumber numberWithBool:YES]]];
    if (self.lastUpdate.length != 0)
    {
        //self.filter = @[@"|", @"&", @[@"active", @"=", [NSNumber numberWithBool:NO]], @[@"active", @"=", [NSNumber numberWithBool:YES]], @[@"write_date", @">", self.lastUpdate]];
        self.filter = @[@[@"write_date", @">", self.lastUpdate], @[@"shop_id",@"in",shopids]];
    }
  self.field = @[@"id", @"name", @"born_category", @"type", @"list_price", @"barcode", @"default_code", @"time", @"active", @"sale_ok", @"book_ok", @"purchase_ok", @"description", @"pos_categ_id", @"uom_id", @"company_id", @"create_date", @"write_date", @"attribute_line_ids", @"consumables_ids", @"image_url", @"image_small_url",@"qty_available",@"exchange",@"is_show_weika",@"is_spread",@"is_recommend",@"is_main_product",@"ais_main_productailable_in_weixin",@"available_in_pos",@"standard_price",@"category_id",@"virtual_available",@"member_price"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if (resultStr.length != 0 && resultList != nil)
    {
        PersonalProfile *userinfo = [PersonalProfile currentProfile];
        BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
        NSArray *templates = [NSArray array];
        if (self.lastUpdate.length == 0)
        {
            templates = [coreDataManager fetchAllProjectTemplate];
        }
        NSMutableArray *oldTemplates = [NSMutableArray arrayWithArray:templates];
        
        NSMutableArray* fetchProductIDs = [NSMutableArray array];
        
        for (NSDictionary *dict in resultList)
        {
            NSNumber *templateID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
           
            CDProjectTemplate *template = [coreDataManager findEntity:@"CDProjectTemplate" withValue:templateID forKey:@"templateID"];
            if (template)
            {
                [oldTemplates removeObject:template];
            }
            else
            {
                template = [coreDataManager insertEntity:@"CDProjectTemplate"];
                template.templateID = templateID;
            }
            template.templateName = [dict stringValueForKey:@"name"];
            template.templateNameLetter = [ChineseToPinyin pinyinFromChiniseString:template.templateName];
            template.templateNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:template.templateName] uppercaseString];
            template.type = [dict stringValueForKey:@"type"];
            template.createDate = [dict stringValueForKey:@"create_date"];
            template.lastUpdate = [dict stringValueForKey:@"write_date"];
            template.imageUrl = [dict stringValueForKey:@"image_url"];
            template.imageSmallUrl = [dict stringValueForKey:@"image_small_url"];
            template.qty_available = [NSNumber numberWithDouble:[[dict objectForKey:@"qty_available"] doubleValue]];
            template.exchange = [NSNumber numberWithBool:[[dict objectForKey:@"exchange"] boolValue]];
           template.is_show_weika = [NSNumber numberWithBool:[[dict objectForKey:@"is_show_weika"] boolValue]];
            template.is_spread = [NSNumber numberWithBool:[[dict objectForKey:@"is_spread"] boolValue]];
            template.is_recommend = [NSNumber numberWithBool:[[dict objectForKey:@"is_recommend"] boolValue]];
            template.is_main_product = [NSNumber numberWithBool:[[dict objectForKey:@"is_main_product"] boolValue]];
            template.available_in_weixin = [NSNumber numberWithBool:[[dict objectForKey:@"available_in_weixin"] boolValue]];
            template.available_in_pos = [NSNumber numberWithBool:[[dict objectForKey:@"available_in_pos"] boolValue]];
            template.standard_price = [NSNumber numberWithDouble:[[dict objectForKey:@"standard_price"] doubleValue]];
            template.virtual_available = [NSNumber numberWithBool:[[dict objectForKey:@"virtual_available"] boolValue]];
            for (int i = 0; i < template.projectItems.count; i++)
            {
                CDProjectItem *projectItem = [template.projectItems objectAtIndex:i];
//                if ([template.lastUpdate compare:projectItem.lastUpdate] == NSOrderedDescending)
//                {
//                    projectItem.lastUpdate = template.lastUpdate;
//                }
                [fetchProductIDs addObject:projectItem.itemID];
            }
            
            template.isActive = [NSNumber numberWithBool:[[dict objectForKey:@"active"] boolValue]];
            template.canSale = [NSNumber numberWithBool:[[dict objectForKey:@"available_in_pos"] boolValue]];
            template.sale_ok = template.canSale;
            template.canBook = [NSNumber numberWithBool:[[dict objectForKey:@"book_ok"] boolValue]];
            template.canPurchase = [NSNumber numberWithBool:[[dict objectForKey:@"purchase_ok"] boolValue]];
            template.purchase_ok = [NSNumber numberWithBool:[[dict objectForKey:@"purchase_ok"] boolValue]];
            template.listPrice = [NSNumber numberWithDouble:[[dict objectForKey:@"list_price"] doubleValue]];
            template.minPrice = [NSNumber numberWithDouble:[[dict objectForKey:@"list_price"] doubleValue]];
            template.memberPrice = [dict numberValueForKey:@"member_price"];
            template.bornCategory = [NSNumber numberWithInteger:[[dict objectForKey:@"born_category"] integerValue]];
            template.barcode = [dict stringValueForKey:@"barcode"];
            template.defaultCode = [dict stringValueForKey:@"default_code"];
            if ([[dict objectForKey:@"pos_categ_id"] isKindOfClass:[NSArray class]])
            {
                template.categoryID = [NSNumber numberWithInteger:[[[dict objectForKey:@"pos_categ_id"] objectAtIndex:0] integerValue]];
                template.categoryName = [[dict objectForKey:@"pos_categ_id"] objectAtIndex:1];
                template.category = [coreDataManager findEntity:@"CDProjectCategory" withValue:template.categoryID forKey:@"categoryID"];
            }
            else
            {
                template.categoryID = [NSNumber numberWithInteger:0];
                template.categoryName = @"";
                template.category = nil;
            }
        
            if ([[dict objectForKey:@"description"] isKindOfClass:[NSString class]])
            {
                template.introduction = [dict stringValueForKey:@"description"];
            }
            else
            {
                template.introduction = @"";
            }
            template.companyID = [NSNumber numberWithInteger:[[[dict objectForKey:@"company_id"] objectAtIndex:0] integerValue]];
            template.companyName = [[dict objectForKey:@"company_id"] objectAtIndex:1];
            template.time = [NSNumber numberWithInteger:[[dict objectForKey:@"time"] integerValue]];
            template.imageName = [NSString stringWithFormat:@"project_template_%@_%d_%d", userinfo.sql, userinfo.businessId, template.templateID.integerValue];
            template.imageNamePad = [NSString stringWithFormat:@"project_template_pad_%@_%d_%d", userinfo.sql, userinfo.businessId, template.templateID.integerValue];
            template.imageNameSmall = [NSString stringWithFormat:@"project_template_small_%@_%d_%d", userinfo.sql, userinfo.businessId, template.templateID.integerValue];
            template.imageNameMedium = [NSString stringWithFormat:@"project_template_medium_%@_%d_%d", userinfo.sql, userinfo.businessId, template.templateID.integerValue];
            template.imageNameVariant = [NSString stringWithFormat:@"project_template_variant_%@_%d_%d", userinfo.sql, userinfo.businessId, template.templateID.integerValue];
            
            NSArray *unitArray = [dict objectForKey:@"uom_id"];
            if ([unitArray isKindOfClass:[NSArray class]] && unitArray.count > 1)
            {
                template.uomID = [NSNumber numberWithInteger:[[unitArray objectAtIndex:0] integerValue]];
                template.uomName = [unitArray objectAtIndex:1];
            }
            
            NSMutableOrderedSet *attributeLines = [[NSMutableOrderedSet alloc] init];
            NSArray *lineIds = [dict objectForKey:@"attribute_line_ids"];
            if ([lineIds isKindOfClass:[NSArray class]] && lineIds.count > 0)
            {
                for (int i = 0; i < lineIds.count; i++)
                {
                    NSNumber *lineId = [NSNumber numberWithInteger:[[lineIds objectAtIndex:i] integerValue]];
                    CDProjectAttributeLine *attributeLine = [coreDataManager findEntity:@"CDProjectAttributeLine" withValue:lineId forKey:@"attributeLineID"];
                    if (attributeLine)
                    {
                        [attributeLines addObject:attributeLine];
                    }
                }
            }
            template.attributeLines = attributeLines;
            
            NSMutableOrderedSet *consumables = [[NSMutableOrderedSet alloc] init];
            NSArray *consumableIds = [dict objectForKey:@"consumables_ids"];
            if ([consumableIds isKindOfClass:[NSArray class]] && consumableIds.count > 0)
            {
                for (int i = 0; i < consumableIds.count; i++)
                {
                    NSNumber *consumableId = [NSNumber numberWithInteger:[[consumableIds objectAtIndex:i] integerValue]];
                    CDProjectConsumable *consumable = [coreDataManager findEntity:@"CDProjectConsumable" withValue:consumableId forKey:@"consumableID"];
                    if (consumable)
                    {
                        [consumables addObject:consumable];
                    }
                }
            }
            template.consumables = consumables;
        }
        [coreDataManager deleteObjects:oldTemplates];
        [coreDataManager save:nil];
        
//        BSProjectTemplateIDRequest *request = [[BSProjectTemplateIDRequest alloc] init];
//        request.fetchProductIDs = fetchProductIDs;
//        [request execute];
        
        
        BSProjectItemRequest *request = [[BSProjectItemRequest alloc] initWithLastUpdate];
//        request.fetchProductIDs = fetchProductIDs;
        [request execute];
//        
        return;
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectTemplateResponse object:self userInfo:params];
}

@end
