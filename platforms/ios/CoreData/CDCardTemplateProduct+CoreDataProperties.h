//
//  CDCardTemplateProduct+CoreDataProperties.h
//  Boss
//
//  Created by lining on 16/4/1.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDCardTemplateProduct.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDCardTemplateProduct (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *count;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSNumber *product_id;
@property (nullable, nonatomic, retain) NSString *product_name;
@property (nullable, nonatomic, retain) NSNumber *template_id;
@property (nullable, nonatomic, retain) NSString *template_name;
@property (nullable, nonatomic, retain) NSNumber *line_id;
@property (nullable, nonatomic, retain) NSNumber *qty;
@property (nullable, nonatomic, retain) NSNumber *price_unit;
@property (nullable, nonatomic, retain) CDCardTemplate *card_template;

@end

NS_ASSUME_NONNULL_END
