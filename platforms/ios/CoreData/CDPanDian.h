//
//  CDPanDian.h
//  Boss
//
//  Created by XiaXianBing on 15/9/16.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDStorage;

@interface CDPanDian : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * filter;
@property (nonatomic, retain) NSString * line_ids;
@property (nonatomic, retain) NSNumber * location_id;
@property (nonatomic, retain) NSString * location_name;
@property (nonatomic, retain) NSNumber * lot_id;
@property (nonatomic, retain) NSString * move_ids;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * package_id;
@property (nonatomic, retain) NSNumber * partner_id;
@property (nonatomic, retain) NSNumber * pd_id;
@property (nonatomic, retain) NSNumber * period_id;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * total_count;
@property (nonatomic, retain) CDStorage *storage;

@end
