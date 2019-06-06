//
//  CDProjectTemplate+CoreDataClass.h
//  meim
//
//  Created by lining on 2017/1/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDProjectAttributeLine, CDProjectCategory, CDProjectConsumable, CDProjectItem;

NS_ASSUME_NONNULL_BEGIN

@interface CDProjectTemplate : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "CDProjectTemplate+CoreDataProperties.h"
