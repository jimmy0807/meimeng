//
//  CDPurchaseOrder.m
//  Boss
//
//  Created by lining on 15/7/28.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "CDPurchaseOrder.h"
#import "CDAssessor.h"
#import "CDProvider.h"
#import "CDPurchaseOrderLine.h"
#import "CDStorage.h"
#import "CDStore.h"
#import "CDWarehouse.h"


@implementation CDPurchaseOrder

@dynamic amount_tax;
@dynamic amount_total;
@dynamic amount_untax;
@dynamic approve_date;
@dynamic date_order;
@dynamic name;
@dynamic order_line;
@dynamic orderId;
@dynamic orderNo;
@dynamic pricelist;
@dynamic shipped;
@dynamic shipped_rate;
@dynamic state;
@dynamic validator_name;
@dynamic assessor;
@dynamic orderlines;
@dynamic provider;
@dynamic warehouse;
@dynamic shop;
@dynamic storage;

@end
