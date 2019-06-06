//
//  CDAssessor.h
//  Boss
//
//  Created by lining on 15/6/16.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPurchaseOrder;

@interface CDAssessor : NSManagedObject

@property (nonatomic, retain) NSNumber * assossor_id;
@property (nonatomic, retain) NSString * assossor_name;
@property (nonatomic, retain) CDPurchaseOrder *purchaseOrder;

@end
