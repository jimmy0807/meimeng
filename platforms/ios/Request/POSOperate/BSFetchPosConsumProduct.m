//
//  BSFetchPosConsumProduct.m
//  Boss
//  用会员卡消费的项目
//  Created by lining on 15/10/28.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchPosConsumProduct.h"
#import "BSFetchPosProductCategoryRequest.h"

@interface BSFetchPosConsumProduct ()
@property(nonatomic, strong) CDPosOperate *operate;
@property(nonatomic, strong) NSArray *product_ids;
@end

@implementation BSFetchPosConsumProduct
- (instancetype)initWithPosOperate:(CDPosOperate *)operate
{
    self = [super init];
    if (self) {
        self.operate = operate;
        if (self.operate.consume_line_ids.length > 0) {
            self.product_ids = [self.operate.consume_line_ids componentsSeparatedByString:@","];
        }
        
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.consume.line";
//    self.filter = @[@[@"id",@"in",self.product_ids]];
    self.filter = @[@[@"operate_id",@"=",self.operate.operate_id]];
    self.field = @[];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = nil;
    NSMutableArray *productIds = [NSMutableArray array];
    if ([retArray isKindOfClass:[NSArray class]]) {
        
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        
        NSArray *prodcuts = [dataManager fetchConsumeProductsWithOperate:self.operate];
        NSMutableArray *oldProducts = [NSMutableArray arrayWithArray:prodcuts];
        for (NSDictionary *params in retArray) {
            NSNumber *line_id = [params numberValueForKey:@"id"];
            CDPosConsumeProduct *consumProduct = [dataManager findEntity:@"CDPosConsumeProduct" withValue:line_id forKey:@"line_id"];
            if (consumProduct) {
                [oldProducts removeObject:consumProduct];
            }
            else
            {
                consumProduct = [dataManager insertEntity:@"CDPosConsumeProduct"];
                consumProduct.line_id = line_id;
            }
            consumProduct.pack_product_line_id = [params arrayIDValueForKey:@"pack_product_line_id"];
            consumProduct.pack_product_line_name = [params arrayNameValueForKey:@"pack_product_line_id"];
            consumProduct.consume_product_line_id = [params numberValueForKey:@"id"];
            consumProduct.qty = [params numberValueForKey:@"qty"];
            consumProduct.product_qty = [params numberValueForKey:@"consume_qty"];
            consumProduct.note = [params stringValueForKey:@"note"];
            consumProduct.remark = [params stringValueForKey:@"remark"];
            consumProduct.product_price = [params numberValueForKey:@"price"];
            consumProduct.buy_price = [params numberValueForKey:@"price_unit"];
            CGFloat totalMoney = consumProduct.qty.integerValue *consumProduct.buy_price.floatValue;
            consumProduct.money_total = [NSNumber numberWithFloat:totalMoney];
            consumProduct.lastUpdate = [params stringValueForKey:@"__last_update"];
            consumProduct.part_display_name = [params stringValueForKey:@"part_display_name"];
            
//            consumProduct.money_total = [params numberValueForKey:@"pay_amount"];
            consumProduct.state = [params stringValueForKey:@"state"];
            consumProduct.product_discount = [params numberValueForKey:@"discount"];
            
            consumProduct.card_id = [params arrayIDValueForKey:@"card_id"];
            consumProduct.card_name = [params arrayNameValueForKey:@"card_id"];
            
            consumProduct.product_id = [params arrayIDValueForKey:@"product_id"];
            consumProduct.product_name = [params arrayNameValueForKey:@"product_id"];
            
            CDProjectItem *product = [dataManager uniqueEntityForName:@"CDProjectItem" withValue:consumProduct.product_id forKey:@"itemID"];
            consumProduct.product  = product;
            [productIds addObject:consumProduct.product_id];
            
            
            consumProduct.shop_id = [params arrayIDValueForKey:@"shop_id"];
            consumProduct.shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            consumProduct.company_id = [params arrayIDValueForKey:@"company_id"];
            consumProduct.company_name = [params arrayNameValueForKey:@"company_id"];
            
            consumProduct.operate_id = [params arrayIDValueForKey:@"operate_id"];
            consumProduct.operate_name = [params arrayNameValueForKey:@"operate_id"];
            
            consumProduct.operate = self.operate;
            
            if ([consumProduct.qty integerValue] > 0)
            {
                consumProduct.pay_type = [NSNumber numberWithInteger:kPadPayModeTypeCard];
            }
            consumProduct.pay_type = [NSNumber numberWithInteger:kPadPayModeTypeCard];
            
            NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
            for ( NSNumber* partID in [params arrayValueForKey:@"part_ids"] )
            {
                CDYimeiBuwei* buwei = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDYimeiBuwei" withValue:partID forKey:@"buwei_id"];
                [orderedSet addObject:buwei];
            }
            consumProduct.yimei_buwei = orderedSet;
//            consumProduct.category_name = @"卡内服务";
        }
        
        [dataManager deleteObjects:oldProducts];
        [dataManager save:nil];
        
        if (!IS_IPAD && productIds.count > 0) {
            BSFetchPosProductCategoryRequest *request = [[BSFetchPosProductCategoryRequest alloc] init];
            request.fetchProductIDs = productIds;
            [request execute];
        }

    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchPosConsumeProductResponse object:nil userInfo:dict];
}

@end
