//
//  CDProvider.h
//  Boss
//
//  Created by lining on 15/7/3.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPurchaseOrder;

@interface CDProvider : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * contact;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * job;
@property (nonatomic, retain) NSString * logoName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * product_pricelist_id;
@property (nonatomic, retain) NSNumber * provider_id;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * write_date;
@property (nonatomic, retain) NSSet *purchaseOrder;
@end

@interface CDProvider (CoreDataGeneratedAccessors)

- (void)addPurchaseOrderObject:(CDPurchaseOrder *)value;
- (void)removePurchaseOrderObject:(CDPurchaseOrder *)value;
- (void)addPurchaseOrder:(NSSet *)values;
- (void)removePurchaseOrder:(NSSet *)values;

@end
