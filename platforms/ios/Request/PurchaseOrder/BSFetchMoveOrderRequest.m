//
//  BSFetchMoveOrderRequest.m
//  Boss
//
//  Created by lining on 15/7/17.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchMoveOrderRequest.h"
#import "BSFetchMoveDetailRequest.h"


@interface BSFetchMoveOrderRequest ()
@property(nonatomic, strong) CDPurchaseOrder *purchaseOrder;
@end
@implementation BSFetchMoveOrderRequest
- (id)initWithPurchaseOrder:(CDPurchaseOrder *)purchaseOrder
{
    self = [super init];
    if (self) {
        self.purchaseOrder = purchaseOrder;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"stock.picking";
    self.filter = @[@[@"origin",@"=",self.purchaseOrder.name]];
    self.field = @[];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}


- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = nil;
    if ([retArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSArray *oldData = [dataManager fetchPurchaseMoveOrdersWithOrigin:self.purchaseOrder.name];
        [dataManager deleteObjects:oldData];
        for (NSDictionary *params in retArray)
        {
            CDPurchaseOrderMove *orderMove = [dataManager insertEntity:@"CDPurchaseOrderMove"];
            orderMove.move_id = [params numberValueForKey:@"id"];
            orderMove.name = [params stringValueForKey:@"name"];
            orderMove.origin = [params stringValueForKey:@"origin"];
            orderMove.state = [params stringValueForKey:@"state"];
            
        }
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMoveOrderResponse object:nil userInfo:dict];
}

@end
