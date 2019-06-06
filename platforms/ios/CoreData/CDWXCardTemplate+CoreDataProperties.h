//
//  CDWXCardTemplate+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/6/2.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDWXCardTemplate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDWXCardTemplate (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *card_type;
@property (nullable, nonatomic, retain) NSString *deal_detail;
@property (nullable, nonatomic, retain) NSString *default_detail;
@property (nullable, nonatomic, retain) NSString *description_detail;
@property (nullable, nonatomic, retain) NSString *gift_detail;
@property (nullable, nonatomic, retain) NSNumber *sortIndex;
@property (nullable, nonatomic, retain) NSNumber *template_id;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *wxcard_id;
@property (nullable, nonatomic, retain) NSNumber *quantity;
@property (nullable, nonatomic, retain) NSNumber *current_quantity;

@end

NS_ASSUME_NONNULL_END
