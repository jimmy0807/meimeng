//
//  CDProjectAttributePrice.h
//  Boss
//
//  Created by XiaXianBing on 15/8/5.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDProjectAttributeValue;

@interface CDProjectAttributePrice : NSManagedObject

@property (nonatomic, retain) NSNumber * attributePriceID;
@property (nonatomic, retain) NSString * attributePriceName;
@property (nonatomic, retain) NSNumber * attributeValueID;
@property (nonatomic, retain) NSString * attributeValueName;
@property (nonatomic, retain) NSString * createDate;
@property (nonatomic, retain) NSNumber * extraPrice;
@property (nonatomic, retain) NSString * lastUpdate;
@property (nonatomic, retain) NSNumber * templateID;
@property (nonatomic, retain) NSString * templateName;
@property (nonatomic, retain) CDProjectAttributeValue *attributeValue;

@end
