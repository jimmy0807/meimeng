//
//  CDCurrentUseItem+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 17/3/14.
//
//

#import "CDCurrentUseItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDCurrentUseItem (CoreDataProperties)

+ (NSFetchRequest<CDCurrentUseItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *defaultCode;
@property (nullable, nonatomic, copy) NSNumber *itemID;
@property (nullable, nonatomic, copy) NSString *itemName;
@property (nullable, nonatomic, copy) NSNumber *totalCount;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, copy) NSString *uomName;
@property (nullable, nonatomic, copy) NSNumber *useCount;
@property (nullable, nonatomic, copy) NSNumber *parent_id;
@property (nullable, nonatomic, retain) CDBook *book;
@property (nullable, nonatomic, retain) CDMemberCardProject *cardProject;
@property (nullable, nonatomic, retain) CDCouponCardProduct *couponProject;
@property (nullable, nonatomic, retain) CDPosOperate *posOperate;
@property (nullable, nonatomic, retain) CDProjectItem *projectItem;
@property (nullable, nonatomic, retain) NSOrderedSet<CDYimeiBuwei *> *yimei_buwei;

@end

@interface CDCurrentUseItem (CoreDataGeneratedAccessors)

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
