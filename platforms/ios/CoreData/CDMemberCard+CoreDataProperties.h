//
//  CDMemberCard+CoreDataProperties.h
//  Boss
//
//  Created by jimmy on 16/5/25.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMemberCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMemberCard (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *amount;
@property (nullable, nonatomic, retain) NSString *arrearsAmount;
@property (nullable, nonatomic, retain) NSString *balance;
@property (nullable, nonatomic, retain) NSNumber *buy_project_count;
@property (nullable, nonatomic, retain) NSString *captcha;
@property (nullable, nonatomic, retain) NSNumber *card_project_count;
@property (nullable, nonatomic, retain) NSNumber *cardID;
@property (nullable, nonatomic, retain) NSString *cardName;
@property (nullable, nonatomic, retain) NSString *cardNo;
@property (nullable, nonatomic, retain) NSString *cardNumber;
@property (nullable, nonatomic, retain) NSString *cardUUID;
@property (nullable, nonatomic, retain) NSString *courseArrearsAmount;
@property (nullable, nonatomic, retain) NSString *courseRemainAmount;
@property (nullable, nonatomic, retain) NSString *default_code;
@property (nullable, nonatomic, retain) NSString *giveAmount;
@property (nullable, nonatomic, retain) NSString *invalidDate;
@property (nullable, nonatomic, retain) NSNumber *is_employee_card;
@property (nullable, nonatomic, retain) NSNumber *is_share;
@property (nullable, nonatomic, retain) NSNumber *is_sign;
@property (nullable, nonatomic, retain) NSNumber *isActive;
@property (nullable, nonatomic, retain) NSNumber *isInvalid;
@property (nullable, nonatomic, retain) NSString *item_consume_amount;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *points;
@property (nullable, nonatomic, retain) NSString *product_consume_amount;
@property (nullable, nonatomic, retain) NSString *recharge_amount;
@property (nullable, nonatomic, retain) NSNumber *state;
@property (nullable, nonatomic, retain) NSNumber *storeID;
@property (nullable, nonatomic, retain) NSString *storeName;
@property (nullable, nonatomic, retain) NSString *use_start_time;
@property (nullable, nonatomic, retain) NSString *use_end_time;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberCardAmount *> *amounts;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberCardArrears *> *arrears;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberCardPoint *> *card_points;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberCardConsume *> *counsumes;
@property (nullable, nonatomic, retain) CDMember *member;
@property (nullable, nonatomic, retain) NSOrderedSet<CDPosOperate *> *operates;
@property (nullable, nonatomic, retain) CDMemberPriceList *priceList;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberCardProject *> *products;
@property (nullable, nonatomic, retain) NSOrderedSet<CDMemberCardProject *> *projects;
@property (nullable, nonatomic, retain) CDStore *store;
@property (nullable, nonatomic, retain) CDPosOperate *pad_operate;

@end

@interface CDMemberCard (CoreDataGeneratedAccessors)

