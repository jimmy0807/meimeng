//
//  CDRepository.h
//  Boss
//
//  Created by lining on 15/7/2.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPurchaseOrder;

@interface CDRepository : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * pick_id;
@property (nonatomic, retain) NSString * pick_name;
@property (nonatomic, retain) NSNumber * repository_id;
@property (nonatomic, retain) NSSet *purchaseOrder;
@end

@interface CDRepository (CoreDataGeneratedAccessors)

- (void)addPurchaseOrderObject:(CDPurchaseOrder *)value;
- (void)removePurchaseOrderObject:(CDPurchaseOrder *)value;
- (void)addPurchaseOrder:(NSSet *)values;
- (void)removePurchaseOrder:(NSSet *)values;

@end
