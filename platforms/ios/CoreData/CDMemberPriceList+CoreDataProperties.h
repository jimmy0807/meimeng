//
//  CDMemberPriceList+CoreDataProperties.h
//  Boss
//
//  Created by XiaXianBing on 2016-4-13.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberPriceList.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberPriceList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *canUse;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *priceID;
@property (nullable, nonatomic, retain) NSNumber *refill_money;
@property (nullable, nonatomic, retain) NSNumber *start_money;
@property (nullable, nonatomic, retain) NSNumber *points2Money;
@property (nullable, nonatomic, retain) NSSet<CDMemberCard *> *card;

@end

@interface CDMemberPriceList (CoreDataGeneratedAccessors)

- (void)addCardObject:(CDMemberCard *)value;
- (void)removeCardObject:(CDMemberCard *)value;
- (void)addCard:(NSSet<CDMemberCard *> *)values;
- (void)removeCard:(NSSet<CDMemberCard *> *)values;

@end

NS_ASSUME_NONNULL_END
