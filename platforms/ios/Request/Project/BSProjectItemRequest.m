//
//  BSProjectItemRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/5/27.
//  Copyright (c) 2014年 BORN. All rights reserved.
//

#import "BSProjectItemRequest.h"
#import "BSCoreDataManager.h"
#import "BSProjectItemIDRequest.h"
#import "ChineseToPinyin.h"

@interface BSProjectItemRequest ()

@property (nonatomic, strong) NSString *lastUpdate;

@end


@implementation BSProjectItemRequest

- (id)initWithLastUpdate
{
    self = [super init];
    if (self)
    {
        self.lastUpdate = [[BSCoreDataManager currentManager] fetchLastUpdateTimeWithEntityName:@"CDProjectItem"];
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"product.product";
    
    NSMutableArray* shopids = [NSMutableArray arrayWithObject:@(0)];
    if ( [PersonalProfile currentProfile].shopIds.count > 0 )
    {
        [shopids addObjectsFromArray:[PersonalProfile currentProfile].shopIds];
    }
    
    //self.filter = @[@"|", @[@"active", @"=", [NSNumber numberWithBool:NO]], @[@"active", @"=", [NSNumber numberWithBool:YES]]];
    
    if (self.fetchProductIDs.count > 0) {
        //self.filter = @[@"&",@"|",@[@"active", @"=", [NSNumber numberWithBool:NO]], @[@"active", @"=", [NSNumber numberWithBool:YES]], @[@"id", @"in", self.fetchProductIDs]];
        self.filter = @[@[@"id", @"in", self.fetchProductIDs], @[@"shop_id",@"in",shopids]];

    }
    else
    {
        if (self.lastUpdate.length != 0)
        {
             //self.filter = @[@"&",@"|", @[@"active", @"=", [NSNumber numberWithBool:NO]], @[@"active", @"=", [NSNumber numberWithBool:YES]],@[@"write_date", @">", self.lastUpdate]];
            self.filter = @[@[@"write_date", @">", self.lastUpdate], @[@"shop_id",@"in",shopids]];
        }
       
    }
//    if (self.lastUpdate.length != 0)
//    {
//        self.filter = @[@"|",@"|",@"&", @[@"active", @"=", [NSNumber numberWithBool:NO]], @[@"active", @"=", [NSNumber numberWithBool:YES]], @[@"id", @"in", self.fetchProductIDs],@[@"write_date", @">", self.lastUpdate]];
//    }
    //@"price_extra",
    self.field = @[@"id", @"name", @"born_category", @"barcode", @"default_code", @"time", @"active", @"available_in_pos", @"book_ok", @"purchase_ok", @"uom_id", @"product_tmpl_id", @"qty_available", @"create_date", @"write_date", @"pack_line_ids", @"percent_card", @"fix_card",  @"percent_not_card",  @"fix_not_card",  @"is_add",  @"do_percent",  @"do_fix",  @"do_fix_gift", @"is_gift_commission", @"fix_commission", @"image_url", @"image_small_url",@"sequence",@"max_price_unit",@"min_price_unit", @"pos_categ_id",@"description",@"type",@"product_group_id",@"package_count",@"product_group_image_url",@"list_price",@"departments_id",@"description_notice",@"consumables_ids",@"check_ids",@"is_check_service",@"is_consumables",@"is_prescription"];
    
    //self.timeOut = 600;
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *params;
    if (resultStr.length != 0 && resultList != nil)
    {
    }
    else
    {
        params = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectItemResponse object:self userInfo:params];
    
//    [BSCoreDataManager performBlockOnWriteQueue:^{
//        [self doInThread:resultList];
//    }];
    [self doInThread:resultList];
}

- (void)doInThread:(NSArray *)resultList
{
    if (resultStr.length != 0 && resultList != nil)
    {
        PersonalProfile *userinfo = [PersonalProfile currentProfile];
        BSCoreDataManager *coreDataManager = [BSCoreDataManager currentManager];
        NSArray *items = [NSArray array];
        if (self.lastUpdate.length == 0)
        {
            items = [coreDataManager fetchAllProjectItem];
        }
        NSMutableArray *oldItems = [NSMutableArray arrayWithArray:items];
        for (NSDictionary *dict in resultList)
        {
            NSNumber *itemID = [NSNumber numberWithInteger:[[dict objectForKey:@"id"] integerValue]];
            CDProjectItem *item = [coreDataManager findEntity:@"CDProjectItem" withValue:itemID forKey:@"itemID"];
            if (item)
            {
                [oldItems removeObject:item];
            }
            else
            {
                item = [coreDataManager insertEntity:@"CDProjectItem"];
                item.itemID = itemID;
            }
            
            item.itemName = [dict stringValueForKey:@"name"];
            item.itemNameLetter = [ChineseToPinyin pinyinFromChiniseString:item.itemName];
            item.itemNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:item.itemName] uppercaseString];
            item.extraPrice = [NSNumber numberWithDouble:[[dict objectForKey:@"price_extra"] doubleValue]];
            item.totalPrice = [NSNumber numberWithDouble:[[dict objectForKey:@"list_price"] doubleValue]];
            item.barcode = [dict stringValueForKey:@"barcode"];
            item.defaultCode = [dict stringValueForKey:@"default_code"];
            item.isActive = [NSNumber numberWithBool:[[dict objectForKey:@"active"] boolValue]];
            item.canSale = [NSNumber numberWithBool:[[dict objectForKey:@"available_in_pos"] boolValue]];
            item.canBook = [NSNumber numberWithBool:[[dict objectForKey:@"book_ok"] boolValue]];
            item.canPurchase = [NSNumber numberWithBool:[[dict objectForKey:@"purchase_ok"] boolValue]];
            item.imageUrl = [dict stringValueForKey:@"image_url"];
            item.imageSmallUrl = [dict stringValueForKey:@"image_small_url"];
            item.time = [NSNumber numberWithInteger:[[dict objectForKey:@"time"] integerValue]];
            NSNumber *templateID = [NSNumber numberWithInteger:[[[dict objectForKey:@"product_tmpl_id"] objectAtIndex:0] integerValue]];
            item.bornCategory = [NSNumber numberWithInteger:[[dict objectForKey:@"born_category"] integerValue]];
            item.templateID = templateID;
            item.sequence = [dict numberValueForKey:@"sequence"];
            item.templateName = [[dict objectForKey:@"product_tmpl_id"] objectAtIndex:1];
            item.categoryName = [dict arrayNameValueForKey:@"pos_categ_id"];
            item.categoryID = [dict arrayIDValueForKey:@"pos_categ_id"];
            item.category = [coreDataManager findEntity:@"CDProjectCategory" withValue:item.categoryID forKey:@"categoryID"];
            item.introduction = [dict stringValueForKey:@"description"];
            item.description_notice = [dict stringValueForKey:@"description_notice"];
            item.type = [dict stringValueForKey:@"type"];
            
            item.uomName = [dict arrayNameValueForKey:@"uom_id"];
            item.uomID = [dict arrayIDValueForKey:@"uom_id"];
            item.createDate = [dict stringValueForKey:@"create_date"];
            if ([[dict numberValueForKey:@"departments_id"] isKindOfClass:[NSArray class]])
            {
                item.departments_id = [[dict objectForKey:@"departments_id"] objectAtIndex:0];
            }
            else if ([[dict numberValueForKey:@"departments_id"] isKindOfClass:[NSNumber class]])
            {
                item.departments_id = [dict numberValueForKey:@"departments_id"];
            }
            else
            {
                item.departments_id = [NSNumber numberWithInt:0];
            }
            if (!self.fetchProductIDs) {
                item.lastUpdate = [dict stringValueForKey:@"write_date"];
            }
            
            item.imageName = [NSString stringWithFormat:@"project_item_%@_%d_%d", userinfo.sql, userinfo.businessId, item.itemID.integerValue];
            item.imageNamePad = [NSString stringWithFormat:@"project_item_pad_%@_%d_%d", userinfo.sql, userinfo.businessId, item.itemID.integerValue];
            item.imageNameSmall = [NSString stringWithFormat:@"project_item_small_%@_%d_%d", userinfo.sql, userinfo.businessId, item.itemID.integerValue];
            item.imageNameMedium = [NSString stringWithFormat:@"project_item_medium_%@_%d_%d", userinfo.sql, userinfo.businessId, item.itemID.integerValue];
            item.imageNameVariant = [NSString stringWithFormat:@"project_item_variant_%@_%d_%d", userinfo.sql, userinfo.businessId, item.itemID.integerValue];
            item.inHandAmount = [NSNumber numberWithDouble:[[dict objectForKey:@"qty_available"] doubleValue]];
            item.forecastAmount = [NSNumber numberWithDouble:[[dict objectForKey:@"virtual_available"] doubleValue]];
            item.cardDeduct = [NSNumber numberWithDouble:[[dict objectForKey:@"percent_card"] doubleValue]];
            item.fixedCardDeduct = [NSNumber numberWithDouble:[[dict objectForKey:@"fix_card"] doubleValue]];
            item.notCardDeduct = [NSNumber numberWithDouble:[[dict objectForKey:@"percent_not_card"] doubleValue]];
            item.notFixedCardDeduct = [NSNumber numberWithDouble:[[dict objectForKey:@"fix_not_card"] doubleValue]];
            item.inAddition = [NSNumber numberWithBool:[[dict objectForKey:@"is_add"] boolValue]];
            item.doPercent = [NSNumber numberWithDouble:[[dict objectForKey:@"do_percent"] doubleValue]];
            item.doFixedPercent = [NSNumber numberWithDouble:[[dict objectForKey:@"do_fix"] doubleValue]];
            item.giftFixedPercent = [NSNumber numberWithDouble:[[dict objectForKey:@"do_fix_gift"] doubleValue]];
            item.isGiftHasCommission = [NSNumber numberWithBool:[[dict objectForKey:@"is_gift_commission"] boolValue]];
            item.giftFixedCommission = [NSNumber numberWithDouble:[[dict objectForKey:@"fix_commission"] doubleValue]];
            NSMutableOrderedSet *attributeValues = [[NSMutableOrderedSet alloc] init];
            NSArray *valueIds = [dict objectForKey:@"attribute_value_ids"];
            if ([valueIds isKindOfClass:[NSArray class]] && valueIds.count > 0)
            {
                NSString *detailstr = @"";
                for (int i = 0; i < valueIds.count; i++)
                {
                    NSNumber *valueId = [NSNumber numberWithInteger:[[valueIds objectAtIndex:i] integerValue]];
                    CDProjectAttributeValue *attributeValue = [coreDataManager findEntity:@"CDProjectAttributeValue" withValue:valueId forKey:@"attributeValueID"];
                    if (attributeValue) {
                        [attributeValues addObject:attributeValue];
                        detailstr = [NSString stringWithFormat:@"%@%@, ", detailstr, attributeValue.attributeValueName];
                    }
                }
                if (detailstr.length > 2) {
                   detailstr = [detailstr substringToIndex:detailstr.length - 2];
                    item.itemName = [NSString stringWithFormat:@"%@(%@)", [dict stringValueForKey:@"name"], detailstr];
                }
                else
                {
                    item.itemName = [dict stringValueForKey:@"name"];
                }
               
            }
            item.attributeValues = attributeValues;
            
            NSMutableSet *subItems = [[NSMutableSet alloc] init];
            NSMutableSet *subRelateds = [[NSMutableSet alloc] init];
            NSArray *relatedIds = [dict objectForKey:@"pack_line_ids"];
            if ([relatedIds isKindOfClass:[NSArray class]] && relatedIds.count > 0)
            {
                for (int i = 0; i < relatedIds.count; i++)
                {
                    NSNumber *relatedID = [NSNumber numberWithInteger:[[relatedIds objectAtIndex:i] integerValue]];
                    CDProjectRelated *related = [coreDataManager findEntity:@"CDProjectRelated" withValue:relatedID forKey:@"relatedID"];
                    if (related)
                    {
                        [subRelateds addObject:related];
                    }
                    
                    CDProjectItem *subItem = [coreDataManager findEntity:@"CDProjectItem" withValue:related.productID forKey:@"itemID"];
                    if (!subItem)
                    {
                        subItem = [coreDataManager insertEntity:@"CDProjectItem"];
                        subItem.itemID = related.productID;
                        subItem.itemName = related.productName;
                    }
                    
                    [subItems addObject:subItem];
                    item.subItemCount = [NSNumber numberWithInteger:subItems.count];
                }
            }
            
            
            item.subItems = subItems;
            item.subRelateds = subRelateds;
            
            item.maxPrice = [dict numberValueForKey:@"max_price_unit"];
            item.minPrice = [dict numberValueForKey:@"min_price_unit"];
            
            item.project_group_id = [dict arrayIDValueForKey:@"product_group_id"];
            item.project_group_name = [dict arrayNameValueForKey:@"product_group_id"];
            item.product_group_image_url = [dict stringValueForKey:@"product_group_image_url"];
            
            item.package_count = [dict numberValueForKey:@"package_count"];
            
            item.is_check_service = [NSNumber numberWithBool:[[dict objectForKey:@"is_check_service"] boolValue]];
            item.is_consumables = [NSNumber numberWithBool:[[dict objectForKey:@"is_consumables"] boolValue]];
            item.is_prescription = [NSNumber numberWithBool:[[dict objectForKey:@"is_prescription"] boolValue]];
            //item.check_ids = [dict stringValueForKey:@"check_ids"];
            NSArray *consumIds = [dict objectForKey:@"consumables_ids"];
            NSMutableArray *consumList = [[NSMutableArray alloc] init];
            if ([consumIds isKindOfClass:[NSArray class]] && consumIds.count > 0){
                for (int i = 0; i < consumIds.count; i++) {
                    NSNumber *consumId = [NSNumber numberWithInteger:[[consumIds objectAtIndex:i] integerValue]];
                    CDProjectConsumable *comsume = [coreDataManager findEntity:@"CDProjectConsumable" withValue:consumId forKey:@"consumableID"];
                    if (comsume)
                    {
                        [consumList addObject:comsume.productID];
                    }
                }
            }
            item.consumables_ids = [consumList componentsJoinedByString:@","];
            NSArray *checkIds = [dict objectForKey:@"check_ids"];
            NSMutableArray *checkList = [[NSMutableArray alloc] init];
            if ([checkIds isKindOfClass:[NSArray class]] && checkIds.count > 0){
                for (int i = 0; i < checkIds.count; i++) {
                    NSNumber *checkId = [NSNumber numberWithInteger:[[checkIds objectAtIndex:i] integerValue]];
                    CDProjectCheck *check = [coreDataManager findEntity:@"CDProjectCheck" withValue:checkId forKey:@"checkID"];
                    if (check)
                    {
                        [checkList addObject:check.productID];
                    }
                }
            }
            item.check_ids = [checkList componentsJoinedByString:@","];
        }
        [coreDataManager deleteObjects:oldItems];
        [coreDataManager save:nil];
        
        PersonalProfile *profile = [PersonalProfile currentProfile];
        CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:profile.defaultProductId forKey:@"itemID"];
        if (item == nil)
        {
            item = [[BSCoreDataManager currentManager] insertEntity:@"CDProjectItem"];
            item.itemID = [NSNumber numberWithInteger:1];
        }
        item.itemName = profile.defaultProductName;
        item.defaultCode = @"0";
        [[BSCoreDataManager currentManager] save:nil];
        
        
        BSProjectItemIDRequest *request = [[BSProjectItemIDRequest alloc] init];
        [request execute];
    }
}

@end
