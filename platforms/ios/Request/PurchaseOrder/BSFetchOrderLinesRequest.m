//
//  BSFetchOrderProductsRequest.m
//  Boss
//
//  Created by lining on 15/6/16.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchOrderLinesRequest.h"

@interface BSFetchOrderLinesRequest ()
@property(nonatomic, strong) CDPurchaseOrder *order;
@property(nonatomic, strong) NSArray *order_line;
@end

@implementation BSFetchOrderLinesRequest
-(id)initWithOrder:(CDPurchaseOrder *)order order_line:(NSArray *)order_line
{
    self = [super init];
    if (self) {
        self.order = order;
        self.order_line = order_line;
    }
    
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"purchase.order.line";
    self.filter = @[@[@"id",@"in",self.order_line]];
    self.field = @[];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = nil;
   
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
    if ([retArray isKindOfClass:[retArray class]]) {
        NSLog(@"拿到数据: %d",retArray.count);
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        if (self.order.orderlines.count > 0) {
            for (CDPurchaseOrderLine * orderline in self.order.orderlines) {
                [dataManager deleteObject:orderline];
            }
            self.order.orderlines = nil;
        }
        for (NSDictionary *params in retArray) {
            
            NSNumber *line_id = [params numberValueForKey:@"id"];
            
            CDPurchaseOrderLine *orderline = [dataManager findEntity:@"CDPurchaseOrderLine" withValue:line_id forKey:@"line_id"];
            
            if (orderline == nil) {
                orderline =[dataManager insertEntity:@"CDPurchaseOrderLine"];
                orderline.line_id = line_id;
            }
            
            CDProjectItem *item = nil;   //产品
            //产品的id和名称
            NSArray *product_id = [params arrayValueForKey:@"product_id"];
            if (product_id.count > 0) {
                NSNumber *itemID = product_id[0];
                item = [dataManager findEntity:@"CDProjectItem" withValue:itemID forKey:@"itemID"];
                if (!item) {
                    item = [dataManager insertEntity:@"CDProjectItem"];
                    item.itemID = itemID;
                }
                item.itemName = product_id[1];
                PersonalProfile *userinfo = [PersonalProfile currentProfile];
                item.imageName = [NSString stringWithFormat:@"project_item_%@_%d_%d", userinfo.sql, userinfo.businessId, item.itemID.integerValue];
                item.imageNameSmall = [NSString stringWithFormat:@"project_item_small_%@_%d_%d", userinfo.sql, userinfo.businessId, item.itemID.integerValue];
                item.imageNameMedium = [NSString stringWithFormat:@"project_item_medium_%@_%d_%d", userinfo.sql, userinfo.businessId, item.itemID.integerValue];
                item.imageNameVariant = [NSString stringWithFormat:@"project_item_variant_%@_%d_%d", userinfo.sql, userinfo.businessId, item.itemID.integerValue];

                //产品的单位
                NSArray *product_uom = [params arrayValueForKey:@"product_uom"];
                if (product_uom.count > 0) {
                    item.uomID = product_uom[0];
                    item.uomName = product_uom[1];
                }
                
            }
            orderline.product = item;
            
            CDPurchaseOrderTax *tax = nil;     //税率
            NSArray *taxes_id = [params arrayValueForKey:@"taxes_id"];
            if (taxes_id.count > 0) {
                NSNumber *tax_id = taxes_id[0];
                tax = [dataManager findEntity:@"CDPurchaseOrderTax" withValue:tax_id forKey:@"tax_id"];
                if (!tax) {
                    tax = [dataManager insertEntity:@"CDPurchaseOrderTax"];
                    tax.tax_id = tax_id;
                    NSLog(@"此时税率还没有拿到");
                }
//                tax.name  = taxes_id[1];
            }
            orderline.tax = tax;
            
            orderline.price = [params numberValueForKey:@"price_unit"];
            orderline.count = [params numberValueForKey:@"product_qty"];
            orderline.date = [params stringValueForKey:@"date_planned"];
            orderline.total_untax = [params numberValueForKey:@"price_subtotal"];
            
            CGFloat total_untax = [orderline.total_untax floatValue];
            CGFloat totalMoney = total_untax * (1+[orderline.tax.amount floatValue]);
            CGFloat total_tax = totalMoney - total_untax;
            
            orderline.total_tax = [NSNumber numberWithFloat:total_tax];
            orderline.totalMoney = [NSNumber numberWithFloat:totalMoney];
            [orderedSet addObject:orderline];
        }
        
        self.order.orderlines = orderedSet;
        
        [dataManager save:nil];
    }
    else
    {
        self.order.orderlines = orderedSet;
        [[BSCoreDataManager currentManager] save:nil];
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    NSLog(@"发送通知 %d",self.order.orderlines.count);
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchOrderLinesResponse object:nil userInfo:dict];
}
@end
