//
//  BSHandlePurchaseOrderRequest.m
//  Boss
//
//  Created by lining on 15/6/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSHandlePurchaseOrderRequest.h"
#import "BSFetchMoveOrderRequest.h"
#import "BSFetchMoveDetailRequest.h"

@interface BSHandlePurchaseOrderRequest ()
@property(nonatomic, strong) NSNumber *number;
@end

@implementation BSHandlePurchaseOrderRequest


-(id)initWithPurchaseOrder:(CDPurchaseOrder *)purchaseOrder type:(HandleType)type
{
    self = [super init];
    if (self) {
        self.purchaseOrder = purchaseOrder;
        self.type = type;
        self.number = self.purchaseOrder.orderId;
    }
    return self;
}


- (id)initWithID:(NSNumber *)number type:(HandleType)type
{
    self = [super init];
    if (self) {
        self.number = number;
        self.type = type;
    }
    return self;
}


-(BOOL)willStart
{
    [super willStart];
    
    self.tableName = @"purchase.order";
    if (self.type == HandleType_create) {
        [self sendShopAssistantXmlCreateCommand:@[self.params]];
    }
    else if (self.type == HandleType_edit)
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.purchaseOrder.orderId],self.params]];
    }
    else if (self.type == HandleType_commit)
    {
        NSLog(@"提交草稿订单");
        self.xmlStyle = @"purchase_confirm";
        [self sendRpcXmlCommand:@"/xmlrpc/2/object" method:@"exec_workflow" params:@[self.purchaseOrder.orderId]];
        
    }
    else if (self.type == HandleType_delete)
    {
        NSLog(@"删除草稿订单");
        self.xmlStyle = @"unlink";
        [self sendRpcXmlCommand:@"/xmlrpc/2/object" method:@"execute" params:@[@[@[self.purchaseOrder.orderId]]]];
    }
    else if (self.type == HandleType_cancel)
    {
        NSLog(@"取消待审核订单");
        self.xmlStyle = @"action_cancel_draft";
        [self sendRpcXmlCommand:@"/xmlrpc/2/object" method:@"execute" params:@[@[self.purchaseOrder.orderId]]];
    }
    else if (self.type == HandleType_confirm)
    {
        NSLog(@"批准审核订单");
        self.xmlStyle = @"purchase_approve";
        [self sendRpcXmlCommand:@"/xmlrpc/2/object" method:@"exec_workflow" params:@[self.purchaseOrder.orderId]];
    }
    else if (self.type == HandleType_input)
    {
        NSLog(@"入库");
        self.xmlStyle = @"view_picking";
        [self sendRpcXmlCommand:@"/xmlrpc/2/object" method:@"execute" params:@[self.purchaseOrder.orderId]];
    }
    else if (self.type == HandleType_translate)
    {
        NSLog(@"移动");
        self.tableName = @"stock.picking";
        self.xmlStyle = @"do_enter_transfer_details";
        
        [self sendRpcXmlCommand:@"/xmlrpc/2/object" method:@"execute" params:@[@[self.number]]];
    }
    else if (self.type == HandleType_moveDone)
    {
        NSLog(@"移动完成");
        self.tableName = @"stock.transfer_details";
//        self.xmlStyle = @"do_detailed_transfer";
        self.xmlStyle = @"do_detailed_transfer_by_id";
        [self sendRpcXmlCommand:@"/xmlrpc/2/object" method:@"execute" params:@[@[self.number],self.params]];
//        [self sendShopAssistantXmlWriteCommand:@[@[self.number],self.params]];
    }

    return TRUE;
}


