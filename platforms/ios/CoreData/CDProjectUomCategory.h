//
//  CDProjectUomCategory.h
//  Boss
//
//  Created by XiaXianBing on 15/6/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDProjectUomCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * uomCategoryID;
@property (nonatomic, retain) NSString * uomCategoryName;
@property (nonatomic, retain) NSString * createDate;
@property (nonatomic, retain) NSString * lastUpdate;

@end
