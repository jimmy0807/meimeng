//
//  BSFetchPadOrderLineRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/18.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchPadOrderLineRequest.h"

@interface BSFetchPadOrderLineRequest ()

@property (nonatomic, strong) NSArray *orderLineIds;

@end

@implementation BSFetchPadOrderLineRequest

- (id)initWithPadOrderLineIds:(NSArray *)orderLineIds
{
    self = [super init];
    if (self)
    {
        self.orderLineIds = orderLineIds;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"pad.order.line";
    self.filter = @[@[@"id", @"in", self.orderLineIds]];
    self.field = @[];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (resultStr.length != 0 && resultList != nil)
    {
        BSCoreDataManager *coreDateManager = [BSCoreDataManager currentManager];
        for (NSDictionary *params in resultList)
        {
            NSNumber *orderID = [NSNumber numberWithInteger:[[[params objectForKey:@"pad_order_id"] objectAtIndex:0] integerValue]];
            CDPosOperate *posOperate = [coreDateManager findEntity:@"CDPosOperate" withValue:orderID forKey:@"orderID"];
            if (posOperate == nil)
            {
                continue;
            }
            
            NSNumber *productID = [NSNumber numberWithInteger:[[[params objectForKey:@"product_id"] objectAtIndex:0] integerValue]];
            CDPosProduct *product = [coreDateManager insertEntity:@"CDPosProduct"];
            product.product_id = productID;
            product.product_name = [[params objectForKey:@"product_id"] objectAtIndex:1];
            product.product_discount = [NSNumber numberWithFloat:10.0];
            product.product_qty = [NSNumber numberWithInteger:[[params objectForKey:@"qty"] integerValue]];
            product.product_price = [NSNumber numberWithDouble:[[params objectForKey:@"open_price"] doubleValue]];
            CDProjectItem *item = [coreDateManager findEntity:@"CDProjectItem" withValue:productID forKey:@"itemID"];
            if (item == nil)
            {
                item = [coreDateManager insertEntity:@"CDProjectItem"];
                item.itemID = productID;
                item.itemName = [[params objectForKey:@"product_id"] objectAtIndex:1];
            }
            else
            {
                product.defaultCode = item.defaultCode;
            }
            
            if (product.defaultCode.length == 0)
            {
                product.defaultCode = @"0";
            }
            
            product.product = item;
            
            NSMutableOrderedSet *mutableOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:posOperate.products];
            [mutableOrderedSet addObject:product];
            
            posOperate.products = mutableOrderedSet;
        }
        [coreDateManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPadOrderLineResponse object:self userInfo:dict];
}

@end
