//
//  CDMemberFollowContent+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/5/16.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberFollowContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberFollowContent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *content_id;
@property (nullable, nonatomic, retain) NSNumber *follow_id;
@property (nullable, nonatomic, retain) NSString *follow_name;
@property (nullable, nonatomic, retain) NSNumber *guwen_id;
@property (nullable, nonatomic, retain) NSString *guwen_name;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSNumber *shop_id;
@property (nullable, nonatomic, retain) NSString *shop_name;
@property (nullable, nonatomic, retain) NSString *date;

@end

NS_ASSUME_NONNULL_END
