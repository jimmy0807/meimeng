//
//  CDHGuadan+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/8/24.
//
//

#import "CDHGuadan+CoreDataClass.h"
@class CDHGuadanProduct;

NS_ASSUME_NONNULL_BEGIN

@interface CDHGuadan (CoreDataProperties)

+ (NSFetchRequest<CDHGuadan *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *card_id;
@property (nullable, nonatomic, copy) NSNumber *departments_id;
@property (nullable, nonatomic, copy) NSString *departments_name;
@property (nullable, nonatomic, copy) NSNumber *designers_id;
@property (nullable, nonatomic, copy) NSString *designers_name;
@property (nullable, nonatomic, copy) NSNumber *director_employee_id;
@property (nullable, nonatomic, copy) NSString *director_employee_name;
@property (nullable, nonatomic, copy) NSNumber *doctor_id;
@property (nullable, nonatomic, copy) NSString *doctor_name;
@property (nullable, nonatomic, copy) NSNumber *employee_id;
@property (nullable, nonatomic, copy) NSString *employee_name;
@property (nullable, nonatomic, copy) NSNumber *guadan_id;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *nameFirstLetter;
@property (nullable, nonatomic, copy) NSString *nameLetter;
@property (nullable, nonatomic, copy) NSString *no;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSString *queue_no;
@property (nullable, nonatomic, copy) NSString *remark;
@property (nullable, nonatomic, copy) NSNumber *sort_index;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *display_note;
@property (nullable, nonatomic, retain) NSOrderedSet<CDHGuadanProduct *> *card_items;
@property (nullable, nonatomic, retain) NSOrderedSet<CDHGuadanProduct *> *items;

@end

@interface CDHGuadan (CoreDataGeneratedAccessors)

- (void)insertObject:(CDHGuadanProduct *)value inCard_itemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCard_itemsAtIndex:(NSUInteger)idx;
- (void)insertCard_items:(NSArray<CDHGuadanProduct *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCard_itemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCard_itemsAtIndex:(NSUInteger)idx withObject:(CDHGuadanProduct *)value;
- (void)replaceCard_itemsAtIndexes:(NSIndexSet *)indexes withCard_items:(NSArray<CDHGuadanProduct *> *)values;
- (void)addCard_itemsObject:(CDHGuadanProduct *)value;
- (void)removeCard_itemsObject:(CDHGuadanProduct *)value;
- (void)addCard_items:(NSOrderedSet<CDHGuadanProduct *> *)values;
- (void)removeCard_items:(NSOrderedSet<CDHGuadanProduct *> *)values;

- (void)insertObject:(CDHGuadanProduct *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray<CDHGuadanProduct *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(CDHGuadanProduct *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray<CDHGuadanProduct *> *)values;
- (void)addItemsObject:(CDHGuadanProduct *)value;
- (void)removeItemsObject:(CDHGuadanProduct *)value;
- (void)addItems:(NSOrderedSet<CDHGuadanProduct *> *)values;
- (void)removeItems:(NSOrderedSet<CDHGuadanProduct *> *)values;

@end

NS_ASSUME_NONNULL_END
