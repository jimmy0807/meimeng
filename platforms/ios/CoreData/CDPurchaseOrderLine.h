//
//  CDPurchaseOrderLine.h
//  Boss
//
//  Created by lining on 15/7/22.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDProjectItem, CDPurchaseOrder, CDPurchaseOrderTax;

@interface CDPurchaseOrderLine : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSNumber * line_id;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * totalMoney;
@property (nonatomic, retain) NSNumber * total_tax;
@property (nonatomic, retain) NSNumber * total_untax;
@property (nonatomic, retain) CDPurchaseOrder *order;
@property (nonatomic, retain) CDProjectItem *product;
@property (nonatomic, retain) CDPurchaseOrderTax *tax;

@end