- (void)insertObject:(CDMemberCardAmount *)value inAmountsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAmountsAtIndex:(NSUInteger)idx;
- (void)insertAmounts:(NSArray<CDMemberCardAmount *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAmountsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAmountsAtIndex:(NSUInteger)idx withObject:(CDMemberCardAmount *)value;
- (void)replaceAmountsAtIndexes:(NSIndexSet *)indexes withAmounts:(NSArray<CDMemberCardAmount *> *)values;
- (void)addAmountsObject:(CDMemberCardAmount *)value;
- (void)removeAmountsObject:(CDMemberCardAmount *)value;
- (void)addAmounts:(NSOrderedSet<CDMemberCardAmount *> *)values;
- (void)removeAmounts:(NSOrderedSet<CDMemberCardAmount *> *)values;

- (void)insertObject:(CDMemberCardArrears *)value inArrearsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromArrearsAtIndex:(NSUInteger)idx;
- (void)insertArrears:(NSArray<CDMemberCardArrears *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeArrearsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInArrearsAtIndex:(NSUInteger)idx withObject:(CDMemberCardArrears *)value;
- (void)replaceArrearsAtIndexes:(NSIndexSet *)indexes withArrears:(NSArray<CDMemberCardArrears *> *)values;
- (void)addArrearsObject:(CDMemberCardArrears *)value;
- (void)removeArrearsObject:(CDMemberCardArrears *)value;
- (void)addArrears:(NSOrderedSet<CDMemberCardArrears *> *)values;
- (void)removeArrears:(NSOrderedSet<CDMemberCardArrears *> *)values;

- (void)insertObject:(CDMemberCardPoint *)value inCard_pointsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCard_pointsAtIndex:(NSUInteger)idx;
- (void)insertCard_points:(NSArray<CDMemberCardPoint *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCard_pointsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCard_pointsAtIndex:(NSUInteger)idx withObject:(CDMemberCardPoint *)value;
- (void)replaceCard_pointsAtIndexes:(NSIndexSet *)indexes withCard_points:(NSArray<CDMemberCardPoint *> *)values;
- (void)addCard_pointsObject:(CDMemberCardPoint *)value;
- (void)removeCard_pointsObject:(CDMemberCardPoint *)value;
- (void)addCard_points:(NSOrderedSet<CDMemberCardPoint *> *)values;
- (void)removeCard_points:(NSOrderedSet<CDMemberCardPoint *> *)values;

- (void)insertObject:(CDMemberCardConsume *)value inCounsumesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCounsumesAtIndex:(NSUInteger)idx;
- (void)insertCounsumes:(NSArray<CDMemberCardConsume *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCounsumesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCounsumesAtIndex:(NSUInteger)idx withObject:(CDMemberCardConsume *)value;
- (void)replaceCounsumesAtIndexes:(NSIndexSet *)indexes withCounsumes:(NSArray<CDMemberCardConsume *> *)values;
- (void)addCounsumesObject:(CDMemberCardConsume *)value;
- (void)removeCounsumesObject:(CDMemberCardConsume *)value;
- (void)addCounsumes:(NSOrderedSet<CDMemberCardConsume *> *)values;
- (void)removeCounsumes:(NSOrderedSet<CDMemberCardConsume *> *)values;

- (void)insertObject:(CDPosOperate *)value inOperatesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromOperatesAtIndex:(NSUInteger)idx;
- (void)insertOperates:(NSArray<CDPosOperate *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeOperatesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInOperatesAtIndex:(NSUInteger)idx withObject:(CDPosOperate *)value;
- (void)replaceOperatesAtIndexes:(NSIndexSet *)indexes withOperates:(NSArray<CDPosOperate *> *)values;
- (void)addOperatesObject:(CDPosOperate *)value;
- (void)removeOperatesObject:(CDPosOperate *)value;
- (void)addOperates:(NSOrderedSet<CDPosOperate *> *)values;
- (void)removeOperates:(NSOrderedSet<CDPosOperate *> *)values;

- (void)insertObject:(CDMemberCardProject *)value inProductsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromProductsAtIndex:(NSUInteger)idx;
- (void)insertProducts:(NSArray<CDMemberCardProject *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeProductsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInProductsAtIndex:(NSUInteger)idx withObject:(CDMemberCardProject *)value;
- (void)replaceProductsAtIndexes:(NSIndexSet *)indexes withProducts:(NSArray<CDMemberCardProject *> *)values;
- (void)addProductsObject:(CDMemberCardProject *)value;
- (void)removeProductsObject:(CDMemberCardProject *)value;
- (void)addProducts:(NSOrderedSet<CDMemberCardProject *> *)values;
- (void)removeProducts:(NSOrderedSet<CDMemberCardProject *> *)values;

- (void)insertObject:(CDMemberCardProject *)value inProjectsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromProjectsAtIndex:(NSUInteger)idx;
- (void)insertProjects:(NSArray<CDMemberCardProject *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeProjectsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInProjectsAtIndex:(NSUInteger)idx withObject:(CDMemberCardProject *)value;
- (void)replaceProjectsAtIndexes:(NSIndexSet *)indexes withProjects:(NSArray<CDMemberCardProject *> *)values;
- (void)addProjectsObject:(CDMemberCardProject *)value;
- (void)removeProjectsObject:(CDMemberCardProject *)value;
- (void)addProjects:(NSOrderedSet<CDMemberCardProject *> *)values;
- (void)removeProjects:(NSOrderedSet<CDMemberCardProject *> *)values;

@end

NS_ASSUME_NONNULL_END
