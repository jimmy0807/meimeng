//
//  CDPurchaseOrderMove.h
//  Boss
//
//  Created by lining on 15/8/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDPurchaseOrderMove : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * item_ids;
@property (nonatomic, retain) NSNumber * move_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * origin;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * transfer_id;

@end
