//
//  CDProjectUom.h
//  Boss
//
//  Created by XiaXianBing on 15/6/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDProjectUom : NSManagedObject

@property (nonatomic, retain) NSNumber * uomCategoryID;
@property (nonatomic, retain) NSString * uomCategoryName;
@property (nonatomic, retain) NSString * createDate;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * lastUpdate;
@property (nonatomic, retain) NSNumber * uomID;
@property (nonatomic, retain) NSString * uomName;
@property (nonatomic, retain) NSString * uomType;

@end
