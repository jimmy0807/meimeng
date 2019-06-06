//
//  CDMemberFollowPeroid+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/5/30.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberFollowPeroid.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberFollowPeroid (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *period_id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *special;

@end

NS_ASSUME_NONNULL_END
