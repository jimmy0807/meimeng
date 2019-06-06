//
//  CDImageCache.h
//  Boss
//
//  Created by jimmy on 15/5/11.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDImageCache : NSManagedObject

@property (nonatomic, retain) NSString * create_date;
@property (nonatomic, retain) NSString * imageName;

@end
