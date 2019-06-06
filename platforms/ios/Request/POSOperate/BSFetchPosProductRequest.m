//
//  BSFetchPosProductRequest.m
//  Boss
//
//  Created by lining on 15/10/19.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchPosProductRequest.h"
#import "BSFetchPosProductCategoryRequest.h"

@interface BSFetchPosProductRequest ()
@property(nonatomic, strong) NSArray *product_ids;
@property(nonatomic, strong) NSArray *operateIds;
@property(nonatomic, strong) CDPosOperate *operate;
@end

@implementation BSFetchPosProductRequest

- (instancetype)initWithPosOperate:(CDPosOperate *)operate
{
    self = [super init];
    if (self) {
        self.operate = operate;
        if (self.operate.product_line_ids.length > 0) {
            self.product_ids = [self.operate.product_line_ids componentsSeparatedByString:@","];
        }
    }
    return self;
}

- (instancetype)initWithOperateIds:(NSArray *)ids
{
    self = [super init];
    if (self) {
        self.operateIds = ids;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.product.line";
    if (self.operateIds.count > 0) {
        self.filter = @[@[@"operate_id",@"in",self.operateIds]];
    }
    if (self.operate) {
       self.filter = @[@[@"operate_id",@"=",self.operate.operate_id]];
    }
    
    self.field = @[@"pack_parent_line_id",@"consume_ids",@"name",@"product_id",@"discount",@"price_unit",@"product_price",@"price_subtotal_incl",@"qty",@"state",@"categ_id",@"shop_id",@"company_id",@"payment_ids",@"operate_id",@"part_ids"];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = nil;
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray *prodcuts = nil;
        if (self.operateIds.count > 0) {
           prodcuts = [dataManager fetchPosProductsWithOperateIds:self.operateIds];
        }
        if (self.operate) {
            prodcuts = [dataManager fetchPosProductsWithOperate:self.operate];
        }
        NSMutableArray *oldProducts = [NSMutableArray arrayWithArray:prodcuts];
        
        NSMutableArray *productIds = [NSMutableArray array];
        
        for (NSDictionary *params in retArray) {
            NSNumber *pack_parent_line_id = [params arrayIDValueForKey:@"pack_parent_line_id"];
            if ([pack_parent_line_id integerValue] != 0) {
                continue;
            }
            NSArray *consume_ids = [params arrayValueForKey:@"consume_ids"];
            if (consume_ids.count > 0) {
                for ( NSNumber* _id in consume_ids )
                {
                    CDPosConsumeProduct *consumProduct = [dataManager uniqueEntityForName:@"CDPosConsumeProduct" withValue:_id forKey:@"line_id"];
                    consumProduct.part_display_name = [params stringValueForKey:@"part_display_name"];
                }
                
                continue;
            }
            NSNumber *line_id = [params numberValueForKey:@"id"];
            CDPosProduct *posProduct = [dataManager findEntity:@"CDPosProduct" withValue:line_id forKey:@"line_id"];
            if (posProduct) {
                [oldProducts removeObject:posProduct];
            }
            else
            {
                posProduct = [dataManager insertEntity:@"CDPosProduct"];
                posProduct.line_id = line_id;
            }

            posProduct.part_display_name = [params stringValueForKey:@"part_display_name"];
            posProduct.name = [params stringValueForKey:@"name"];
            posProduct.product_id = [params arrayIDValueForKey:@"product_id"];
            posProduct.product_name = [params arrayNameValueForKey:@"product_id"];
            
            CDProjectItem *product = [dataManager uniqueEntityForName:@"CDProjectItem" withValue:posProduct.product_id forKey:@"itemID"];
            posProduct.product  = product;
            [productIds addObject:posProduct.product_id];
            
            posProduct.product_discount = [params numberValueForKey:@"discount"];
            posProduct.buy_price = [params numberValueForKey:@"price_unit"];
            posProduct.product_price = [params numberValueForKey:@"product_price"];
            posProduct.money_total = [params numberValueForKey:@"price_subtotal_incl"];
            posProduct.product_qty = [params numberValueForKey:@"qty"];
            posProduct.state = [params stringValueForKey:@"state"];
            
            posProduct.category_id = [params arrayIDValueForKey:@"categ_id"];//"born_catagory_id"
            posProduct.category_name = [params arrayNameValueForKey:@"categ_id"];
            
            posProduct.shop_id = [params arrayIDValueForKey:@"shop_id"];
            posProduct.shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            posProduct.company_id = [params arrayIDValueForKey:@"company_id"];
            //posProduct.company_name = [params arrayNameValueForKey:@"company_name"];
            
            posProduct.payment_ids = [[params arrayValueForKey:@"payment_ids"] componentsJoinedByString:@","];
            
            posProduct.operate_id = [params arrayIDValueForKey:@"operate_id"];
            posProduct.operate_name = [params arrayNameValueForKey:@"operate_id"];
            
            CDPosOperate *operate = [dataManager uniqueEntityForName:@"CDPosOperate" withValue:posProduct.operate_id forKey:@"operate_id"];
            operate.name = posProduct.operate_name;
            
            posProduct.operate = operate;
            
            posProduct.product_qty = [params numberValueForKey:@"qty"];
            if ([posProduct.product_qty integerValue] > 0)
            {
                posProduct.pay_type = [NSNumber numberWithInt:kPadPayModeTypeCard];
            }
            
            NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
            for ( NSNumber* partID in [params arrayValueForKey:@"part_ids"] )
            {
                CDYimeiBuwei* buwei = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDYimeiBuwei" withValue:partID forKey:@"buwei_id"];
                [orderedSet addObject:buwei];
            }
            posProduct.yimei_buwei = orderedSet;
        }
        
        if (!IS_IPAD && productIds.count > 0) {
            BSFetchPosProductCategoryRequest *request = [[BSFetchPosProductCategoryRequest alloc] init];
            request.fetchProductIDs = productIds;
            [request execute];
        }
        
        [dataManager deleteObjects:oldProducts];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchPosOperateProductResponse object:nil userInfo:dict];
}

@end
