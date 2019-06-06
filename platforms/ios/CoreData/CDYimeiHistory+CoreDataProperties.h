//
//  CDYimeiHistory+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2017/12/18.
//
//

#import "CDYimeiHistory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDYimeiHistory (CoreDataProperties)

+ (NSFetchRequest<CDYimeiHistory *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *amount;
@property (nullable, nonatomic, copy) NSNumber *card_id;
@property (nullable, nonatomic, copy) NSString *create_date;
@property (nullable, nonatomic, copy) NSString *create_name;
@property (nullable, nonatomic, copy) NSNumber *is_cancel_operate;
@property (nullable, nonatomic, copy) NSNumber *is_update_add_operate;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nameFirstLetter;
@property (nullable, nonatomic, copy) NSString *nameLetter;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSNumber *operate_id;
@property (nullable, nonatomic, copy) NSString *progre_status;
@property (nullable, nonatomic, copy) NSString *remark;
@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *statements;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSNumber *is_checkout;
@property (nullable, nonatomic, copy) NSNumber *is_post_checkout;
@property (nullable, nonatomic, retain) NSOrderedSet<CDYimeiHistoryBuyItem *> *buy_item;
@property (nullable, nonatomic, retain) NSOrderedSet<CDYimeiHistoryConsumeItem *> *consume_item;

@end

@interface CDYimeiHistory (CoreDataGeneratedAccessors)

- (void)insertObject:(CDYimeiHistoryBuyItem *)value inBuy_itemAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBuy_itemAtIndex:(NSUInteger)idx;
- (void)insertBuy_item:(NSArray<CDYimeiHistoryBuyItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBuy_itemAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBuy_itemAtIndex:(NSUInteger)idx withObject:(CDYimeiHistoryBuyItem *)value;
- (void)replaceBuy_itemAtIndexes:(NSIndexSet *)indexes withBuy_item:(NSArray<CDYimeiHistoryBuyItem *> *)values;
- (void)addBuy_itemObject:(CDYimeiHistoryBuyItem *)value;
- (void)removeBuy_itemObject:(CDYimeiHistoryBuyItem *)value;
- (void)addBuy_item:(NSOrderedSet<CDYimeiHistoryBuyItem *> *)values;
- (void)removeBuy_item:(NSOrderedSet<CDYimeiHistoryBuyItem *> *)values;

- (void)insertObject:(CDYimeiHistoryConsumeItem *)value inConsume_itemAtIndex:(NSUInteger)idx;
- (void)removeObjectFromConsume_itemAtIndex:(NSUInteger)idx;
- (void)insertConsume_item:(NSArray<CDYimeiHistoryConsumeItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeConsume_itemAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInConsume_itemAtIndex:(NSUInteger)idx withObject:(CDYimeiHistoryConsumeItem *)value;
- (void)replaceConsume_itemAtIndexes:(NSIndexSet *)indexes withConsume_item:(NSArray<CDYimeiHistoryConsumeItem *> *)values;
- (void)addConsume_itemObject:(CDYimeiHistoryConsumeItem *)value;
- (void)removeConsume_itemObject:(CDYimeiHistoryConsumeItem *)value;
- (void)addConsume_item:(NSOrderedSet<CDYimeiHistoryConsumeItem *> *)values;
- (void)removeConsume_item:(NSOrderedSet<CDYimeiHistoryConsumeItem *> *)values;

@end

NS_ASSUME_NONNULL_END
