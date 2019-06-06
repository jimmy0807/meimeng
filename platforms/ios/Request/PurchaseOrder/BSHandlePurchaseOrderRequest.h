//
//  BSHandlePurchaseOrderRequest.h
//  Boss
//
//  Created by lining on 15/6/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

typedef enum HandleType
{
    HandleType_create,      //创建订单草稿
    HandleType_edit,        //编辑订单草稿
    HandleType_commit,      //提交订单草稿
    HandleType_delete,      //删除订单草稿
    HandleType_cancel,      //将待审核订单取消为订单草稿
    HandleType_confirm,     //订单审核
    HandleType_input,       //入库
    HandleType_translate,   //移动
    HandleType_moveDone,    //移动完成
//    HandleType_Read,
//    HandleType_MoveLine,
    
}HandleType;

@interface BSHandlePurchaseOrderRequest : ICRequest
-(id)initWithPurchaseOrder:(CDPurchaseOrder *)purchaseOrder type:(HandleType)type;
-(id)initWithID:(NSNumber *)number type:(HandleType)type;

@property(nonatomic, strong) NSDictionary *params;
@property(nonatomic, assign) HandleType type;
@property(nonatomic, strong) CDPurchaseOrder *purchaseOrder;


@end
