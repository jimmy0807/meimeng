//
//  CDPurchaseOrderMoveItem.h
//  Boss
//
//  Created by lining on 15/7/22.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDProjectItem;

@interface CDPurchaseOrderMoveItem : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * dest_location_id;
@property (nonatomic, retain) NSString * dest_location_name;
@property (nonatomic, retain) NSNumber * item_id;
@property (nonatomic, retain) NSNumber * src_location_id;
@property (nonatomic, retain) NSString * src_location_name;
@property (nonatomic, retain) NSNumber * transfer_id;
@property (nonatomic, retain) CDProjectItem *product;

@end
