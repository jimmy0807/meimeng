//
//  BSFetchMoveItemRequest.m
//  Boss
//  采购单 移动订单 产品详情
//  Created by lining on 15/7/17.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchMoveItemRequest.h"

@interface BSFetchMoveItemRequest ()
@property(nonatomic, strong) NSArray *item_ids;
@end

@implementation BSFetchMoveItemRequest

- (id)initWithItemIds:(NSArray *)item_ids
{
    self = [super init];
    if (self) {
        self.item_ids = item_ids;
    }
    return self;
}

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"stock.transfer_details_items";
    if (self.item_ids) {
        self.filter = @[@[@"id",@"in",self.item_ids]];
    }
    else
    {
        self.filter = @[];
    }
    self.field = @[];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}


- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary* dict = nil;
    if ([retArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray *oldItems = [dataManager fetchPurchaseMoveOrderItemsWithItemIds:self.item_ids];
        [dataManager deleteObjects:oldItems];
        for (NSDictionary *params in retArray)
        {
            CDPurchaseOrderMoveItem *item = [dataManager insertEntity:@"CDPurchaseOrderMoveItem"];
            item.item_id = [params numberValueForKey:@"id"];
            item.count = [params numberValueForKey:@"quantity"];
            
            NSArray *product = [params arrayValueForKey:@"product_id"];
            if (product.count > 0)
            {
                NSNumber *product_id = product[0];
                CDProjectItem *productItem = [dataManager findEntity:@"CDProjectItem" withValue:product_id forKey:@"itemID"];
                if (!productItem)
                {
                    productItem = [dataManager insertEntity:@"CDProjectItem"];
                    productItem.itemID = product_id;
                }
                productItem.itemName = product[1];
                item.product = productItem;
            }
            
            NSArray *srcloc= [params arrayValueForKey:@"sourceloc_id"];
            if (srcloc.count > 0)
            {
                item.src_location_id = srcloc[0];
                item.src_location_name = srcloc[1];
            }
            
            NSArray *desloc = [params arrayValueForKey:@"destinationloc_id"];
            if (desloc.count > 0) {
                item.dest_location_id = desloc[0];
                item.dest_location_name = desloc[1];
            }
            
            NSArray *transfer = [params arrayValueForKey:@"transfer_id"];
            if (transfer.count > 0)
            {
                item.transfer_id = transfer[0];
            }
        }
        
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMoveProductResponse object:nil userInfo:dict];
}

@end
