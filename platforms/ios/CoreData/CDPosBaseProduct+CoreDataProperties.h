//
//  CDPosBaseProduct+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2017/11/13.
//
//

#import "CDPosBaseProduct+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDPosBaseProduct (CoreDataProperties)

+ (NSFetchRequest<CDPosBaseProduct *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *buy_price;
@property (nullable, nonatomic, copy) NSNumber *company_id;
@property (nullable, nonatomic, copy) NSString *company_name;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSNumber *line_id;
@property (nullable, nonatomic, copy) NSNumber *money_total;
@property (nullable, nonatomic, copy) NSNumber *operate_id;
@property (nullable, nonatomic, copy) NSString *operate_name;
@property (nullable, nonatomic, copy) NSString *part_display_name;
@property (nullable, nonatomic, copy) NSNumber *pay_id;
@property (nullable, nonatomic, copy) NSNumber *pay_type;
@property (nullable, nonatomic, copy) NSNumber *product_discount;
@property (nullable, nonatomic, copy) NSNumber *product_id;
@property (nullable, nonatomic, copy) NSString *product_name;
@property (nullable, nonatomic, copy) NSNumber *product_price;
@property (nullable, nonatomic, copy) NSNumber *product_qty;
@property (nullable, nonatomic, copy) NSNumber *qty;
@property (nullable, nonatomic, copy) NSNumber *shop_id;
@property (nullable, nonatomic, copy) NSString *shop_name;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSNumber *coupon_deduction;
@property (nullable, nonatomic, copy) NSNumber *coupon_id;
@property (nullable, nonatomic, copy) NSNumber *point_deduction;
@property (nullable, nonatomic, retain) CDPosOperate *operate;
@property (nullable, nonatomic, retain) CDProjectItem *product;
@property (nullable, nonatomic, retain) NSOrderedSet<CDYimeiBuwei *> *yimei_buwei;

@end

@interface CDPosBaseProduct (CoreDataGeneratedAccessors)

- (void)insertObject:(CDYimeiBuwei *)value inYimei_buweiAtIndex:(NSUInteger)idx;
- (void)removeObjectFromYimei_buweiAtIndex:(NSUInteger)idx;
- (void)insertYimei_buwei:(NSArray<CDYimeiBuwei *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeYimei_buweiAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInYimei_buweiAtIndex:(NSUInteger)idx withObject:(CDYimeiBuwei *)value;
- (void)replaceYimei_buweiAtIndexes:(NSIndexSet *)indexes withYimei_buwei:(NSArray<CDYimeiBuwei *> *)values;
- (void)addYimei_buweiObject:(CDYimeiBuwei *)value;
- (void)removeYimei_buweiObject:(CDYimeiBuwei *)value;
- (void)addYimei_buwei:(NSOrderedSet<CDYimeiBuwei *> *)values;
- (void)removeYimei_buwei:(NSOrderedSet<CDYimeiBuwei *> *)values;

@end

NS_ASSUME_NONNULL_END