-(void)didFinishOnMainThread
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    id resultArray =[BNXmlRpc arrayWithXmlRpc:resultStr];
    
    if (self.type == HandleType_create) {
        
        NSLog(@"%@",resultStr);
        if ( [resultArray isKindOfClass:[NSNumber class]])
        {
            [dict setValue:@0 forKey:@"rc"];
            [dict setValue:@"创建成功" forKey:@"rm"];
            self.purchaseOrder.orderId = resultArray;
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            dict = [self generateResponse:@"创建失败，请稍后重试"];
           
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSCreatePurchaseOrderResponse object:self userInfo:dict];
    }
    else if (self.type == HandleType_edit)
    {
        
        NSLog(@"%@",resultStr);
        if ( [resultArray isKindOfClass:[NSNumber class]])
        {
            
            [dict setValue:@0 forKey:@"rc"];
            [[BSCoreDataManager currentManager] deleteObjects:self.purchaseOrder.orderlines.array];
            [dict setValue:@"编辑成功" forKey:@"rm"];
        }
        else
        {
          
            dict = [self generateResponse:@"请求失败，请稍后重试"];
           
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSEditPurchaseOrderResponse object:self userInfo:dict];
    }
    else if (self.type == HandleType_commit)
    {
        if ([resultArray isKindOfClass:[NSNumber class]])
        {
            [dict setValue:@0 forKey:@"rc"];
            [dict setValue:@"提交成功" forKey:@"rm"];
            //        self.provider.provider_id = resultArray;
            self.purchaseOrder.state = @"approved";
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
           
            dict = [self generateResponse:@"数据请求失败，请稍后重试"];
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSCommitPurchaseOrderResponse object:self userInfo:dict];
    }
    else if (self.type == HandleType_delete)
    {
        if ( [resultArray isKindOfClass:[NSNumber class]])
        {
            [dict setValue:@0 forKey:@"rc"];
            [dict setValue:@"删除成功" forKey:@"rm"];
            [[BSCoreDataManager currentManager] deleteObject:self.purchaseOrder];
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            
            dict = [self generateResponse:@"删除失败，请稍后重试"];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:kBSDeletePurchaseOrderResponse object:self userInfo:dict];
    }
    else if (self.type == HandleType_cancel)
    {
        if ( [resultArray isKindOfClass:[NSNumber class]])
        {
            [dict setValue:@0 forKey:@"rc"];
            [dict setValue:@"驳回成功" forKey:@"rm"];
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            dict = [self generateResponse:@"驳回失败，请稍后重试"];
            
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSCancelPurchaseOrderResponse object:self userInfo:dict];
    }
    else if (self.type == HandleType_confirm)
    {
        if ( [resultArray isKindOfClass:[NSNumber class]])
        {
            [dict setValue:@0 forKey:@"rc"];
            [dict setValue:@"审核成功" forKey:@"rm"];
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            dict = [self generateResponse:@"审核失败，请稍后重试"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSConfirmedPurchaseOrderResponse object:nil userInfo:dict];
    }
    else if (self.type == HandleType_input)
    {
        if ([resultArray isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)resultArray;
            self.number = [dict numberValueForKey:@"res_id"]; //如果已经有部分商品入库，res_id返回为0； 若第一次入库res_id即为移动产品操作的id
            if ([self.number integerValue] == 0)
            {
                BSFetchMoveOrderRequest *req = [[BSFetchMoveOrderRequest alloc] initWithPurchaseOrder:self.purchaseOrder];
                [req execute];
                
            }
            else
            {
                CDPurchaseOrderMove *moveOrder = [[BSCoreDataManager currentManager] findEntity:@"CDPurchaseOrderMove" withValue:self.number forKey:@"move_id"];
                if (!moveOrder) {
                    moveOrder = [[BSCoreDataManager currentManager] insertEntity:@"CDPurchaseOrderMove"];
                    moveOrder.move_id = self.number;
                }
                
                [[BSCoreDataManager currentManager] save:nil];
                
                //第一次入库
                //移动
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSInputPurchaseOrderResponse object:moveOrder userInfo:dict];
                [[[BSHandlePurchaseOrderRequest alloc] initWithID:moveOrder.move_id type:HandleType_translate] execute];
                
                
            }
        }
        else
        {
            dict = [self generateResponse:@"数据请求失败，请稍后重试"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSInputPurchaseOrderResponse object:nil userInfo:dict];
        }
        
    }
    else if (self.type == HandleType_translate)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSTranslatePurchaseOrderResponse object:nil];
    }
    else if (self.type == HandleType_moveDone)
    {
        if ( [resultArray isKindOfClass:[NSNumber class]])
        {
            [dict setValue:@0 forKey:@"rc"];
            [[BSCoreDataManager currentManager] deleteObject:self.purchaseOrder];
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            dict = [self generateResponse:@"数据请求失败，请稍后重试"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSMoveDoneReponse object:nil userInfo:dict];
    }
}
@end
