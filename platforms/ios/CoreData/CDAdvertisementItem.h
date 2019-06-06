//
//  CDAdvertisementItem.h
//  Boss
//
//  Created by jimmy on 15/8/20.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDAdvertisement;

@interface CDAdvertisementItem : NSManagedObject

@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * itemID;
@property (nonatomic, retain) NSString * linkUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * writeDate;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) CDAdvertisement *parent;

@end
