//
//  CDMessageTemplate+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/8/10.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMessageTemplate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMessageTemplate (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *message_id;
@property (nullable, nonatomic, retain) NSString *template_content;
@property (nullable, nonatomic, retain) NSString *template_id;
@property (nullable, nonatomic, retain) NSString *template_name;
@property (nullable, nonatomic, retain) NSString *template_type;
@property (nullable, nonatomic, retain) NSString *descs;

@end

NS_ASSUME_NONNULL_END
