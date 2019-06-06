//
//  CDMetric.h
//  Boss
//
//  Created by lining on 15/6/18.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDMetric : NSManagedObject

@property (nonatomic, retain) NSNumber * categoryType;
@property (nonatomic, retain) NSNumber * metricId;
@property (nonatomic, retain) NSString * name;

@end
