//
//  BSFetchMoveDetailRequest.m
//  Boss
//
//  Created by lining on 15/7/17.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchMoveDetailRequest.h"
#import "BSFetchMoveItemRequest.h"

@interface BSFetchMoveDetailRequest ()
@property(nonatomic, strong) CDPurchaseOrderMove *moveOrder;
@end


@implementation BSFetchMoveDetailRequest

- (id) initWithMoveOrder:(CDPurchaseOrderMove *)moveOrder
{
    self = [super init];
    if (self) {
        self.moveOrder = moveOrder;
    }
    return self;
}

-(BOOL)willStart
{
    [super willStart];
    self.tableName = @"stock.transfer_details";
    self.filter = @[@[@"picking_id",@"=",self.moveOrder.move_id]];
    self.field = @[];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}


- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]])
    {
        NSDictionary *params = [retArray lastObject];
        self.moveOrder.transfer_id = [params numberValueForKey:@"id"];
        NSArray *pick_id = [params arrayValueForKey:@"picking_id"];
        if (pick_id.count > 0) {
            self.moveOrder.name = pick_id[1];
        }
        
        NSArray *item_ids = [params arrayValueForKey:@"item_ids"];
        self.moveOrder.item_ids = [item_ids componentsJoinedByString:@","];
        
        
        [[BSCoreDataManager currentManager] save:nil];
        
        BSFetchMoveItemRequest *req = [[BSFetchMoveItemRequest alloc] initWithItemIds:item_ids];
        [req execute];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMoveDetailResponse object:nil userInfo:dict];
    }
}
@end
