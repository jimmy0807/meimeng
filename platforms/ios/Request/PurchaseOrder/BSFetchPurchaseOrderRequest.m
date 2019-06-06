//
//  BSFetchPurchaseRequest.m
//  Boss
//
//  Created by lining on 15/6/15.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchPurchaseOrderRequest.h"
#import "BSFetchOrderLinesRequest.h"

#define ORDER_COUNT 15
@interface BSFetchPurchaseOrderRequest ()
@property(nonatomic, assign) NSInteger startIdx;
@property(nonatomic, strong) NSString *state;
@end
@implementation BSFetchPurchaseOrderRequest

- (id)initWithStartIndex:(NSInteger)startIdx state:(NSString *)state
{
    self = [super init];
    if (self) {
        self.startIdx = startIdx;
        self.state = state;
    }
    return self;
}


- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"purchase.order";
    self.filter = @[];
    if (self.state != nil) {
        if ([self.state isEqualToString:@"approved"]) {
//            predicate = [NSPredicate predicateWithFormat:@"state == %@ and shipped = %d",state,0];
            self.filter = @[@[@"state",@"=",self.state],@[@"shipped",@"=",@0]];
        }
        else if ([self.state isEqualToString:@"done"])
        {
            self.filter = @[@"|",@"&",@[@"state",@"=",@"approved"],@[@"shipped",@"=",@1],@[@"state",@"=",self.state]];
        }
        else
        {
//            predicate = [NSPredicate predicateWithFormat:@"state == %@",state];
            self.filter = @[@[@"state",@"=",self.state]];
        }
    }
    
    self.field = @[];
    NSArray *params = @[[NSNumber numberWithInt:self.startIdx],[NSNumber numberWithInt:ORDER_COUNT],@"id desc"];
    [self sendShopAssistantXmlSearchReadCommand:params];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict;
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray *purchaseOrders =  [dataManager fetchPurchaseOrdersWithState:self.state];
        NSMutableArray *oldPurchaseOrders;
        if (self.startIdx == 0) {
            oldPurchaseOrders = [NSMutableArray arrayWithArray:purchaseOrders];
        }
        
        for (NSDictionary *params in retArray)
        {
            NSNumber *orderId = [params numberValueForKey:@"id"];
            
            CDPurchaseOrder *purchaseOrder = [dataManager findEntity:@"CDPurchaseOrder" withValue:orderId forKey:@"orderId"];
            if (purchaseOrder)
            {
                [oldPurchaseOrders removeObject:purchaseOrder];
            }
            else
            {
                purchaseOrder = [dataManager insertEntity:@"CDPurchaseOrder"];
                purchaseOrder.orderId = orderId;
            }
            purchaseOrder.orderNo = [params stringValueForKey:@"partner_ref"];
            purchaseOrder.name = [params stringValueForKey:@"name"];
            purchaseOrder.amount_total = [params numberValueForKey:@"amount_total"];
            purchaseOrder.date_order = [params stringValueForKey:@"date_order"];
            purchaseOrder.approve_date = [params stringValueForKey:@"date_approve"];
            purchaseOrder.state = [params stringValueForKey:@"state"];
            purchaseOrder.shipped = [params numberValueForKey:@"shipped"];
            purchaseOrder.shipped_rate = [params stringValueForKey:@"shipped_rate"];
            purchaseOrder.amount_tax = [params numberValueForKey:@"amount_tax"];
            purchaseOrder.amount_untax = [params numberValueForKey:@"amount_untaxed"];
            
            
            NSArray *validator = [params arrayValueForKey:@"validator"]; //订单创建人
            if (validator.count > 0)
            {
                purchaseOrder.validator_name = validator[1];
            }
            
            NSArray *order_lines = [params arrayValueForKey:@"order_line"];//order_line（加入到订单的所有产品的line）
            if (order_lines.count == 0) {
                [dataManager deleteObjects:purchaseOrder.orderlines.array];
                purchaseOrder.orderlines = nil;
            }
//            BSFetchOrderProductsRequest *request = [[BSFetchOrderProductsRequest alloc] initWithOrder:purchaseOrder order_line:order_lines];
//            [request execute];
            
            NSMutableString *order_line = [NSMutableString string];
            if (order_lines.count > 0)
            {
                for (int i = 0; i < order_lines.count; i++)
                {
                    [order_line appendFormat:@"%@,",order_lines[i]];
                }
                [order_line deleteCharactersInRange:NSMakeRange(order_line.length - 1, 1)];
            }
            purchaseOrder.order_line = order_line;
            
            
            NSArray *shop = [params arrayValueForKey:@"shop_id"]; //门店
            if (shop.count > 0)
            {
                NSNumber *shop_id = shop[0];
                CDStore *store = [dataManager findEntity:@"CDStore" withValue:shop_id forKey:@"storeID"];
                if (!store)
                {
                    store = [dataManager insertEntity:@"CDStore"];
                    store.storeID = shop_id;
                }
                store.storeName = shop[1];
                purchaseOrder.shop = store;
            }
            
            NSArray *partner = [params arrayValueForKey:@"partner_id"]; //供应商
            if (partner.count > 0) {
                NSNumber *provider_id = partner[0];
                CDProvider *provider = [dataManager findEntity:@"CDProvider" withValue:provider_id forKey:@"provider_id"];
                if (!provider) {
                    provider = [dataManager insertEntity:@"CDProvider"];
                    provider.provider_id = provider_id;
//                    NSLog(@"订单请求 新建供应商: %@",provider.provider_id);
                }
                provider.name = partner[1];
                
                NSArray *pricelist_id = [params arrayValueForKey:@"pricelist_id"];
                if (pricelist_id.count > 0) {
                    provider.product_pricelist_id = pricelist_id[0];
                }
                purchaseOrder.provider = provider;
            }
            
            
            NSArray *location = [params arrayValueForKey:@"location_id"]; //库位
            if (location.count > 0) {
                NSNumber *storage_id = location[0];
                CDStorage *storage = [dataManager findEntity:@"CDStorage" withValue:storage_id forKey:@"storage_id"];
                if (!storage) {
                    storage = [dataManager insertEntity:@"CDStorage"];
                    storage.storage_id = storage_id;
//                    NSLog(@"订单请求 新建库位: %@",storage.storage_id);
                }
                storage.name = location[1];
                
                purchaseOrder.storage = storage;
            }
            
            
            NSArray *pick = [params arrayValueForKey:@"picking_type_id"]; //仓库
            if (pick.count > 0)
            {
                NSNumber *pick_id = pick[0];
                CDWarehouse *warehouse = [dataManager findEntity:@"CDWarehouse" withValue:pick_id forKey:@"pick_id"];
                if (!warehouse)
                {
                    warehouse = [dataManager insertEntity:@"CDWarehouse"];
                    warehouse.pick_id = pick_id;
                }
                warehouse.pick_name = pick[1];

                purchaseOrder.warehouse = warehouse;
            }
        }
        [dataManager deleteObjects:oldPurchaseOrders];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求数据失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchOrderResponse object:nil userInfo:dict];
}

@end
